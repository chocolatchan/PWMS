use axum::{extract::State, Json, http::StatusCode};
use crate::state::AppState;
use crate::models::dtos::{PackBoxRequest, CreateManifestRequest};
use crate::services::dispatch_service::DispatchService;
use std::sync::Arc;

pub async fn pack_box_handler(
    State(state): State<Arc<AppState>>,
    Json(req): Json<PackBoxRequest>,
) -> Result<Json<i32>, (StatusCode, String)> {
    let user_id = 1; // Mock
    
    match DispatchService::pack_box(&state.db, user_id, &req).await {
        Ok(box_id) => Ok(Json(box_id)),
        Err(e) => Err((StatusCode::BAD_REQUEST, e)),
    }
}

pub async fn create_manifest_handler(
    State(state): State<Arc<AppState>>,
    Json(req): Json<CreateManifestRequest>,
) -> Result<Json<i32>, (StatusCode, String)> {
    let user_id = 1; // Mock
    
    match DispatchService::create_manifest(&state.db, user_id, &req).await {
        Ok(manifest_id) => Ok(Json(manifest_id)),
        Err(e) => Err((StatusCode::BAD_REQUEST, e)),
    }
}
