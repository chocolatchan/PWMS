pub mod config;
pub mod error;
pub mod http;
pub mod services;
pub mod state;
pub mod models;
pub mod repositories;

use axum::Router;
use std::sync::Arc;
use config::Config;
use state::AppState;

pub async fn create_app(db_pool: sqlx::PgPool, config: Config) -> Result<(axum::Router, state::SharedState), Box<dyn std::error::Error>> {
    // 1. Setup Redis Client
    let redis_url = std::env::var("REDIS_URL").unwrap_or_else(|_| "redis://127.0.0.1:6379".to_string());
    let redis_client = redis::Client::open(redis_url)?;

    // 3. Create AppState
    let state = Arc::new(AppState::new(db_pool, redis_client, config.clone()));

    // 4. Start Background Jobs
    crate::services::sensor::SensorService::start_monitoring(state.clone()).await?;

    // 5. Build Router
    let app = Router::new()
        .nest("/", http::handlers::routes(state.clone()))
        .layer(
            tower_http::cors::CorsLayer::new()
                .allow_origin(tower_http::cors::Any)
                .allow_methods(tower_http::cors::Any)
                .allow_headers(tower_http::cors::Any),
        )
        .with_state(state.clone());

    Ok((app, state))
}
