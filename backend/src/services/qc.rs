use crate::error::AppError;
use sqlx::{PgPool, Postgres, Transaction, Row};
use shared::database::inject_audit_context;
use crate::services::auth::AuthService;
use crate::state::AlertMsg;
use tokio::sync::broadcast;

pub struct QCInspectionPayload {
    pub detail_id: i32,
    pub passed_qty: i32,
    pub failed_qty: i32,
    pub notes: Option<String>,
    pub esign_password: String,
}

pub struct QCService;

impl QCService {
    pub async fn execute_inspection(
        pool: &PgPool,
        ws_sender: &broadcast::Sender<AlertMsg>,
        user_id: i32,
        payload: QCInspectionPayload,
    ) -> Result<(), AppError> {
        // 1. Verify E-Sign (Phase 2.1 Utility)
        AuthService::verify_esign(pool, user_id, &payload.esign_password).await?;

        let mut tx = pool.begin().await?;

        // 2. Inject Audit Context
        inject_audit_context(&mut tx, user_id).await?;

        // 3. Verify the detail exists and get its info
        let detail = sqlx::query(
            r#"
            SELECT d.product_id, d.batch_id, d.declared_qty, d.quarantine_location_id, d.receipt_id, p.trade_name
            FROM inbound_details d
            JOIN products p ON d.product_id = p.product_id
            WHERE d.detail_id = $1
            "#
        )
        .bind(payload.detail_id)
        .fetch_one(&mut *tx)
        .await
        .map_err(|_| AppError::NotFound("Inbound detail not found".to_string()))?;

        let product_id: i32 = detail.get("product_id");
        let batch_id: i32 = detail.get("batch_id");
        let quarantine_loc_id: i32 = detail.get("quarantine_location_id");
        let receipt_id: i32 = detail.get("receipt_id");
        let declared_qty: i32 = detail.get("declared_qty");
        let trade_name: String = detail.get("trade_name");

        if (payload.passed_qty + payload.failed_qty) > declared_qty {
            return Err(AppError::BadRequest("Total inspected quantity exceeds declared quantity".to_string()));
        }

        // 4. Record QC Inspection
        sqlx::query(
            r#"
            INSERT INTO qc_inspections (detail_id, inspected_by, passed_qty, failed_qty, notes, is_signed)
            VALUES ($1, $2, $3, $4, $5, TRUE)
            "#
        )
        .bind(payload.detail_id)
        .bind(user_id)
        .bind(payload.passed_qty)
        .bind(payload.failed_qty)
        .bind(&payload.notes)
        .execute(&mut *tx)
        .await?;

        // 5. Move PASSED items to a 'Released' location
        if payload.passed_qty > 0 {
            let released_loc_id = Self::find_target_location(&mut tx, "Released").await?;
            
            Self::create_inventory_move(
                &mut tx,
                None,
                batch_id,
                "INBOUND_QC_PASS",
                Some(quarantine_loc_id),
                Some(released_loc_id),
                payload.passed_qty,
                user_id
            ).await?;
        }

        // 6. Move FAILED items to a 'Rejected' location
        if payload.failed_qty > 0 {
            let rejected_loc_id = Self::find_target_location(&mut tx, "Rejected").await?;
            
            Self::create_inventory_move(
                &mut tx,
                None,
                batch_id,
                "INBOUND_QC_FAIL",
                Some(quarantine_loc_id),
                Some(rejected_loc_id),
                payload.failed_qty,
                user_id
            ).await?;
        }

        // 7. Update Receipt status
        let remaining = sqlx::query(
            r#"
            SELECT COUNT(*) 
            FROM inbound_details d
            LEFT JOIN qc_inspections q ON d.detail_id = q.detail_id
            WHERE d.receipt_id = $1 AND q.inspection_id IS NULL
            "#
        )
        .bind(receipt_id)
        .fetch_one(&mut *tx)
        .await?;

        let remaining_count: i64 = remaining.get(0);
        let final_status = if remaining_count == 0 { "COMPLETED" } else { "PROCESSING_QC" };
        
        sqlx::query("UPDATE inbound_receipts SET status = $1 WHERE receipt_id = $2")
            .bind(final_status)
            .bind(receipt_id)
            .execute(&mut *tx)
            .await?;

        tx.commit().await?;

        // 8. WebSocket Alert (Phase 2.4 Bridge)
        let alert_msg = AlertMsg {
            event: "QC_COMPLETED".to_string(),
            product_id: Some(product_id),
            message: format!(
                "QC Completed for {}. Result: {} Passed, {} Failed. Status: {}", 
                trade_name, payload.passed_qty, payload.failed_qty, final_status
            ),
        };
        let _ = ws_sender.send(alert_msg);

        Ok(())
    }

    async fn find_target_location(tx: &mut Transaction<'_, Postgres>, zone: &str) -> Result<i32, AppError> {
        let loc = sqlx::query("SELECT location_id FROM locations WHERE zone_type = $1 LIMIT 1")
            .bind(zone)
            .fetch_optional(&mut **tx)
            .await?;

        match loc {
            Some(row) => Ok(row.get("location_id")),
            None => Err(AppError::Internal(format!("No location found for zone type: {}", zone))),
        }
    }

    async fn create_inventory_move(
        tx: &mut Transaction<'_, Postgres>,
        task_id: Option<i32>,
        batch_id: i32,
        tx_type: &str,
        from_loc: Option<i32>,
        to_loc: Option<i32>,
        qty: i32,
        user_id: i32,
    ) -> Result<(), AppError> {
        sqlx::query(
            r#"
            INSERT INTO inventory_transactions 
            (task_id, batch_id, transaction_type, from_location_id, to_location_id, quantity_change, executor_id)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            "#
        )
        .bind(task_id)
        .bind(batch_id)
        .bind(tx_type)
        .bind(from_loc)
        .bind(to_loc)
        .bind(qty)
        .bind(user_id)
        .execute(&mut **tx)
        .await?;

        Ok(())
    }
}
