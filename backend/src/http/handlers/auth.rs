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
#[serde(rename_all = "camelCase")]
pub struct UserResponse {
    pub id: i32,
    pub username: String,
    pub full_name: String,
    pub permissions: Vec<String>,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct LoginResponse {
    pub token: String,
    pub user: UserResponse,
}

pub async fn login(
    State(state): State<SharedState>,
    Json(payload): Json<LoginPayload>,
) -> Result<Json<LoginResponse>, AppError> {
    tracing::debug!("Login attempt for username: {}", payload.username);

    // 1. Fetch user and employee data along with granular permissions
    let user_row = sqlx::query(
        r#"
        SELECT 
            u.user_id, 
            u.password_hash, 
            e.full_name,
            array_remove(array_agg(DISTINCT p.preset_name), NULL) as presets,
            array_remove(array_agg(DISTINCT perm.permission_code), NULL) as permissions
        FROM users u
        INNER JOIN employees e ON u.employee_id = e.employee_id
        LEFT JOIN user_presets up ON u.user_id = up.user_id
        LEFT JOIN presets p ON up.preset_id = p.preset_id
        LEFT JOIN preset_permissions pp ON up.preset_id = pp.preset_id
        LEFT JOIN permissions perm ON pp.permission_id = perm.permission_id
        WHERE u.username = $1 AND u.is_active = true
        GROUP BY u.user_id, u.password_hash, e.full_name
        "#
    )
    .bind(&payload.username)
    .fetch_optional(&state.db)
    .await?
    .ok_or(AppError::Unauthorized)?;

    let user_id: i32 = user_row.get("user_id");
    let password_hash: String = user_row.get("password_hash");
    let full_name: String = user_row.get("full_name");
    let presets: Vec<String> = user_row.try_get("presets").unwrap_or_default();
    let permissions: Vec<String> = user_row.try_get("permissions").unwrap_or_default();

    // 2. Verify password
    if !verify(&payload.password, &password_hash).map_err(|_| AppError::Internal("Hashing error".to_string()))? {
        tracing::warn!("Invalid password for user: {}", payload.username);
        return Err(AppError::Unauthorized);
    }

    // 3. Generate token
    let token = AuthService::generate_token(user_id, presets.clone(), &state.config.jwt_secret)?;

    tracing::info!("Successful login for user: {}", payload.username);

    // 4. Return structured response matching frontend expectation
    Ok(Json(LoginResponse {
        token,
        user: UserResponse {
            id: user_id,
            username: payload.username,
            full_name,
            permissions,
        },
    }))
}
