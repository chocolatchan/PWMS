use axum::{Json, extract::State, Router, routing::post};
use crate::state::SharedState;
use crate::models::dtos::{ReceiveInboundReq, SubmitQcReq};
use crate::services::inbound_qc_service::InboundQcService;
use crate::error::AppError;

pub fn routes() -> Router<SharedState> {
    Router::new()
        .route("/receive", post(receive_inbound))
        .route("/qc", post(submit_qc))
}

pub async fn receive_inbound(
    State(state): State<SharedState>,
    Json(req): Json<ReceiveInboundReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    InboundQcService::process_inbound(&state.db, req).await?;
    Ok(Json(serde_json::json!({ "status": "ok" })))
}

pub async fn submit_qc(
    State(state): State<SharedState>,
    Json(req): Json<SubmitQcReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    InboundQcService::process_qc(&state.db, req).await?;
    Ok(Json(serde_json::json!({ "status": "ok" })))
}
