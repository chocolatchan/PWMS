use backend::{config::Config, create_app};
use std::net::SocketAddr;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

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

    // 4. Create App
    let (app, _) = create_app(db_pool, config.clone()).await?;

    // 4. Start Server
    let host = std::env::var("SERVER_HOST").unwrap_or_else(|_| "0.0.0.0".to_string());
    let port = std::env::var("SERVER_PORT").unwrap_or_else(|_| "3000".to_string());
    let server_addr = format!("{}:{}", host, port);

    println!("🚀 Backend API đang lắng nghe tại: {}", server_addr);
    println!("⚠️ Lưu ý: Để test trên PDA vật lý, hãy đổi baseUrl trong Flutter thành IP LAN của máy này (vd: 192.168.x.x)");

    let listener = tokio::net::TcpListener::bind(&server_addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();

    Ok(())
}
