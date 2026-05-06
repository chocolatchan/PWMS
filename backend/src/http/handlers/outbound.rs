use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use crate::state::SharedState;
use crate::models::dtos::ScreenOrderResponse;
use crate::services::outbound_service::OutboundService;

#[axum::debug_handler]
pub async fn screen_order_handler(
    State(state): State<SharedState>,
    Path(order_id): Path<i32>,
) -> impl IntoResponse {
    match OutboundService::screen_order(&state.db, order_id).await {
        Ok(task_ids) => (
            StatusCode::OK,
            Json(ScreenOrderResponse {
                message: "Order screened and tasks created successfully".to_string(),
                created_task_ids: task_ids,
            }),
        ),
        Err(e) => {
            eprintln!("Error screening order: {:?}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                Json(ScreenOrderResponse {
                    message: format!("Failed to screen order: {}", e),
                    created_task_ids: vec![],
                }),
            )
        }
    }
}
