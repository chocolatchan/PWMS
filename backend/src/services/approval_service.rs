use crate::error::AppError;
use crate::services::auth::AuthService;
use crate::state::AlertMsg;
use sqlx::{PgPool, Row};
use shared::database::inject_audit_context;
use tokio::sync::broadcast;

pub struct ApprovalService;

impl ApprovalService {
    /// Submit an approval at a given level.
    /// Level 1 = QA, Level 2 = CHIEF_PHARMACIST, Level 3 = WAREHOUSE_DIRECTOR/CHIEF_PHARMACIST
    pub async fn submit_approval(
        pool: &PgPool,
        ws_sender: &broadcast::Sender<AlertMsg>,
        user_id: i32,
        approval_id: i32,
        level: i32,
        decision: &str, // APPROVE, REJECT, HOLD
        esign_password: &str,
        on_behalf_of: Option<i32>,
    ) -> Result<String, AppError> {
        // 1. Verify E-Sign
        AuthService::verify_esign(pool, user_id, esign_password).await?;

        let mut tx = pool.begin().await?;
        inject_audit_context(&mut tx, user_id).await?;

        // 2. Load the approval record
        let approval = sqlx::query(
            "SELECT * FROM approval_chain WHERE approval_id = $1 AND final_status = 'PENDING' FOR UPDATE"
        )
        .bind(approval_id)
        .fetch_one(&mut *tx)
        .await
        .map_err(|_| AppError::NotFound("Approval not found or already finalized".to_string()))?;

        let action_type: String = approval.get("action_type");
        let entity_type: String = approval.get("entity_type");
        let entity_id: i32 = approval.get("entity_id");

        // 3. Validate level ordering (cannot skip levels)
        match level {
            1 => {
                let existing: Option<i32> = approval.try_get("level1_user_id")?;
                if existing.is_some() {
                    return Err(AppError::BadRequest("Level 1 already signed".to_string()));
                }
                sqlx::query(
                    "UPDATE approval_chain SET level1_user_id = $1, level1_signed_at = CURRENT_TIMESTAMP, level1_decision = $2 WHERE approval_id = $3"
                )
                .bind(user_id).bind(decision).bind(approval_id)
                .execute(&mut *tx).await?;
            },
            2 => {
                let l1: Option<i32> = approval.try_get("level1_user_id")?;
                if l1.is_none() {
                    return Err(AppError::BadRequest("Level 1 must be signed first".to_string()));
                }
                let existing: Option<i32> = approval.try_get("level2_user_id")?;
                if existing.is_some() {
                    return Err(AppError::BadRequest("Level 2 already signed".to_string()));
                }
                sqlx::query(
                    "UPDATE approval_chain SET level2_user_id = $1, level2_signed_at = CURRENT_TIMESTAMP, level2_decision = $2, level2_on_behalf_of = $3 WHERE approval_id = $4"
                )
                .bind(user_id).bind(decision).bind(on_behalf_of).bind(approval_id)
                .execute(&mut *tx).await?;
            },
            3 => {
                let l2: Option<i32> = approval.try_get("level2_user_id")?;
                if l2.is_none() {
                    return Err(AppError::BadRequest("Level 2 must be signed first".to_string()));
                }
                let existing: Option<i32> = approval.try_get("level3_user_id")?;
                if existing.is_some() {
                    return Err(AppError::BadRequest("Level 3 already signed".to_string()));
                }
                sqlx::query(
                    "UPDATE approval_chain SET level3_user_id = $1, level3_signed_at = CURRENT_TIMESTAMP, level3_decision = $2, level3_on_behalf_of = $3 WHERE approval_id = $4"
                )
                .bind(user_id).bind(decision).bind(on_behalf_of).bind(approval_id)
                .execute(&mut *tx).await?;
            },
            _ => return Err(AppError::BadRequest("Invalid approval level".to_string())),
        }

        // 4. If any level is REJECT → finalize as REJECTED immediately
        if decision == "REJECT" {
            sqlx::query("UPDATE approval_chain SET final_status = 'REJECTED' WHERE approval_id = $1")
                .bind(approval_id).execute(&mut *tx).await?;

            // Execute rejection action
            Self::execute_action(&mut tx, &action_type, &entity_type, entity_id, "REJECTED", user_id).await?;

            tx.commit().await?;
            let _ = ws_sender.send(AlertMsg {
                event: format!("{}_REJECTED", action_type),
                product_id: None,
                message: format!("Approval #{} REJECTED at Level {} by user {}", approval_id, level, user_id),
            });
            return Ok("REJECTED".to_string());
        }

        // 5. If level 3 approves → finalize as APPROVED and execute action
        if level == 3 && decision == "APPROVE" {
            sqlx::query("UPDATE approval_chain SET final_status = 'APPROVED' WHERE approval_id = $1")
                .bind(approval_id).execute(&mut *tx).await?;

            Self::execute_action(&mut tx, &action_type, &entity_type, entity_id, "APPROVED", user_id).await?;

            // Push event to integration_outbox (ERP stub)
            let outbox_payload = serde_json::json!({
                "approval_id": approval_id,
                "action_type": action_type,
                "entity_type": entity_type,
                "entity_id": entity_id,
                "final_status": "APPROVED"
            });
            sqlx::query(
                "INSERT INTO integration_outbox (event_type, payload) VALUES ($1, $2)"
            )
            .bind(format!("{}_APPROVED", action_type))
            .bind(outbox_payload)
            .execute(&mut *tx).await?;

            tx.commit().await?;
            let _ = ws_sender.send(AlertMsg {
                event: format!("{}_APPROVED", action_type),
                product_id: None,
                message: format!("Approval #{} FULLY APPROVED. 3/3 signatures collected.", approval_id),
            });
            return Ok("APPROVED".to_string());
        }

        tx.commit().await?;

        // Notify next level
        let next_level = level + 1;
        let _ = ws_sender.send(AlertMsg {
            event: "APPROVAL_PENDING".to_string(),
            product_id: None,
            message: format!("Approval #{} requires Level {} signature for {}.", approval_id, next_level, action_type),
        });

        Ok(format!("SIGNED_LEVEL_{}", level))
    }

    /// Execute the final action after full approval
    async fn execute_action(
        tx: &mut sqlx::Transaction<'_, sqlx::Postgres>,
        action_type: &str,
        entity_type: &str,
        entity_id: i32,
        result: &str,
        _user_id: i32,
    ) -> Result<(), AppError> {
        match (action_type, result) {
            ("QC_RELEASE", "APPROVED") => {
                // Move items from quarantine to Released
                let detail = sqlx::query(
                    "SELECT batch_id, declared_qty, quarantine_location_id FROM inbound_details WHERE detail_id = $1"
                ).bind(entity_id).fetch_one(&mut **tx).await?;

                let batch_id: i32 = detail.get("batch_id");
                let quarantine_loc: i32 = detail.get("quarantine_location_id");

                // Find a Released location
                let released_loc = sqlx::query_scalar!(
                    "SELECT location_id FROM locations WHERE zone_type = 'Released' LIMIT 1"
                ).fetch_one(&mut **tx).await
                    .map_err(|_| AppError::Internal("No Released location configured".to_string()))?;

                // Update inventory status
                sqlx::query(
                    "UPDATE inventory_balances SET status = 'Released' WHERE batch_id = $1 AND location_id = $2"
                ).bind(batch_id).bind(quarantine_loc).execute(&mut **tx).await?;
            },
            ("QC_REJECT", "APPROVED") | ("QC_RELEASE", "REJECTED") => {
                let detail = sqlx::query(
                    "SELECT batch_id, quarantine_location_id FROM inbound_details WHERE detail_id = $1"
                ).bind(entity_id).fetch_one(&mut **tx).await?;
                let batch_id: i32 = detail.get("batch_id");
                let quarantine_loc: i32 = detail.get("quarantine_location_id");

                sqlx::query(
                    "UPDATE inventory_balances SET status = 'REJECTED' WHERE batch_id = $1 AND location_id = $2"
                ).bind(batch_id).bind(quarantine_loc).execute(&mut **tx).await?;
            },
            ("RECALL", "APPROVED") => {
                sqlx::query(
                    "UPDATE recall_actions SET status = 'APPROVED', completed_at = CURRENT_TIMESTAMP WHERE recall_id = $1"
                ).bind(entity_id).execute(&mut **tx).await?;
            },
            _ => {}
        }
        Ok(())
    }

    /// Create a new approval chain (called by QC service, recall service, etc.)
    pub async fn create_approval(
        pool: &PgPool,
        action_type: &str,
        entity_type: &str,
        entity_id: i32,
    ) -> Result<i32, AppError> {
        let approval_id = sqlx::query_scalar!(
            r#"
            INSERT INTO approval_chain (action_type, entity_type, entity_id, final_status)
            VALUES ($1, $2, $3, 'PENDING')
            RETURNING approval_id
            "#,
            action_type, entity_type, entity_id
        ).fetch_one(pool).await?;

        Ok(approval_id)
    }
}
