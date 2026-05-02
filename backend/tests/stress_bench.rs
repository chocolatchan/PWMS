use axum::http::StatusCode;
use backend::{config::Config, create_app};
use serde_json::json;
use sqlx::{PgPool, Row};
use std::sync::Arc;
use tokio::net::TcpListener;
use reqwest::Client;
use bcrypt::{hash, DEFAULT_COST};
use std::time::Instant;

const HAMMER_COUNT: usize = 500;

#[sqlx::test(migrations = "../database/migrations")]
async fn stress_hammer_hot_batch(pool: PgPool) {
    // 1. Setup Environment
    std::env::set_var("REDIS_URL", "redis://127.0.0.1:6379");
    let config = Config {
        database_url: "".to_string(), // Managed by sqlx::test
        server_port: 0,
        jwt_secret: "stress_secret".to_string(),
    };
    
    // We increase pool size for the test instance too
    // Note: sqlx::test creates its own pool, but we need to ensure the app uses a capable one.
    let (app, _) = create_app(pool.clone(), config).await.expect("Failed to create app");
    
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let addr = listener.local_addr().unwrap();
    let base_url = format!("http://{}", addr);
    
    tokio::spawn(async move {
        axum::serve(listener, app).await.unwrap();
    });

    let client = Client::new();

    // 2. Seed Master Data
    let emp_id: i32 = sqlx::query("INSERT INTO employees (employee_code, full_name) VALUES ('STRESS-EMP', 'Stress Tester') RETURNING employee_id")
        .fetch_one(&pool).await.unwrap().get(0);
    let hashed_pw = hash("secret", DEFAULT_COST).unwrap();
    let user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'stress_user', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);
    let staff_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'Staff'").fetch_one(&pool).await.unwrap().get(0);
    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(user_id).bind(staff_preset_id).execute(&pool).await.unwrap();

    let product_id: i32 = sqlx::query("INSERT INTO products (product_code, trade_name, base_unit, storage_condition) VALUES ('HOT-SKU', 'Stress Serum', 'Vial', 'Normal') RETURNING product_id")
        .fetch_one(&pool).await.unwrap().get(0);
    let batch_id: i32 = sqlx::query("INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date) VALUES ($1, 'B-STRESS', CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year') RETURNING batch_id")
        .bind(product_id).fetch_one(&pool).await.unwrap().get(0);
    // Seed 50 locations for the Hot-SKU to test distributed contention
    let mut loc_ids = Vec::new();
    for i in 0..50 {
        let l_id: i32 = sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ($1, 'Released') RETURNING location_id")
            .bind(format!("S-{}", i)).fetch_one(&pool).await.unwrap().get(0);
        loc_ids.push(l_id);
        
        sqlx::query("INSERT INTO inventory_balances (location_id, product_id, batch_id, available_qty, status, expiration_date) VALUES ($1, $2, $3, $4, 'Released', CURRENT_DATE + INTERVAL '1 year')")
            .bind(l_id).bind(product_id).bind(batch_id).bind((HAMMER_COUNT / 50) as i32).execute(&pool).await.unwrap();
    }

    // Login
    let login_res = client.post(format!("{}/api/auth/login", base_url))
        .json(&json!({"username": "stress_user", "password": "secret"}))
        .send().await.unwrap();
    let token = login_res.json::<serde_json::Value>().await.unwrap()["token"].as_str().unwrap().to_string();

    println!("--- DETONATING HOT-BATCH HAMMER: {} requests ---", HAMMER_COUNT);
    let start = Instant::now();

    let mut set = tokio::task::JoinSet::new();
    for _ in 0..HAMMER_COUNT {
        let cl = client.clone();
        let url = format!("{}/api/outbound", base_url);
        let tk = token.clone();
        set.spawn(async move {
            cl.post(url)
                .bearer_auth(tk)
                .json(&json!({
                    "product_id": product_id,
                    "target_qty": 1,
                    "task_type": "OUTBOUND"
                }))
                .send()
                .await
        });
    }

    let mut success = 0;
    let mut failure = 0;
    while let Some(res) = set.join_next().await {
        match res {
            Ok(Ok(resp)) => {
                if resp.status() == StatusCode::OK { success += 1; } 
                else { 
                    let status = resp.status();
                    let body = resp.text().await.unwrap_or_default();
                    println!("Request Failed! Status: {}, Body: {}", status, body);
                    failure += 1; 
                }
            }
            _ => failure += 1,
        }
    }

    let duration = start.elapsed();
    println!("--- HAMMER RESULTS ---");
    println!("Total Requests: {}", HAMMER_COUNT);
    println!("Success: {}", success);
    println!("Failure: {}", failure);
    println!("Duration: {:?}", duration);
    println!("Throughput: {:.2} req/sec", HAMMER_COUNT as f64 / duration.as_secs_f64());

    // Conservation of Mass Check
    let remaining_qty: i32 = sqlx::query("SELECT available_qty FROM inventory_balances WHERE batch_id = $1")
        .bind(batch_id).fetch_one(&pool).await.unwrap().get(0);
    println!("Final Remaining Qty: {}", remaining_qty);

    let db_tx_count: i64 = sqlx::query("SELECT COUNT(*) FROM inventory_transactions").fetch_one(&pool).await.unwrap().get(0);
    let db_audit_count: i64 = sqlx::query("SELECT COUNT(*) FROM audit_logs WHERE action = 'UPDATE' AND changed_at > NOW() - INTERVAL '2 minutes'").fetch_one(&pool).await.unwrap().get(0);
    println!("SMOKING_GUN_TX: {}", db_tx_count);
    println!("SMOKING_GUN_AUDIT: {}", db_audit_count);
    
    assert_eq!(success, HAMMER_COUNT);
    assert_eq!(remaining_qty, 0);
}

#[sqlx::test(migrations = "../database/migrations")]
async fn stress_audit_log_flood(pool: PgPool) {
    // 1. Setup Environment
    std::env::set_var("REDIS_URL", "redis://127.0.0.1:6379");
    let config = Config {
        database_url: "".to_string(),
        server_port: 0,
        jwt_secret: "stress_secret_2".to_string(),
    };
    
    let (app, _) = create_app(pool.clone(), config).await.expect("Failed to create app");
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let addr = listener.local_addr().unwrap();
    let base_url = format!("http://{}", addr);
    
    tokio::spawn(async move {
        axum::serve(listener, app).await.unwrap();
    });

    let client = Client::new();

    // 2. Seed Master Data (100 products)
    let emp_id: i32 = sqlx::query("INSERT INTO employees (employee_code, full_name) VALUES ('FLOOD-EMP', 'Flood Tester') RETURNING employee_id")
        .fetch_one(&pool).await.unwrap().get(0);
    let hashed_pw = hash("secret", DEFAULT_COST).unwrap();
    let user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'flood_user', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);
    let staff_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'Staff'").fetch_one(&pool).await.unwrap().get(0);
    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(user_id).bind(staff_preset_id).execute(&pool).await.unwrap();

    let loc_id: i32 = sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ('FLOOD-001', 'Released') RETURNING location_id")
        .fetch_one(&pool).await.unwrap().get(0);

    let mut product_ids = Vec::new();
    for i in 0..100 {
        let p_id: i32 = sqlx::query("INSERT INTO products (product_code, trade_name, base_unit, storage_condition) VALUES ($1, $2, 'Box', 'Normal') RETURNING product_id")
            .bind(format!("P-{}", i)).bind(format!("Product {}", i)).fetch_one(&pool).await.unwrap().get(0);
        
        let b_id: i32 = sqlx::query("INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date) VALUES ($1, $2, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year') RETURNING batch_id")
            .bind(p_id).bind(format!("B-{}", i)).fetch_one(&pool).await.unwrap().get(0);

        // 5 locations per product
        for j in 0..5 {
            let l_id: i32 = sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ($1, 'Released') RETURNING location_id")
                .bind(format!("L-{}-{}", i, j)).fetch_one(&pool).await.unwrap().get(0);

            sqlx::query("INSERT INTO inventory_balances (location_id, product_id, batch_id, available_qty, status, expiration_date) VALUES ($1, $2, $3, 2, 'Released', CURRENT_DATE + INTERVAL '1 year')")
                .bind(l_id).bind(p_id).bind(b_id).execute(&pool).await.unwrap();
        }
            
        product_ids.push(p_id);
    }

    // Login
    let login_res = client.post(format!("{}/api/auth/login", base_url))
        .json(&json!({"username": "flood_user", "password": "secret"}))
        .send().await.unwrap();
    let token = login_res.json::<serde_json::Value>().await.unwrap()["token"].as_str().unwrap().to_string();

    println!("--- DETONATING AUDIT LOG FLOOD: 100 products x 10 outbounds = 1000 requests ---");
    let start = Instant::now();

    let mut set = tokio::task::JoinSet::new();
    for &p_id in &product_ids {
        for _ in 0..10 {
            let cl = client.clone();
            let url = format!("{}/api/outbound", base_url);
            let tk = token.clone();
            set.spawn(async move {
                cl.post(url)
                    .bearer_auth(tk)
                    .json(&json!({
                        "product_id": p_id,
                        "target_qty": 1,
                        "task_type": "OUTBOUND"
                    }))
                    .send()
                    .await
            });
        }
    }

    let mut success = 0;
    let mut failure = 0;
    while let Some(res) = set.join_next().await {
        match res {
            Ok(Ok(resp)) => {
                if resp.status() == StatusCode::OK { success += 1; } 
                else { 
                    let status = resp.status();
                    let body = resp.text().await.unwrap_or_default();
                    println!("Request Failed! Status: {}, Body: {}", status, body);
                    failure += 1; 
                }
            }
            _ => failure += 1,
        }
    }

    let duration = start.elapsed();
    println!("--- FLOOD RESULTS ---");
    println!("Success: {}, Failure: {}", success, failure);
    println!("Duration: {:?}", duration);

    // Verify Audit Log count
    let audit_count: i64 = sqlx::query("SELECT COUNT(*) FROM audit_logs WHERE table_name = 'inventory_balances' AND action = 'UPDATE'")
        .fetch_one(&pool).await.unwrap().get(0);
    println!("Total Inventory Balance Audit Logs: {}", audit_count);

    let db_tx_count: i64 = sqlx::query("SELECT COUNT(*) FROM inventory_transactions").fetch_one(&pool).await.unwrap().get(0);
    let db_audit_count: i64 = sqlx::query("SELECT COUNT(*) FROM audit_logs WHERE action = 'UPDATE' AND changed_at > NOW() - INTERVAL '2 minutes'").fetch_one(&pool).await.unwrap().get(0);
    println!("SMOKING_GUN_TX: {}", db_tx_count);
    println!("SMOKING_GUN_AUDIT: {}", db_audit_count);
    
    assert!(success >= 1000);
}
