use axum::{extract::State, Json};
use serde::Deserialize;
use crate::{
    error::AppError,
    services::qc::{QCService, QCInspectionPayload},
    state::SharedState,
    http::middleware::auth::UserContext,
};

use validator::Validate;

#[axum::debug_handler]
pub async fn list_pending_inspections(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            d.detail_id,
            ir.receipt_number,
            p.trade_name,
            pb.batch_number,
            d.declared_qty,
            l.location_code
        FROM inbound_details d
        JOIN inbound_receipts ir ON d.receipt_id = ir.receipt_id
        JOIN products p ON d.product_id = p.product_id
        JOIN product_batches pb ON d.batch_id = pb.batch_id
        JOIN locations l ON d.quarantine_location_id = l.location_id
        LEFT JOIN qc_inspections q ON d.detail_id = q.detail_id
        WHERE q.inspection_id IS NULL AND ir.status IN ('PENDING_QC', 'PROCESSING_QC')
        ORDER BY ir.created_at DESC
        "#
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        serde_json::json!({
            "detail_id": r.detail_id,
            "receipt": r.receipt_number,
            "product": r.trade_name,
            "batch": r.batch_number,
            "qty": r.declared_qty,
            "location": r.location_code
        })
    }).collect();

    Ok(Json(result))
}

#[derive(Deserialize, Validate)]
pub struct CreateQCInspectionPayload {
    pub detail_id: i32,
    #[validate(range(min = 0))]
    pub passed_qty: i32,
    #[validate(range(min = 0))]
    pub failed_qty: i32,
    pub notes: Option<String>,
    #[validate(length(min = 1, message = "E-Signature password is required"))]
    pub esign_password: String,
}

#[axum::debug_handler]
pub async fn submit_qc_inspection(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<CreateQCInspectionPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    payload.validate().map_err(|e| AppError::BadRequest(e.to_string()))?;
    
    // In a real app, verify `user_ctx.presets` contains QA/QC presets.
    // Ensure the QA who inspects is NOT the one who created the receipt (SoD).
    // The DB trigger `check_sod_qc_inspection` handles this SoD implicitly!

    let req = QCInspectionPayload {
        detail_id: payload.detail_id,
        passed_qty: payload.passed_qty,
        failed_qty: payload.failed_qty,
        notes: payload.notes,
        esign_password: payload.esign_password,
    };

    QCService::execute_inspection(&state.db, &state.ws_sender, user_ctx.user_id, req).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "message": "QC Inspection completed with E-Signature, stock released, and WebSocket event fired"
    })))
}
