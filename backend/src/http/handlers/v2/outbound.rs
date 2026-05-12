use axum::{Router, routing::post};
use crate::state::SharedState;

pub fn routes() -> Router<SharedState> {
    Router::new()
        // .route("/dispatch", post(dispatch_order))
}
