use uuid::Uuid;
use sqlx::PgPool;
use crate::error::AppError;
use serde::Serialize;

#[derive(Debug, Serialize)]
pub struct RunnerTask {
    pub id: Uuid,
    pub task_type: String, // "INTERNAL" or "EXTERNAL"
    pub identifier: String, // container_id or batch_number
    pub from_location: String,
    pub to_location: String,
    pub description: String,
}

pub struct RunnerService;

impl RunnerService {
    pub async fn get_pending_tasks(pool: &PgPool) -> Result<Vec<RunnerTask>, AppError> {
        let mut tasks = Vec::new();

        // 1. Internal Runner Tasks (Containers at Inventory Gate)
        let internal_rows = sqlx::query!(
            r#"
            SELECT c.id, o.customer_name
            FROM containers c
            JOIN orders o ON o.id = c.order_id
            WHERE c.current_status = 'AT_INV_GATE'::container_status
            "#
        )
        .fetch_all(pool)
        .await?;

        for row in internal_rows {
            tasks.push(RunnerTask {
                id: row.id,
                task_type: "INTERNAL".to_string(),
                identifier: format!("CONT-{}", &row.id.to_string()[..8]),
                from_location: "INV_EXPORT_GATE".to_string(),
                to_location: "PACKING_AREA".to_string(),
                description: format!("Order for {}", row.customer_name),
            });
        }

        // 2. External Runner Tasks (QC Done batches still in Quarantine)
        let external_rows = sqlx::query!(
            r#"
            SELECT ib.id, ib.batch_number, ib.current_status::text as batch_status, l.zone_code
            FROM inbound_batches ib
            JOIN inventory_balances inv ON inv.inbound_batch_id = ib.id
            JOIN locations l ON l.id = inv.location_id
            WHERE (ib.current_status = 'QC_DONE'::batch_status OR ib.current_status = 'QC_REJECTED'::batch_status)
            AND l.zone_type = 'QUARANTINE'
            "#
        )
        .fetch_all(pool)
        .await?;

        for row in external_rows {
            let is_done = row.batch_status.as_deref() == Some("QC_DONE");
            let to_zone = if is_done { "ACCEPTED_INV" } else { "REJECTED_INV" };
            tasks.push(RunnerTask {
                id: row.id,
                task_type: "EXTERNAL".to_string(),
                identifier: row.batch_number.unwrap_or_default(),
                from_location: row.zone_code,
                to_location: to_zone.to_string(),
                description: format!("Move {} to {}", if is_done { "Accepted" } else { "Rejected" }, to_zone),
            });
        }

        Ok(tasks)
    }

    /// Internal Runner: Move container from Inventory Gate to Packing Area
    pub async fn move_container_to_packing(pool: &PgPool, container_id: Uuid) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        let res = sqlx::query!(
            r#"
            UPDATE containers
            SET current_status = 'AT_PACKING'::container_status
            WHERE id = $1 AND current_status = 'AT_INV_GATE'::container_status
            "#,
            container_id
        )
        .execute(&mut *tx)
        .await?;

        if res.rows_affected() == 0 {
            return Err(AppError::DomainError("Container not at inventory gate or already moved".to_string()));
        }

        tx.commit().await?;
        Ok(())
    }

    /// External Runner: Move batch from Quarantine to Inventory
    pub async fn move_batch_from_quarantine(pool: &PgPool, batch_id: Uuid) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        // 1. Get batch status to decide destination
        let batch = sqlx::query!(
            "SELECT current_status::text as status FROM inbound_batches WHERE id = $1",
            batch_id
        )
        .fetch_one(&mut *tx)
        .await?;

        let is_done = batch.status.as_deref() == Some("QC_DONE");
        let target_zone = if is_done { "ACCEPTED_INV" } else { "REJECTED_INV" };

        // 2. Update inventory location
        sqlx::query!(
            r#"
            UPDATE inventory_balances
            SET location_id = (SELECT id FROM locations WHERE zone_type::text = $1 LIMIT 1)
            WHERE inbound_batch_id = $2
            "#,
            target_zone,
            batch_id
        )
        .execute(&mut *tx)
        .await?;

        tx.commit().await?;
        Ok(())
    }
}
