use crate::error::AppError;
use sqlx::{PgPool, Row};
use shared::database::inject_audit_context;

/// Data model for an outbound request
pub struct OutboundRequest {
    pub product_id: i32,
    pub target_qty: i32,
    pub to_location_id: Option<i32>, // None for actual outbound/disposal, Some for relocate
    pub task_type: String,           // 'OUTBOUND', 'RELOCATE', etc.
}

/// Core Inventory Service responsible for FEFO allocation and transactions
pub struct InventoryService;

impl InventoryService {

    /// Executes an outbound operation using FEFO (First Expired, First Out) strategy.
    /// Uses Row-Level Locking (FOR UPDATE SKIP LOCKED) to prevent concurrent allocation deadlocks.
    pub async fn execute_outbound(
        pool: &PgPool,
        user_id: i32,
        req: OutboundRequest,
    ) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        // 1. Inject Audit Context
        inject_audit_context(&mut tx, user_id).await?;

        // 2. Insert the Warehouse Task
        let task_record = sqlx::query(
            r#"
            INSERT INTO warehouse_tasks (task_type, target_qty, to_location_id, status, created_by)
            VALUES ($1, $2, $3, 'IN_PROGRESS', $4)
            RETURNING task_id
            "#,
        )
        .bind(&req.task_type)
        .bind(req.target_qty)
        .bind(req.to_location_id)
        .bind(user_id)
        .fetch_one(&mut *tx)
        .await?;

        let task_id: i32 = task_record.try_get("task_id")?;
        let mut remaining_qty = req.target_qty;

        // 3. FEFO Allocation loop
        let available_batches = sqlx::query(
            r#"
            SELECT balance_id, batch_id, location_id, available_qty
            FROM inventory_balances
            WHERE product_id = $1 
              AND status = 'Released' 
              AND available_qty > 0
            ORDER BY expiration_date ASC
            LIMIT $2
            FOR UPDATE SKIP LOCKED
            "#,
        )
        .bind(req.product_id)
        .bind(req.target_qty)
        .fetch_all(&mut *tx)
        .await?;

        for batch in available_batches {
            if remaining_qty <= 0 {
                break;
            }

            let batch_available_qty: i32 = batch.try_get("available_qty")?;
            let allocate_qty = std::cmp::min(remaining_qty, batch_available_qty);

            let batch_id: i32 = batch.try_get("batch_id")?;
            let location_id: i32 = batch.try_get("location_id")?;

            // 4. Record the inventory transaction
            sqlx::query(
                r#"
                INSERT INTO inventory_transactions (task_id, batch_id, transaction_type, from_location_id, to_location_id, quantity_change, executor_id)
                VALUES ($1, $2, $3, $4, $5, $6, $7)
                "#,
            )
            .bind(task_id)
            .bind(batch_id)
            .bind(&req.task_type)
            .bind(location_id)
            .bind(req.to_location_id)
            .bind(allocate_qty)
            .bind(user_id)
            .execute(&mut *tx)
            .await?;

            remaining_qty -= allocate_qty;
        }

        // 5. Verify if we fulfilled the request
        if remaining_qty > 0 {
            return Err(AppError::BadRequest(format!(
                "Not enough available stock to fulfill request. Shortfall: {}",
                remaining_qty
            )));
        }

        // 6. Mark task as DONE
        sqlx::query(
            r#"
            UPDATE warehouse_tasks 
            SET status = 'DONE' 
            WHERE task_id = $1
            "#,
        )
        .bind(task_id)
        .execute(&mut *tx)
        .await?;

        // 7. Commit the transaction
        tx.commit().await?;

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use sqlx::PgPool;
    use std::sync::Arc;
    use tokio::task::JoinSet;

    // Use sqlx::test to automatically create a clean database and run all migrations
    #[sqlx::test(migrations = "../database/migrations")]
    async fn test_1_billion_concurrency(pool: PgPool) -> Result<(), AppError> {
        // 1. Seed Master Data & Test Subject
        // Create employee
        let employee = sqlx::query(
            "INSERT INTO employees (employee_code, full_name) VALUES ('EMP001', 'Test Employee') RETURNING employee_id"
        )
        .fetch_one(&pool)
        .await
        .expect("Failed to seed employee");
        let employee_id: i32 = employee.try_get("employee_id").unwrap();

        // Create user
        let user = sqlx::query(
            "INSERT INTO users (employee_id, username, password_hash, is_active) VALUES ($1, 'test_staff', 'hash', TRUE) RETURNING user_id"
        )
        .bind(employee_id)
        .fetch_one(&pool)
        .await
        .expect("Failed to seed user");
        let user_id: i32 = user.try_get("user_id").unwrap();

        // Create product
        let product = sqlx::query(
            "INSERT INTO products (product_code, trade_name, base_unit, storage_condition) VALUES ('PROD-001', 'Amoxicillin 500mg', 'Box', 'Normal') RETURNING product_id"
        )
        .fetch_one(&pool)
        .await
        .expect("Failed to seed product");
        let product_id: i32 = product.try_get("product_id").unwrap();

        // Create batch
        let batch = sqlx::query(
            "INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date) VALUES ($1, 'BATCH-001', CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year') RETURNING batch_id"
        )
        .bind(product_id)
        .fetch_one(&pool)
        .await
        .expect("Failed to seed batch");
        let batch_id: i32 = batch.try_get("batch_id").unwrap();

        // Seed 100 locations and 100 balances to test SKIP LOCKED concurrency
        for i in 1..=100 {
            let loc_code = format!("LOC-{:03}", i);
            let loc = sqlx::query(
                "INSERT INTO locations (location_code, location_name, zone_type) VALUES ($1, 'Shelf', 'Released') RETURNING location_id"
            )
            .bind(&loc_code)
            .fetch_one(&pool)
            .await
            .expect("Failed to seed location");
            let location_id: i32 = loc.try_get("location_id").unwrap();

            sqlx::query(
                "INSERT INTO inventory_balances (batch_id, product_id, location_id, available_qty, status, expiration_date) VALUES ($1, $2, $3, 1, 'Released', CURRENT_DATE + INTERVAL '1 year')"
            )
            .bind(batch_id)
            .bind(product_id)
            .bind(location_id)
            .execute(&pool)
            .await
            .expect("Failed to seed inventory");
        }

        // 2. The Bomb (Spawn 100 concurrent requests)
        let pool_arc = Arc::new(pool.clone());
        let mut join_set = JoinSet::new();

        for _ in 0..100 {
            let pool_clone = pool_arc.clone();
            join_set.spawn(async move {
                let req = OutboundRequest {
                    product_id,
                    target_qty: 1,
                    to_location_id: None,
                    task_type: "OUTBOUND".to_string(),
                };
                InventoryService::execute_outbound(&pool_clone, user_id, req).await
            });
        }

        // Wait for all 100 threads to finish
        let mut success_count = 0;
        let mut error_count = 0;
        while let Some(res) = join_set.join_next().await {
            match res {
                Ok(Ok(_)) => success_count += 1,
                Ok(Err(e)) => {
                    println!("Request failed with app error: {:?}", e);
                    error_count += 1;
                }
                Err(e) => {
                    println!("Thread panicked: {:?}", e);
                    error_count += 1;
                }
            }
        }

        assert_eq!(success_count, 100, "Not all requests succeeded. Failed: {}", error_count);

        // 3. The Assertions (Chốt chặn sự thật)
        
        // Assertion 1: Balance must be exactly 0
        let final_balance = sqlx::query(
            "SELECT available_qty FROM inventory_balances WHERE batch_id = $1"
        )
        .bind(batch_id)
        .fetch_one(&pool)
        .await
        .expect("Failed to fetch balance");
        
        let available_qty: i32 = final_balance.try_get("available_qty").unwrap();
        assert_eq!(available_qty, 0, "Inventory balance must be exactly 0");

        // Assertion 2: Exactly 100 transaction records
        let tx_count = sqlx::query("SELECT COUNT(*) as count FROM inventory_transactions")
            .fetch_one(&pool)
            .await
            .expect("Failed to count transactions");
            
        let count: i64 = tx_count.try_get("count").unwrap();
        assert_eq!(count, 100, "Must have exactly 100 transaction records");

        // Assertion 3: Exactly 100 audit logs for inventory_balances updates
        let audit_count = sqlx::query(
            "SELECT COUNT(*) as count FROM audit_logs WHERE table_name = 'inventory_balances' AND action = 'UPDATE'"
        )
        .fetch_one(&pool)
        .await
        .expect("Failed to count audit logs");

        let audit_logs_count: i64 = audit_count.try_get("count").unwrap();
        assert_eq!(audit_logs_count, 100, "Must have exactly 100 audit logs for balance updates");

        Ok(())
    }
}
