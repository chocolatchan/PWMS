use axum::{extract::State, Json};
use crate::http::AppState;
use crate::models::dtos::{PackBoxRequest, CreateManifestRequest};
use crate::services::dispatch_service::DispatchService;
use std::sync::Arc;

pub async fn pack_box_handler(
    State(state): State<Arc<AppState>>,
    Json(req): Json<PackBoxRequest>,
) -> Result<Json<i32>, String> {
    // Giả định user_id = 1 (Trong thực tế lấy từ Auth Middleware)
    let user_id = 1;
    let box_id = DispatchService::pack_box(&state.db, user_id, &req).await?;
    Ok(Json(box_id))
}

pub async fn create_manifest_handler(
    State(state): State<Arc<AppState>>,
    Json(req): Json<CreateManifestRequest>,
) -> Result<Json<i32>, String> {
    let user_id = 1;
    let manifest_id = DispatchService::create_manifest(&state.db, user_id, &req).await?;
    Ok(Json(manifest_id))
}
