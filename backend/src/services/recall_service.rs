use crate::error::AppError;
use crate::state::AlertMsg;
use crate::services::approval_service::ApprovalService;
use sqlx::{PgPool, Row};
use shared::database::inject_audit_context;
use tokio::sync::broadcast;

pub struct RecallService;

impl RecallService {
    /// SOP V4.0 Phase 6.1 — Emergency Recall Circuit Breaker (< 30 seconds)
    /// Steps:
    /// 1. Lock all locations containing the batch
    /// 2. Pause all picking tasks with items from this batch
    /// 3. Change all inventory_balances to RECALLED
    /// 4. WebSocket alert to all PDAs
    /// 5. Create recall_actions record + approval chain
    pub async fn execute_emergency_recall(
        pool: &PgPool,
        ws_sender: &broadcast::Sender<AlertMsg>,
        user_id: i32,
        batch_id: i32,
        reason: &str,
    ) -> Result<i32, AppError> {
        let mut tx = pool.begin().await?;
        inject_audit_context(&mut tx, user_id).await?;

        // 1. Find all locations containing this batch
        let affected_locations: Vec<i32> = sqlx::query_scalar(
            "SELECT DISTINCT location_id FROM inventory_balances WHERE batch_id = $1 AND available_qty > 0"
        )
        .bind(batch_id)
        .fetch_all(&mut *tx)
        .await?;

        // 2. Lock those locations
        for loc_id in &affected_locations {
            sqlx::query(
                "UPDATE locations SET lock_state = 'LOCKED_RECALL' WHERE location_id = $1"
            )
            .bind(loc_id)
            .execute(&mut *tx)
            .await?;
        }

        // 3. Find and pause all picking tasks that involve this batch
        let affected_tasks: Vec<i32> = sqlx::query_scalar(
            r#"
            SELECT DISTINCT pt.task_id 
            FROM picking_tasks pt
            JOIN sales_order_lines sol ON pt.order_id = sol.order_id
            JOIN inventory_balances ib ON sol.product_id = ib.product_id
            WHERE ib.batch_id = $1 AND pt.status IN ('PENDING', 'IN_PROGRESS')
            "#
        )
        .bind(batch_id)
        .fetch_all(&mut *tx)
        .await?;

        for task_id in &affected_tasks {
            sqlx::query(
                "UPDATE picking_tasks SET status = 'PAUSED' WHERE task_id = $1"
            )
            .bind(task_id)
            .execute(&mut *tx)
            .await?;
        }

        // 4. Change all inventory_balances for this batch to RECALLED
        let affected_row = sqlx::query(
            "UPDATE inventory_balances SET status = 'RECALLED' WHERE batch_id = $1 RETURNING available_qty"
        )
        .bind(batch_id)
        .fetch_all(&mut *tx)
        .await?;

        let total_affected_qty: i32 = affected_row.iter()
            .map(|r| r.get::<i32, _>("available_qty"))
            .sum();

        // 5. Create recall_actions record
        let recall_id = sqlx::query_scalar!(
            r#"
            INSERT INTO recall_actions (batch_id, reason, severity, affected_location_ids, affected_task_ids, affected_qty, status, initiated_by)
            VALUES ($1, $2, 'CRITICAL', $3, $4, $5, 'LOCKED', $6)
            RETURNING recall_id
            "#,
            batch_id,
            reason,
            &affected_locations,
            &affected_tasks,
            total_affected_qty,
            user_id
        )
        .fetch_one(&mut *tx)
        .await?;

        // 6. Create 3-level approval chain for this recall
        let approval_id = sqlx::query_scalar!(
            r#"
            INSERT INTO approval_chain (action_type, entity_type, entity_id, level1_user_id, level1_signed_at, level1_decision, final_status)
            VALUES ('RECALL', 'recall_actions', $1, $2, CURRENT_TIMESTAMP, 'APPROVE', 'PENDING')
            RETURNING approval_id
            "#,
            recall_id,
            user_id
        )
        .fetch_one(&mut *tx)
        .await?;

        // Link approval to recall
        sqlx::query("UPDATE recall_actions SET approval_id = $1 WHERE recall_id = $2")
            .bind(approval_id)
            .bind(recall_id)
            .execute(&mut *tx)
            .await?;

        // 7. Log to integration_outbox
        let outbox_payload = serde_json::json!({
            "recall_id": recall_id,
            "batch_id": batch_id,
            "reason": reason,
            "affected_locations": affected_locations,
            "affected_tasks": affected_tasks,
            "affected_qty": total_affected_qty
        });
        sqlx::query(
            "INSERT INTO integration_outbox (event_type, payload) VALUES ('RECALL_INITIATED', $1)"
        )
        .bind(outbox_payload)
        .execute(&mut *tx)
        .await?;

        tx.commit().await?;

        // 8. WebSocket broadcast — Alert ALL connected PDAs
        let _ = ws_sender.send(AlertMsg {
            event: "EMERGENCY_RECALL".to_string(),
            product_id: None,
            message: format!(
                "🚨 THU HỒI KHẨN CẤP: Lô #{} — {} location(s) đã bị phong tỏa, {} task(s) bị tạm dừng, {} đơn vị bị ảnh hưởng. Lý do: {}",
                batch_id, affected_locations.len(), affected_tasks.len(), total_affected_qty, reason
            ),
        });

        Ok(recall_id)
    }
}
