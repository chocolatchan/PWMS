use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use bcrypt::verify;
use sqlx::Row;
use crate::{
    error::AppError,
    services::auth::AuthService,
    state::SharedState,
};

#[derive(Deserialize)]
pub struct LoginPayload {
    pub username: String,
    pub password: String,
}

#[derive(Serialize)]
pub struct LoginResponse {
    pub token: String,
    pub username: String,
    pub presets: Vec<String>,
}

pub async fn login(
    State(state): State<SharedState>,
    Json(payload): Json<LoginPayload>,
) -> Result<Json<LoginResponse>, AppError> {
    tracing::debug!("Login attempt for username: {}", payload.username);

    // 1. Fetch user from database
    let user = sqlx::query(
        r#"
        SELECT u.user_id, u.password_hash, array_agg(p.preset_name) as presets
        FROM users u
        LEFT JOIN user_presets up ON u.user_id = up.user_id
        LEFT JOIN presets p ON up.preset_id = p.preset_id
        WHERE u.username = $1 AND u.is_active = true
        GROUP BY u.user_id, u.password_hash
        "#
    )
    .bind(&payload.username)
    .fetch_optional(&state.db)
    .await?
    .ok_or(AppError::Unauthorized)?;

    let user_id: i32 = user.get("user_id");
    let password_hash: String = user.get("password_hash");
    let presets: Vec<String> = user.get::<Vec<String>, _>("presets");

    // 2. Verify password
    if !verify(&payload.password, &password_hash).map_err(|_| AppError::Internal("Hashing error".to_string()))? {
        tracing::warn!("Invalid password for user: {}", payload.username);
        return Err(AppError::Unauthorized);
    }

    // 3. Generate token
    let token = AuthService::generate_token(user_id, presets.clone(), &state.config.jwt_secret)?;

    tracing::info!("Successful login for user: {}", payload.username);

    Ok(Json(LoginResponse {
        token,
        username: payload.username,
        presets,
    }))
}
