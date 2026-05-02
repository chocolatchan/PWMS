use axum::http::StatusCode;
use backend::{config::Config, create_app};
use serde_json::{json, Value};
use sqlx::{PgPool, Row};
use std::net::SocketAddr;
use tokio::net::TcpListener;
use futures_util::{StreamExt, SinkExt};
use tokio_tungstenite::{connect_async, tungstenite::protocol::Message};
use reqwest::Client;
use bcrypt::{hash, DEFAULT_COST};

#[sqlx::test(migrations = "../database/migrations")]
async fn test_full_warehouse_lifecycle(pool: PgPool) {
    // 1. Setup Environment & Server
    std::env::set_var("REDIS_URL", "redis://127.0.0.1:6379");
    let config = Config {
        database_url: "".to_string(), // Managed by sqlx::test
        server_port: 0,
        jwt_secret: "e2e_secret".to_string(),
    };
    
    let (app, state) = create_app(pool.clone(), config).await.expect("Failed to create app");
    
    // Bind to a random port
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let addr = listener.local_addr().unwrap();
    let port = addr.port();
    
    // Spawn server in background
    tokio::spawn(async move {
        axum::serve(listener, app).await.unwrap();
    });

    let client = Client::new();
    let base_url = format!("http://127.0.0.1:{}", port);
    let ws_url = format!("ws://127.0.0.1:{}/ws", port);

    // 2. Phase 1: Setup & Master Data
    println!("Phase 1: Seeding Master Data...");
    let emp_id: i32 = sqlx::query("INSERT INTO employees (employee_code, full_name) VALUES ('E2E-EMP', 'E2E Tester') RETURNING employee_id")
        .fetch_one(&pool).await.unwrap().get(0);

    let hashed_pw = hash("secret", DEFAULT_COST).unwrap();
    let staff_user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'e2e_staff', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);
    let qa_user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'e2e_qa', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);

    let staff_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'Staff'").fetch_one(&pool).await.unwrap().get(0);
    let qa_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'QA'").fetch_one(&pool).await.unwrap().get(0);

    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(staff_user_id).bind(staff_preset_id).execute(&pool).await.unwrap();
    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(qa_user_id).bind(qa_preset_id).execute(&pool).await.unwrap();

    let product_id: i32 = sqlx::query("INSERT INTO products (product_code, trade_name, base_unit, storage_condition) VALUES ('E2E-PROD', 'Cold Vaccine', 'Vial', 'Cold 2-8C') RETURNING product_id")
        .fetch_one(&pool).await.unwrap().get(0);

    // Seed Quarantine and Cold locations
    sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ('Q-001', 'Quarantine')").execute(&pool).await.unwrap();
    sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ('C-001', 'Cold')").execute(&pool).await.unwrap();

    let supplier_id: i32 = sqlx::query("INSERT INTO partners (partner_type, name) VALUES ('supplier', 'E2E Supplier') RETURNING partner_id")
        .fetch_one(&pool).await.unwrap().get(0);

    // Login to get tokens
    let staff_token = get_token(&client, &base_url, "e2e_staff", "secret").await;
    let qa_token = get_token(&client, &base_url, "e2e_qa", "secret").await;

    // 3. Phase 2: Inbound
    println!("Phase 2: Inbound...");
    let inbound_res = client.post(format!("{}/api/inbound", base_url))
        .bearer_auth(&staff_token)
        .json(&json!({
            "receipt_number": "REC-E2E-001",
            "supplier_id": supplier_id, 
            "receipt_date": "2026-05-01",
            "product_id": product_id,
            "batch_id": 1, 
            "declared_qty": 100
        }))
        .send().await.unwrap();

    // Ah, wait. We need a batch. Let's seed it above.
    let batch_id: i32 = sqlx::query("INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date) VALUES ($1, 'BATCH-E2E', CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year') RETURNING batch_id")
        .bind(product_id).fetch_one(&pool).await.unwrap().get(0);
        
    // Retry inbound with correct batch
    let inbound_res = client.post(format!("{}/api/inbound", base_url))
        .bearer_auth(&staff_token)
        .json(&json!({
            "receipt_number": "REC-E2E-002",
            "supplier_id": supplier_id,
            "receipt_date": "2026-05-01",
            "product_id": product_id,
            "batch_id": batch_id,
            "declared_qty": 100
        }))
        .send().await.unwrap();
        
    let status = inbound_res.status();
    if status != StatusCode::OK {
        let err_text = inbound_res.text().await.unwrap();
        panic!("Inbound failed: {}", err_text);
    }
    
    // Find the inbound detail id
    let detail_id: i32 = sqlx::query("SELECT detail_id FROM inbound_details WHERE batch_id = $1").bind(batch_id).fetch_one(&pool).await.unwrap().get(0);

    // 4. Phase 3: QC Inspection & WebSockets
    println!("Phase 3: QC Inspection & WebSockets...");
    
    // Connect WS with QA Token (We use headers in the request)
    let ws_req = axum::http::Request::builder()
        .uri(&ws_url)
        .header("Host", format!("127.0.0.1:{}", port))
        .header("Authorization", format!("Bearer {}", qa_token))
        .header("Connection", "Upgrade")
        .header("Upgrade", "websocket")
        .header("Sec-WebSocket-Version", "13")
        .header("Sec-WebSocket-Key", "bW9ja2luZ2JpcmQ=")
        .body(())
        .unwrap();

    let (mut ws_stream, _) = connect_async(ws_req).await.expect("Failed to connect WS");

    // QA performs QC Inspection: 90 passed, 10 failed
    let qc_res = client.post(format!("{}/api/qc/inspection", base_url))
        .bearer_auth(&qa_token)
        .json(&json!({
            "detail_id": detail_id,
            "passed_qty": 90,
            "failed_qty": 10,
            "notes": "10 vials broken during transit"
        }))
        .send().await.unwrap();
        
    let status = qc_res.status();
    if status != StatusCode::OK {
        let err_text = qc_res.text().await.unwrap();
        panic!("QC failed: {}", err_text);
    }

    // Verify WebSocket receives the alert
    let msg = ws_stream.next().await.expect("Expected WS message").unwrap();
    if let Message::Text(text) = msg {
        let alert: Value = serde_json::from_str(&text).unwrap();
        assert_eq!(alert["event"], "STOCK_RELEASED");
        assert_eq!(alert["product_id"], product_id);
    } else {
        panic!("Expected text message");
    }

    // Verify DB Inventory Balance (should have 90 Released)
    let available_qty: i32 = sqlx::query("SELECT available_qty FROM inventory_balances WHERE batch_id = $1 AND status = 'Released'")
        .bind(batch_id).fetch_one(&pool).await.unwrap().get(0);
    assert_eq!(available_qty, 90);

    // 5. Phase 4: Outbound
    println!("Phase 4: Outbound...");
    let outbound_res = client.post(format!("{}/api/outbound", base_url))
        .bearer_auth(&staff_token)
        .json(&json!({
            "product_id": product_id,
            "target_qty": 50,
            "task_type": "OUTBOUND"
        }))
        .send().await.unwrap();
        
    let status = outbound_res.status();
    if status != StatusCode::OK {
        let err_text = outbound_res.text().await.unwrap();
        panic!("Outbound failed: {}", err_text);
    }

    // Verify remaining inventory is 40
    let remaining_qty: i32 = sqlx::query("SELECT available_qty FROM inventory_balances WHERE batch_id = $1 AND status = 'Released'")
        .bind(batch_id).fetch_one(&pool).await.unwrap().get(0);
    assert_eq!(remaining_qty, 40);

    // 6. Phase 5: Sensor Monitoring Trigger
    println!("Phase 5: Sensor Monitoring...");
    // Since we can't reliably wait for the cronjob, let's manually invoke the sensor service method
    backend::services::sensor::SensorService::trigger_check_now(state).await; 
    // Wait, trigger_check_now doesn't exist. I'll need to modify sensor.rs to expose it. Let's do that next.
    
    // For now, let's just wait a moment to see if the cronjob hits, or we just trust it.
    // The cronjob runs every 30s. Waiting 30s in a test is bad. We must expose the check method.

    // 7. Phase 6: Audit Trail Verification
    println!("Phase 6: Audit Trail Verification...");
    // We expect 3 distinct operations that wrote to audited tables:
    // 1. Inbound (inserts into inbound_receipts, inbound_details)
    // 2. QC (inserts into qc_inspections, inventory_balances)
    // 3. Outbound (inserts into warehouse_tasks, inventory_transactions, updates inventory_balances)
    
    let audit_count: i64 = sqlx::query("SELECT COUNT(*) FROM audit_logs WHERE changed_by IS NOT NULL")
        .fetch_one(&pool).await.unwrap().get(0);
    
    assert!(audit_count >= 5, "Not enough audit logs captured! Expected at least 5, got {}", audit_count);

    // Specifically check that Outbound's inventory update was logged by staff_user_id
    let update_audit_user: i32 = sqlx::query("SELECT changed_by FROM audit_logs WHERE table_name = 'inventory_balances' AND action = 'UPDATE' ORDER BY log_id DESC LIMIT 1")
        .fetch_one(&pool).await.unwrap().get(0);
    assert_eq!(update_audit_user, staff_user_id, "Audit context was not correctly injected into the trigger!");

    println!("E2E Lifecycle Test Completed Successfully!");
}

async fn get_token(client: &Client, base_url: &str, username: &str, password: &str) -> String {
    let res = client.post(format!("{}/api/auth/login", base_url))
        .json(&json!({
            "username": username,
            "password": password
        }))
        .send().await.unwrap();
        
    assert_eq!(res.status(), StatusCode::OK, "Failed to login {}", username);
    
    let body: Value = res.json().await.unwrap();
    body["token"].as_str().unwrap().to_string()
}
