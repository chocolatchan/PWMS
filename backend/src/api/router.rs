use axum::{
    routing::{post, get, delete}, 
    Router,
    middleware::from_fn,
    http::header,
    extract::FromRef,
};
use sqlx::PgPool;
use tower_http::cors::{CorsLayer, Any};
use utoipa_swagger_ui::SwaggerUi;
use utoipa::OpenApi;
use tokio::sync::broadcast;

use crate::api::handlers::*;
use crate::api::auth_middleware::auth_middleware;
use crate::api::api_key_middleware::api_key_middleware;
use crate::api::docs::ApiDoc;
use crate::api::ws_handler::handle_ws;
use crate::models::dtos::OutboxEventMessage;

#[derive(Clone)]
pub struct AppState {
    pub pool: PgPool,
    pub event_tx: broadcast::Sender<OutboxEventMessage>,
}

impl FromRef<AppState> for PgPool {
    fn from_ref(state: &AppState) -> Self {
        state.pool.clone()
    }
}

impl FromRef<AppState> for broadcast::Sender<OutboxEventMessage> {
    fn from_ref(state: &AppState) -> Self {
        state.event_tx.clone()
    }
}

pub fn build_router(pool: PgPool, event_tx: broadcast::Sender<OutboxEventMessage>) -> Router {
    let state = AppState {
        pool: pool.clone(),
        event_tx,
    };

    // Configure CORS
    let cors = CorsLayer::new()
        .allow_methods([
            axum::http::Method::GET, 
            axum::http::Method::POST, 
            axum::http::Method::PUT, 
            axum::http::Method::DELETE, 
            axum::http::Method::OPTIONS
        ])
        .allow_headers([
            header::CONTENT_TYPE, 
            header::AUTHORIZATION,
            header::HeaderName::from_static("x-api-key")
        ])
        .allow_origin(Any);

    let protected_routes = Router::new()
        .route("/inbound", post(handle_receive_inbound))
        .route("/inbound/purchase-orders", get(handle_list_purchase_orders).post(handle_create_purchase_order))
        .route("/inbound/quarantine", post(handle_move_to_quarantine))
        .route("/inbound/draft/bind", post(handle_bind_draft))
        .route("/inbound/draft/save", post(handle_save_draft))
        .route("/inbound/draft/unbind", post(handle_unbind_draft))
        .route("/inbound/drafts", get(handle_list_active_drafts))
        .route("/products/barcode/:barcode", get(handle_get_product_by_barcode))
        .route("/inbound/draft/active", get(handle_get_active_draft))
        .route("/qc", post(handle_submit_qc))
        .route("/qc/batch/:batch_number", get(handle_get_qc_batch))
        .route("/orders", post(handle_create_order))
        .route("/orders", get(handle_list_orders))
        .route("/products", get(handle_list_products))
        .route("/containers", get(handle_list_containers))
        .route("/containers/:container_id/items", get(handle_get_container_items))
        .route("/outbound/pick", post(handle_scan_pick))
        .route("/outbound/pack", post(handle_pack_container))
        .route("/outbound/dispatch", post(handle_dispatch))
        .route("/outbound/pick-tasks", axum::routing::get(handle_get_pick_tasks))
        .route("/runner/internal/transfer", post(handle_internal_runner_transfer))
        .route("/runner/external/transfer", post(handle_external_runner_transfer))
        .route("/runner/lookup/:barcode", get(handle_runner_lookup))
        .route("/runner/tasks", get(handle_get_pending_runner_tasks))
        .route("/admin/users", get(handle_list_users).post(handle_create_user))
        .route("/admin/users/:id", delete(handle_delete_user))
        .layer(from_fn(auth_middleware))
        .with_state(state.clone());

    let iot_routes = Router::new()
        .route("/temperature", post(handle_iot_temperature))
        .layer(from_fn(api_key_middleware))
        .with_state(state.clone());

    Router::new()
        .merge(SwaggerUi::new("/swagger-ui").url("/api-docs/openapi.json", ApiDoc::openapi()))
        .route("/api/v2/login", post(handle_login).with_state(state.clone()))
        .route("/api/v2/ws", get(handle_ws).with_state(state.clone()))
        .nest("/api/v2", protected_routes)
        .nest("/api/v2/iot", iot_routes)
        .layer(cors)
}






