use sqlx::{Postgres, Transaction};
use uuid::Uuid;
use crate::models::entities::TaskStatus;

pub struct PickTaskInfo {
    pub id: Uuid,
    pub container_id: Uuid,
    pub product_id: Option<Uuid>,
    pub inventory_balance_id: Option<Uuid>, // Added
    pub required_qty: i32,
    pub picked_qty: i32,
    pub is_lasa: bool,
    pub status: TaskStatus, // Added for validation
}

pub struct OutboundRepo;

impl OutboundRepo {
    pub async fn get_pick_task_and_product(
        tx: &mut Transaction<'_, Postgres>,
        task_id: Uuid,
    ) -> Result<PickTaskInfo, sqlx::Error> {
        let record = sqlx::query!(
            r#"
            SELECT 
                pt.id, 
                pt.container_id, 
                pt.product_id, 
                pt.inventory_balance_id,
                pt.required_qty, 
                pt.picked_qty, 
                pt.status as "status: TaskStatus",
                COALESCE(p.is_lasa, false) as is_lasa
            FROM pick_tasks pt
            LEFT JOIN products p ON pt.product_id = p.id
            WHERE pt.id = $1
            "#,
            task_id
        )
        .fetch_one(&mut **tx)
        .await?;

        Ok(PickTaskInfo {
            id: record.id,
            container_id: record.container_id,
            product_id: record.product_id,
            inventory_balance_id: record.inventory_balance_id,
            required_qty: record.required_qty,
            picked_qty: record.picked_qty.unwrap_or(0),
            is_lasa: record.is_lasa.unwrap_or(false),
            status: record.status.unwrap_or(TaskStatus::Pending),
        })
    }

    pub async fn increment_picked_qty(
        tx: &mut Transaction<'_, Postgres>,
        task_id: Uuid,
        qty: i32,
        picker_id: Uuid,
    ) -> Result<(), sqlx::Error> {
        sqlx::query!(
            r#"
            UPDATE pick_tasks
            SET picked_qty = COALESCE(picked_qty, 0) + $1,
                picker_id = $3,
                status = CASE WHEN status = 'PENDING'::task_status THEN 'IN_PROGRESS'::task_status ELSE status END
            WHERE id = $2
            "#,
            qty,
            task_id,
            picker_id
        )
        .execute(&mut **tx)
        .await?;

        Ok(())
    }

    pub async fn deduct_inventory_on_pick(
        tx: &mut Transaction<'_, Postgres>,
        inventory_balance_id: Uuid,
        qty: i32,
    ) -> Result<(), sqlx::Error> {
        let res = sqlx::query!(
            r#"
            UPDATE inventory_balances
            SET quantity = quantity - $1
            WHERE id = $2 AND quantity >= $1
            "#,
            qty,
            inventory_balance_id
        )
        .execute(&mut **tx)
        .await?;

        if res.rows_affected() == 0 {
            return Err(sqlx::Error::RowNotFound); // Or a more specific error for insufficient quantity
        }

        Ok(())
    }

    pub async fn complete_pick_task_and_check_container(
        tx: &mut Transaction<'_, Postgres>,
        task_id: Uuid,
        container_id: Uuid,
    ) -> Result<bool, sqlx::Error> {
        // Update task to COMPLETED
        sqlx::query!(
            r#"
            UPDATE pick_tasks
            SET status = 'COMPLETED'::task_status
            WHERE id = $1
            "#,
            task_id
        )
        .execute(&mut **tx)
        .await?;

        // Check if all tasks for the container are COMPLETED
        let pending_tasks = sqlx::query!(
            r#"
            SELECT COUNT(*) as count
            FROM pick_tasks
            WHERE container_id = $1 AND status != 'COMPLETED'::task_status
            "#,
            container_id
        )
        .fetch_one(&mut **tx)
        .await?;

        let pending_count = pending_tasks.count.unwrap_or(0);

        if pending_count == 0 {
            // Update container status to AT_INV_GATE
            sqlx::query!(
                r#"
                UPDATE containers
                SET current_status = 'AT_INV_GATE'::container_status
                WHERE id = $1
                "#,
                container_id
            )
            .execute(&mut **tx)
            .await?;
            
            return Ok(true); // Container is now ready for packing
        }

        Ok(false)
    }

    pub async fn complete_packing(
        tx: &mut Transaction<'_, Postgres>,
        container_id: Uuid,
        packer_id: Uuid,
    ) -> Result<bool, sqlx::Error> {
        let res = sqlx::query!(
            r#"
            UPDATE containers
            SET current_status = 'PACKED'::container_status
            WHERE id = $1 AND current_status = 'AT_PACKING'::container_status
            "#,
            container_id
        )
        .execute(&mut **tx)
        .await?;

        if res.rows_affected() == 0 {
            return Ok(false);
        }

        sqlx::query!(
            r#"
            UPDATE pack_tasks
            SET status = 'COMPLETED'::task_status, packer_id = $1, packed_at = CURRENT_TIMESTAMP
            WHERE container_id = $2
            "#,
            packer_id,
            container_id
        )
        .execute(&mut **tx)
        .await?;

        Ok(true)
    }

    pub async fn dispatch_container(
        tx: &mut Transaction<'_, Postgres>,
        container_id: Uuid,
        vehicle_seal_number: &str,
        dispatch_temperature: Option<f64>,
    ) -> Result<Uuid, sqlx::Error> {
        // Tạo outbound_shipment (nếu chưa có) - giả sử mỗi container có một shipment riêng
        let shipment_id = sqlx::query!(
            r#"
            INSERT INTO outbound_shipments (order_id, vehicle_seal_number, dispatch_temperature, dispatched_at)
            SELECT order_id, $1, $2, CURRENT_TIMESTAMP
            FROM containers
            WHERE id = $3
            RETURNING id
            "#,
            vehicle_seal_number,
            dispatch_temperature.map(|t| bigdecimal::BigDecimal::try_from(t).unwrap_or_default()),
            container_id
        )
        .fetch_one(&mut **tx)
        .await?
        .id;

        // Cập nhật container: outbound_shipment_id, status -> 'DISPATCHED'
        sqlx::query!(
            r#"
            UPDATE containers
            SET outbound_shipment_id = $1,
                current_status = 'DISPATCHED'::container_status
            WHERE id = $2
            "#,
            shipment_id,
            container_id
        )
        .execute(&mut **tx)
        .await?;

        Ok(shipment_id)
    }
}

