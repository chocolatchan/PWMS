use backend::{
    config::Config, 
    api::router::build_router, 
    workers::outbox_consumer::start_outbox_worker,
    workers::expiry_worker::start_expiry_worker,
};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};
use tokio::sync::watch;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. Initialize tracing
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "backend=debug,tower_http=debug,axum::rejection=trace".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    // 2. Load Configuration
    let config = Config::load();

    // 3. Setup Database Connection Pool
    let db_pool = sqlx::postgres::PgPoolOptions::new()
        .max_connections(50)
        .connect(&config.database_url)
        .await?;

    // 4. Setup Shutdown Channel and Outbox Broadcast Channel
    let (shutdown_tx, shutdown_rx) = watch::channel(());
    let (event_tx, _event_rx) = tokio::sync::broadcast::channel(100);

    // 5. Start background workers
    let worker_pool = db_pool.clone();
    let worker_event_tx = event_tx.clone();
    let _outbox_handle = tokio::spawn(async move {
        start_outbox_worker(worker_pool, shutdown_rx, worker_event_tx).await;
    });

    let expiry_pool = db_pool.clone();
    let _expiry_handle = tokio::spawn(async move {
        start_expiry_worker(expiry_pool).await;
    });

    // 6. Build Axum Router
    let app = build_router(db_pool.clone(), event_tx);

    // 7. Start Server with Graceful Shutdown
    let host = std::env::var("API_IP").unwrap_or_else(|_| "0.0.0.0".to_string());
    let port = std::env::var("SERVER_PORT").unwrap_or_else(|_| "3000".to_string());
    let server_addr = format!("{}:{}", host, port);

    println!("🚀 PWMS V2 Backend đang lắng nghe tại: {}", server_addr);

    let listener = tokio::net::TcpListener::bind(&server_addr).await?;
    
    axum::serve(listener, app)
        .with_graceful_shutdown(async move {
            tokio::signal::ctrl_c()
                .await
                .expect("failed to install Ctrl+C handler");
            println!("🛑 Signal received, starting graceful shutdown...");
            
            // Notify background workers to stop
            let _ = shutdown_tx.send(());
        })
        .await?;

    // 8. Wait for background workers to finish
    println!("⏳ Waiting for background workers to finish...");
    let _ = tokio::join!(_outbox_handle, _expiry_handle);

    println!("✨ PWMS Backend shut down successfully.");
    Ok(())
}
