use axum::{
    Router, 
    routing::{post, get},
    middleware::{from_fn, from_fn_with_state},
};
use crate::state::SharedState;
use crate::http::middleware::{
    auth_layer::auth_middleware,
    role_guard::require_preset,
};

pub mod inventory;
pub mod inbound;
pub mod qc;
pub mod auth;
pub mod audit;
pub mod ws;

pub fn routes(state: SharedState) -> Router<SharedState> {
    // 1. Public Routes
    let public_routes = Router::new()
        .route("/api/auth/login", post(auth::login));

    // 2. Protected Staff Routes
    let staff_routes = Router::new()
        .route("/api/inventory", get(inventory::list_inventory))
        .route("/api/inventory/trace/:batch_number", get(inventory::get_batch_traceability))
        .route("/api/outbound", post(inventory::create_outbound))
        .route("/api/inbound", get(inbound::list_inbound_receipts).post(inbound::create_inbound))
        .layer(from_fn(|req, next| require_preset(req, next, "Staff")));

    // 3. Protected QA Routes
    let qa_routes = Router::new()
        .route("/api/qc/pending", get(qc::list_pending_inspections))
        .route("/api/qc/inspect", post(qc::submit_qc_inspection))
        .layer(from_fn(|req, next| require_preset(req, next, "QA")));

    // 4. Protected Admin Routes
    let admin_routes = Router::new()
        .route("/api/audit", get(audit::list_audit_logs))
        .layer(from_fn(|req, next| require_preset(req, next, "Admin")));

    // 5. General Auth Routes
    let auth_routes = Router::new()
        .route("/ws", get(ws::ws_handler))
        .merge(staff_routes)
        .merge(qa_routes)
        .merge(admin_routes)
        .layer(from_fn_with_state(state.clone(), auth_middleware));

    Router::new()
        .merge(public_routes)
        .merge(auth_routes)
}
