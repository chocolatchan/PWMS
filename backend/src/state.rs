use sqlx::PgPool;
use std::sync::Arc;
use tokio::sync::broadcast;
use crate::config::Config;
use redis::Client as RedisClient;

#[derive(Clone, Debug, serde::Serialize)]
pub struct AlertMsg {
    pub event: String,
    pub product_id: Option<i32>,
    pub message: String,
}

#[derive(Clone)]
pub struct AppState {
    pub db: PgPool,
    pub redis: RedisClient,
    pub config: Config,
    pub ws_sender: broadcast::Sender<AlertMsg>,
}

impl AppState {
    pub fn new(db: PgPool, redis: RedisClient, config: Config) -> Self {
        let (ws_sender, _) = broadcast::channel(100);
        Self { db, redis, config, ws_sender }
    }
}

pub type SharedState = Arc<AppState>;
