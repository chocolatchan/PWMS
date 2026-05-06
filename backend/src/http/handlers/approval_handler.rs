use axum::{extract::State, Json};
use serde::Deserialize;
use crate::{
    error::AppError,
    services::approval_service::ApprovalService,
    services::recall_service::RecallService,
    state::SharedState,
    http::middleware::auth::UserContext,
};

// ============ APPROVAL ENDPOINTS ============

#[derive(Deserialize)]
pub struct SubmitApprovalPayload {
    pub approval_id: i32,
    pub level: i32,
    pub decision: String,      // APPROVE, REJECT, HOLD
    pub esign_password: String,
    pub on_behalf_of: Option<i32>,
}

#[axum::debug_handler]
pub async fn submit_approval(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<SubmitApprovalPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    let result = ApprovalService::submit_approval(
        &state.db,
        &state.ws_sender,
        user_ctx.user_id,
        payload.approval_id,
        payload.level,
        &payload.decision,
        &payload.esign_password,
        payload.on_behalf_of,
    ).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "result": result
    })))
}

#[axum::debug_handler]
pub async fn list_pending_approvals(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT approval_id, action_type, entity_type, entity_id,
               level1_user_id, level1_decision,
               level2_user_id, level2_decision,
               level3_user_id, level3_decision,
               final_status, created_at
        FROM approval_chain
        WHERE final_status = 'PENDING'
        ORDER BY created_at ASC
        "#
    )
    .fetch_all(&state.db)
    .await?;

    let result: Vec<serde_json::Value> = rows.into_iter().map(|r| {
        let next_level = if r.level1_user_id.is_none() { 1 }
            else if r.level2_user_id.is_none() { 2 }
            else if r.level3_user_id.is_none() { 3 }
            else { 0 };

        serde_json::json!({
            "approval_id": r.approval_id,
            "action_type": r.action_type,
            "entity_type": r.entity_type,
            "entity_id": r.entity_id,
            "next_level": next_level,
            "level1_signed": r.level1_user_id.is_some(),
            "level2_signed": r.level2_user_id.is_some(),
            "level3_signed": r.level3_user_id.is_some(),
            "final_status": r.final_status,
            "created_at": r.created_at.map(|dt| dt.to_string())
        })
    }).collect();

    Ok(Json(result))
}

// ============ RECALL ENDPOINTS ============

#[derive(Deserialize)]
pub struct EmergencyRecallPayload {
    pub batch_id: i32,
    pub reason: String,
}

#[axum::debug_handler]
pub async fn emergency_recall(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<EmergencyRecallPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    let recall_id = RecallService::execute_emergency_recall(
        &state.db,
        &state.ws_sender,
        user_ctx.user_id,
        payload.batch_id,
        &payload.reason,
    ).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "recall_id": recall_id,
        "message": "Emergency recall initiated — locations locked, tasks paused, items quarantined."
    })))
}
