use uuid::Uuid;
use sqlx::PgPool;
use serde_json::json;
use crate::error::AppError;
use crate::models::dtos::CreateOrderReq;
use crate::repositories::outbox_repo::OutboxRepo;

pub struct OrderService;

impl OrderService {
    pub async fn create_and_allocate(pool: &PgPool, req: CreateOrderReq) -> Result<Uuid, AppError> {
        let mut tx = pool.begin().await?;

        // 1. Insert order
        let order_id = sqlx::query!(
            r#"
            INSERT INTO orders (customer_name)
            VALUES ($1)
            RETURNING id
            "#,
            req.customer_name
        )
        .fetch_one(&mut *tx)
        .await?.id;

        for item in &req.items {
            if item.required_qty <= 0 {
                return Err(AppError::DomainError("Required quantity must be positive".to_string()));
            }

            sqlx::query!(
                r#"
                INSERT INTO order_items (order_id, product_id, required_qty)
                VALUES ($1, $2, $3)
                "#,
                order_id,
                item.product_id,
                item.required_qty
            )
            .execute(&mut *tx)
            .await?;
        }

        // 2. Create Container for this order
        let container_id = sqlx::query!(
            r#"
            INSERT INTO containers (order_id, current_status)
            VALUES ($1, 'PICKING'::container_status)
            RETURNING id
            "#,
            order_id
        )
        .fetch_one(&mut *tx)
        .await?.id;

        // 3. FEFO Allocation Loop
        for item in req.items {
            let mut remaining_qty = item.required_qty;

            // Fetch available inventory ordered by expiry (FEFO) then quantity
            let balances = sqlx::query!(
                r#"
                SELECT id, batch_number, quantity 
                FROM inventory_balances
                WHERE product_id = $1 AND status = 'AVAILABLE'::inventory_status AND quantity > 0
                ORDER BY expiry_date ASC, quantity DESC
                FOR UPDATE
                "#,
                item.product_id
            )
            .fetch_all(&mut *tx)
            .await?;

            for balance in balances {
                if remaining_qty <= 0 {
                    break;
                }

                let allocate_qty = std::cmp::min(remaining_qty, balance.quantity);
                remaining_qty -= allocate_qty;

                // Deduct from inventory
                sqlx::query!(
                    r#"
                    UPDATE inventory_balances
                    SET quantity = quantity - $1
                    WHERE id = $2
                    "#,
                    allocate_qty,
                    balance.id
                )
                .execute(&mut *tx)
                .await?;

                // Create Pick Task mapped to this specific batch/inventory
                sqlx::query!(
                    r#"
                    INSERT INTO pick_tasks (container_id, product_id, inventory_balance_id, batch_number, required_qty, picked_qty, status)
                    VALUES ($1, $2, $3, $4, $5, 0, 'PENDING'::task_status)
                    "#,
                    container_id,
                    item.product_id,
                    balance.id,
                    balance.batch_number,
                    allocate_qty
                )
                .execute(&mut *tx)
                .await?;
            }

            // Rollback via error if we couldn't fulfill the required quantity
            if remaining_qty > 0 {
                return Err(AppError::DomainError(format!("Insufficient stock for product {}", item.product_id)));
            }
        }

        // 4. CQRS Event
        OutboxRepo::insert_event(
            &mut tx,
            "ORDER_ALLOCATED",
            json!({
                "order_id": order_id,
                "container_id": container_id
            })
        ).await?;

        // 5. Commit
        tx.commit().await?;

        Ok(order_id)
    }
}
