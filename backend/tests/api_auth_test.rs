use axum::{
    body::{Body, to_bytes},
    http::{Request, StatusCode, header},
};
use backend::{config::Config, create_app};
use tower::ServiceExt;
use serde_json::{json, Value};
use sqlx::Row;
use bcrypt::{hash, DEFAULT_COST};

#[sqlx::test(migrations = "../database/migrations")]
async fn test_api_auth_and_roles(pool: sqlx::PgPool) {
    // 1. Setup Environment
    std::env::set_var("REDIS_URL", "redis://127.0.0.1:6379");
    let config = Config {
        database_url: "".to_string(),
        server_port: 0,
        jwt_secret: "test_secret".to_string(),
    };
    let (app, _) = create_app(pool.clone(), config).await.expect("Failed to create app");

    // 2. Seed Data
    // Create Employee
    let emp_id: i32 = sqlx::query("INSERT INTO employees (employee_code, full_name) VALUES ('E001', 'Staff Member') RETURNING employee_id")
        .fetch_one(&pool).await.unwrap().get(0);

    // Create Staff User
    let hashed_pw = hash("secret123", DEFAULT_COST).unwrap();
    let user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'staff_user', $2) RETURNING user_id")
        .bind(emp_id).bind(hashed_pw).fetch_one(&pool).await.unwrap().get(0);

    // Get Staff Preset ID
    let preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'Staff'")
        .fetch_one(&pool).await.unwrap().get(0);

    // Assign Staff Preset
    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)")
        .bind(user_id).bind(preset_id).execute(&pool).await.unwrap();

    // 3. Test Login
    let login_req = Request::builder()
        .method("POST")
        .uri("/api/auth/login")
        .header(header::CONTENT_TYPE, "application/json")
        .body(Body::from(json!({
            "username": "staff_user",
            "password": "secret123"
        }).to_string()))
        .unwrap();

    let response = app.clone().oneshot(login_req).await.unwrap();
    assert_eq!(response.status(), StatusCode::OK);

    let body = to_bytes(response.into_body(), 1024).await.unwrap();
    let body: Value = serde_json::from_slice(&body).unwrap();
    let token = body["token"].as_str().expect("Token missing");

    // 4. Test Access Staff Route (/api/outbound) -> Should be Allowed (but might fail validation 400, which is fine)
    let staff_req = Request::builder()
        .method("POST")
        .uri("/api/outbound")
        .header(header::AUTHORIZATION, format!("Bearer {}", token))
        .header(header::CONTENT_TYPE, "application/json")
        .body(Body::from(json!({
            "product_id": 1,
            "target_qty": 10,
            "task_type": "OUTBOUND"
        }).to_string()))
        .unwrap();

    let response = app.clone().oneshot(staff_req).await.unwrap();
    // It shouldn't be 401 or 403. If it's 404 (product not found) or 400 (bad request), auth passed.
    assert!(response.status() != StatusCode::UNAUTHORIZED);
    assert!(response.status() != StatusCode::FORBIDDEN);

    // 5. Test Access QA Route (/api/qc/inspection) -> Should be Forbidden (403)
    let qa_req = Request::builder()
        .method("POST")
        .uri("/api/qc/inspection")
        .header(header::AUTHORIZATION, format!("Bearer {}", token))
        .header(header::CONTENT_TYPE, "application/json")
        .body(Body::from(json!({
            "detail_id": 1,
            "passed_qty": 5,
            "failed_qty": 0
        }).to_string()))
        .unwrap();

    let response = app.clone().oneshot(qa_req).await.unwrap();
    assert_eq!(response.status(), StatusCode::FORBIDDEN);

    // 6. Test Access without token -> Should be Unauthorized (401)
    let no_auth_req = Request::builder()
        .method("POST")
        .uri("/api/outbound")
        .header(header::CONTENT_TYPE, "application/json")
        .body(Body::from(json!({}).to_string()))
        .unwrap();

    let response = app.clone().oneshot(no_auth_req).await.unwrap();
    assert_eq!(response.status(), StatusCode::UNAUTHORIZED);
}
