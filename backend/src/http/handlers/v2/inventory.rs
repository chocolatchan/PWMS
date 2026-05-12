use axum::{Router, routing::post};
use crate::state::SharedState;

pub fn routes() -> Router<SharedState> {
    Router::new()
        // .route("/cycle-count", post(submit_cycle_count))
}
