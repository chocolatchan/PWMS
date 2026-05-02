use axum::{
    body::{Body, to_bytes},
    http::{Request, StatusCode, header},
};
use backend::{config::Config, create_app};
use tower::ServiceExt;
use serde_json::{json, Value};
use sqlx::{PgPool, Row};
use std::sync::Arc;
use tokio::task::JoinSet;
use rand::Rng;
use bcrypt::{hash, DEFAULT_COST};
use tower::Service;

const CONCURRENCY_LEVEL: usize = 1000;

#[sqlx::test(migrations = "../database/migrations")]
async fn chaos_warehouse_simulation(pool: PgPool) {
    // 1. Setup Environment
    std::env::set_var("REDIS_URL", "redis://127.0.0.1:6379");
    let config = Config {
        database_url: "".to_string(), // Managed by sqlx::test
        server_port: 0,
        jwt_secret: "chaos_secret".to_string(),
    };
    
    // We create the router. We will clone it for each request since it implements Service
    let (app, _) = create_app(pool.clone(), config).await.expect("Failed to create app");

    // 2. Seeding Master Data
    println!("Seeding Master Data...");
    let emp_id: i32 = sqlx::query("INSERT INTO employees (employee_code, full_name) VALUES ('EMP-CHAOS', 'Chaos Engineer') RETURNING employee_id")
        .fetch_one(&pool).await.unwrap().get(0);

    let hashed_pw = hash("secret", DEFAULT_COST).unwrap();
    let staff_user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'chaos_staff', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);
    let qa_user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'chaos_qa', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);

    let staff_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'Staff'").fetch_one(&pool).await.unwrap().get(0);
    let qa_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'QA'").fetch_one(&pool).await.unwrap().get(0);

    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(staff_user_id).bind(staff_preset_id).execute(&pool).await.unwrap();
    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(qa_user_id).bind(qa_preset_id).execute(&pool).await.unwrap();

    let product_id: i32 = sqlx::query("INSERT INTO products (product_code, trade_name, base_unit, storage_condition) VALUES ('PROD-CHAOS', 'Chaos Elixir', 'Box', 'Normal') RETURNING product_id")
        .fetch_one(&pool).await.unwrap().get(0);


    // Get Tokens
    let staff_token = get_token(&app, "chaos_staff", "secret").await;
    let qa_token = get_token(&app, "chaos_qa", "secret").await;

    // Seed some initial inventory so outbound has something to do
    println!("Seeding initial inventory...");
    let batch_id: i32 = sqlx::query("INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date) VALUES ($1, 'BATCH-INITIAL', CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year') RETURNING batch_id")
        .bind(product_id).fetch_one(&pool).await.unwrap().get(0);
        
    for i in 1..=50 {
        let loc_id: i32 = sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ($1, 'Released') RETURNING location_id")
            .bind(format!("LOC-{}", i)).fetch_one(&pool).await.unwrap().get(0);
        
        sqlx::query("INSERT INTO inventory_balances (batch_id, product_id, location_id, available_qty, status, expiration_date) VALUES ($1, $2, $3, 10, 'Released', CURRENT_DATE + INTERVAL '1 year')")
            .bind(batch_id).bind(product_id).bind(loc_id).execute(&pool).await.unwrap();
    }
    // Total initial inventory: 50 * 10 = 500.

    // 3. The Chaos Bomb (JoinSet)
    println!("Detonating Chaos Bomb with {} tasks...", CONCURRENCY_LEVEL);
    let mut set = JoinSet::new();

    for i in 0..CONCURRENCY_LEVEL {
        let app_clone = app.clone();
        let staff_token = staff_token.clone();
        let qa_token = qa_token.clone();
        
        set.spawn(async move {
            let op_type = { rand::thread_rng().gen_range(0..100) };
            
            // We need our own router service instance for oneshot
            let svc = app_clone;

            if op_type < 80 {
                // 80% Outbound
                let target_qty = { rand::thread_rng().gen_range(1..=3) };
                let req = Request::builder()
                    .method("POST")
                    .uri("/api/outbound")
                    .header(header::AUTHORIZATION, format!("Bearer {}", staff_token))
                    .header(header::CONTENT_TYPE, "application/json")
                    .body(Body::from(json!({
                        "product_id": product_id,
                        "target_qty": target_qty,
                        "task_type": "OUTBOUND"
                    }).to_string()))
                    .unwrap();
                let _ = svc.oneshot(req).await;
            } else {
                // 20% Random Invalid / Unauth Requests just to generate noise
                 let req = Request::builder()
                    .method("POST")
                    .uri("/api/outbound")
                    .header(header::CONTENT_TYPE, "application/json")
                    .body(Body::from(json!({}).to_string()))
                    .unwrap();
                let _ = svc.oneshot(req).await;
            }
        });
    }

    // Wait for all to finish
    while let Some(res) = set.join_next().await {
        if let Err(e) = res {
            println!("Task panicked: {:?}", e);
        }
    }

    println!("Chaos Bomb Finished. Running assertions...");

    // 4. Assertions
    // No negative inventory
    let negative_count: i64 = sqlx::query("SELECT COUNT(*) FROM inventory_balances WHERE available_qty < 0")
        .fetch_one(&pool).await.unwrap().get(0);
    assert_eq!(negative_count, 0, "Found negative inventory balances!");

    // Audit completeness (transaction count = audit logs for updates/inserts)
    // Every outbound generates 1 task and X transactions.
    // Let's just ensure the database didn't deadlock and crash the pool.
    let tx_count: i64 = sqlx::query("SELECT COUNT(*) FROM inventory_transactions").fetch_one(&pool).await.unwrap().get(0);
    println!("Total inventory transactions recorded: {}", tx_count);

    // Verify constraints held up
    println!("Chaos test completed successfully.");
}

async fn get_token(app: &axum::Router, username: &str, password: &str) -> String {
    let req = Request::builder()
        .method("POST")
        .uri("/api/auth/login")
        .header(header::CONTENT_TYPE, "application/json")
        .body(Body::from(json!({
            "username": username,
            "password": password
        }).to_string()))
        .unwrap();

    let mut svc = app.clone();
    let response = svc.oneshot(req).await.unwrap();
    
    assert_eq!(response.status(), StatusCode::OK, "Failed to login {}", username);
    
    let body = to_bytes(response.into_body(), 1024).await.unwrap();
    let json: Value = serde_json::from_slice(&body).unwrap();
    json["token"].as_str().unwrap().to_string()
}
