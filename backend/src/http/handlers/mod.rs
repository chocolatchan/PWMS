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
pub mod outbound;
pub mod picking;
pub mod dispatch_handler;
pub mod approval_handler;

pub fn routes(state: SharedState) -> Router<SharedState> {
    // 1. Public Routes
    let public_routes = Router::new()
        .route("/api/auth/login", post(auth::login))
        .route("/api/picking/start", post(picking::start_task_handler))
        .route("/api/picking/submit", post(picking::submit_pick_handler))
        .route("/api/picking/complete/:task_id", post(picking::complete_task_handler));

    // 2. Protected Staff Routes (Inbound, Inventory, Outbound, Partners)
    let staff_routes = Router::new()
        .route("/api/partners", get(inbound::list_partners))
        .route("/api/inventory", get(inventory::list_inventory))
        .route("/api/inventory/trace/:batch_number", get(inventory::get_batch_traceability))
        .route("/api/outbound", post(inventory::create_outbound))
        .route("/api/outbound/screen/:order_id", post(outbound::screen_order_handler))
        .route("/api/v1/orders/:id/screen", post(outbound::screen_order_handler))
        .route("/api/inbound", get(inbound::list_inbound_receipts).post(inbound::create_inbound))
        .route("/api/inbound/receipts", post(inbound::create_receipt_header))
        .route("/api/inbound/pending", get(inbound::list_inbound_receipts))
        .route("/api/inbound/receipts/:id", get(inbound::get_receipt_details))
        .route("/api/inbound/item", post(inbound::submit_inbound_item))
        .route("/api/inbound/receipts/:id/complete", post(inbound::finish_receipt))
        .nest("/api/dispatch", Router::new()
            .route("/pack", post(dispatch_handler::pack_box_handler))
            .route("/manifest", post(dispatch_handler::create_manifest_handler))
        )
        .layer(from_fn(|req, next| require_preset(req, next, "INBOUND_STAFF")));

    // 3. Protected QA Routes (QC Inspections + Approval Level 1)
    let qa_routes = Router::new()
        .route("/api/qc/pending", get(qc::list_pending_inspections))
        .route("/api/qc/inspect", post(qc::submit_qc_inspection))
        .route("/api/approvals/pending", get(approval_handler::list_pending_approvals))
        .route("/api/approvals/submit", post(approval_handler::submit_approval))
        .route("/api/recall/emergency", post(approval_handler::emergency_recall))
        .layer(from_fn(|req, next| require_preset(req, next, "CHIEF_PHARMACIST")));

    // 4. Protected Admin Routes (Audit + Admin)
    let admin_routes = Router::new()
        .route("/api/audit", get(audit::list_audit_logs))
        .layer(from_fn(|req, next| require_preset(req, next, "WAREHOUSE_DIRECTOR")));

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
