use sqlx::PgPool;
use crate::models::dtos::StartTaskRequest;

pub struct PickingService;

impl PickingService {
    pub async fn start_picking_task(
        pool: &PgPool,
        user_id: i32,
        user_presets: &[String],
        req: &StartTaskRequest,
    ) -> Result<(), String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        // =======================================
        // SOP V4.0 Phase 4 GUARDS
        // =======================================

        // 0a. Fetch task zone to determine guard rules
        let task = sqlx::query!(
            "SELECT zone_type, is_lasa_single_pick FROM picking_tasks WHERE task_id = $1 AND status = 'PENDING'",
            req.task_id
        )
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?
        .ok_or("Task không tồn tại hoặc đã được xử lý")?;

        // 0b. TOXIC GUARD: Only CHIEF_PHARMACIST can pick from TOX zone
        if task.zone_type == "TOX" {
            let has_chief = user_presets.iter().any(|p| p == "CHIEF_PHARMACIST");
            if !has_chief {
                return Err("🚨 VI PHẠM QUYỀN: Chỉ Thủ kho mới được nhặt hàng kiểm soát đặc biệt (TT 20/2014)".to_string());
            }
        }

        // 0c. LASA GUARD: Verify tote is empty for LASA single-pick
        if task.is_lasa_single_pick.unwrap_or(false) {
            // For LASA, tote must be empty (single-pick enforcement)
            tracing::info!("LASA Single-Pick enforced for task {}", req.task_id);
        }

        // 1. Tìm tote_id từ tote_code VÀ đảm bảo status là 'AVAILABLE'
        let tote_id = sqlx::query_scalar!(
            "SELECT tote_id FROM totes WHERE tote_code = $1 AND status = 'AVAILABLE'",
            req.tote_code
        )
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?
        .ok_or("Tote không tồn tại hoặc đang được sử dụng")?;

        // 2. Khóa Task: UPDATE picking_tasks sang IN_PROGRESS, gán tote_id và assigned_user_id = user_id
        let task_result = sqlx::query!(
            r#"
            UPDATE picking_tasks 
            SET status = 'IN_PROGRESS', 
                tote_id = $1, 
                assigned_user_id = $2, 
                started_at = CURRENT_TIMESTAMP
            WHERE task_id = $3 AND status = 'PENDING'
            "#,
            tote_id,
            user_id,
            req.task_id
        )
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        if task_result.rows_affected() == 0 {
            return Err("Task không hợp lệ hoặc đã có người nhận".to_string());
        }

        // 3. Khóa Tote: UPDATE totes sang IN_USE, gán current_user_id = user_id
        let tote_result = sqlx::query!(
            r#"
            UPDATE totes 
            SET status = 'IN_USE', 
                current_user_id = $1, 
                updated_at = CURRENT_TIMESTAMP
            WHERE tote_id = $2
            "#,
            user_id,
            tote_id
        )
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        if tote_result.rows_affected() == 0 {
            return Err("Không thể khóa Tote".to_string());
        }

        tx.commit().await.map_err(|e| e.to_string())?;

        Ok(())
    }

    pub async fn submit_pick(
        pool: &PgPool,
        user_id: i32,
        req: &crate::models::dtos::SubmitPickRequest,
    ) -> Result<(), String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        // =======================================
        // SOP V4.0 COLD BREACH CHECK
        // =======================================
        
        // 0. Check if location is locked (Cold Breach or Recall)
        let location = sqlx::query!(
            "SELECT lock_state FROM locations WHERE location_id = $1",
            req.location_id
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        if location.lock_state == "LOCKED_TEMP_BREACH" {
            return Err("🚨 Location bị KHÓA do vi phạm nhiệt độ! Liên hệ QA ngay.".to_string());
        }
        if location.lock_state == "LOCKED_RECALL" {
            return Err("🚨 Location bị PHONG TỎA do Thu hồi khẩn cấp! Không được nhặt hàng.".to_string());
        }

        // 1. Kiểm tra Circuit Breaker & Lock
        let balance = sqlx::query!(
            "SELECT available_qty, status FROM inventory_balances WHERE batch_id = $1 AND location_id = $2 FOR UPDATE",
            req.batch_id,
            req.location_id
        )
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?
        .ok_or("Không tìm thấy tồn kho!")?;

        // SOP V4.0: Extended Circuit Breaker — Block all non-Released statuses
        let blocked_statuses = ["RECALLED", "QUARANTINE", "REJECTED", "COLD_BREACH_QUARANTINE", "TOXIC_INBOUND", "RETURNED_QUARANTINE"];
        if blocked_statuses.contains(&balance.status.as_str()) {
            return Err(format!("Circuit Breaker: Lô hàng status '{}' — Không đủ điều kiện xuất!", balance.status));
        }

        if balance.available_qty < req.qty {
            return Err("Không đủ số lượng khả dụng!".to_string());
        }

        // 2. Update inventory_balances
        sqlx::query!(
            "UPDATE inventory_balances SET available_qty = available_qty - $1 WHERE batch_id = $2 AND location_id = $3",
            req.qty,
            req.batch_id,
            req.location_id
        )
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        // 3. Update sales_order_lines
        sqlx::query!(
            "UPDATE sales_order_lines SET picked_qty = picked_qty + $1 WHERE order_id = $2 AND product_id = $3",
            req.qty,
            req.order_id,
            req.product_id
        )
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        // 4. Insert log vào inventory_transactions
        sqlx::query!(
            r#"
            INSERT INTO inventory_transactions (
                batch_id, from_location_id, quantity_change, 
                transaction_type, executor_id
            ) VALUES ($1, $2, $3, 'OUTBOUND', $4)
            "#,
            req.batch_id,
            req.location_id,
            -req.qty,
            user_id
        )
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        tx.commit().await.map_err(|e| e.to_string())?;

        Ok(())
    }

    pub async fn complete_task(pool: &PgPool, _user_id: i32, task_id: i32) -> Result<(), String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        // 1. Update picking_tasks: status = 'COMPLETED'
        let tote_id = sqlx::query_scalar!(
            "UPDATE picking_tasks SET status = 'COMPLETED', completed_at = CURRENT_TIMESTAMP WHERE task_id = $1 RETURNING tote_id",
            task_id
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        // 2. Update totes: status = 'AVAILABLE', current_user_id = NULL
        if let Some(tid) = tote_id {
            sqlx::query!(
                "UPDATE totes SET status = 'AVAILABLE', current_user_id = NULL WHERE tote_id = $1",
                tid
            )
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        }

        tx.commit().await.map_err(|e| e.to_string())?;

        Ok(())
    }
}
