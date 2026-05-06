use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use crate::state::SharedState;
use crate::models::dtos::StartTaskRequest;
use crate::http::middleware::auth::UserContext;
use crate::services::picking_service::PickingService;

#[axum::debug_handler]
pub async fn start_task_handler(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<StartTaskRequest>,
) -> impl IntoResponse {
    match PickingService::start_picking_task(&state.db, user_ctx.user_id, &user_ctx.presets, &payload).await {
        Ok(_) => (StatusCode::OK, "Task started successfully".to_string()).into_response(),
        Err(e) => (StatusCode::BAD_REQUEST, e).into_response(),
    }
}

#[axum::debug_handler]
pub async fn submit_pick_handler(
    State(state): State<SharedState>,
    Json(payload): Json<crate::models::dtos::SubmitPickRequest>,
) -> impl IntoResponse {
    let user_id = 1;

    match PickingService::submit_pick(&state.db, user_id, &payload).await {
        Ok(_) => (StatusCode::OK, "Item picked successfully").into_response(),
        Err(e) => (StatusCode::BAD_REQUEST, e).into_response(),
    }
}

#[axum::debug_handler]
pub async fn complete_task_handler(
    State(state): State<SharedState>,
    Path(task_id): Path<i32>,
) -> impl IntoResponse {
    let user_id = 1;

    match PickingService::complete_task(&state.db, user_id, task_id).await {
        Ok(_) => (StatusCode::OK, "Task completed successfully").into_response(),
        Err(e) => (StatusCode::BAD_REQUEST, e).into_response(),
    }
}
