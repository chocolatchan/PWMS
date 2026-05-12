use axum::Router;
use crate::state::SharedState;

pub mod inbound;
pub mod inventory;
pub mod outbound;

pub fn routes() -> Router<SharedState> {
    Router::new()
        .nest("/inbound", inbound::routes())
        .nest("/inventory", inventory::routes())
        .nest("/outbound", outbound::routes())
}
