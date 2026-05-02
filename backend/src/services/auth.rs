use crate::error::AppError;
use jsonwebtoken::{encode, Header, EncodingKey};
use serde::{Deserialize, Serialize};
use sqlx::Row;

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: i32, // user_id
    pub exp: usize,
    pub presets: Vec<String>,
}

pub struct AuthService;

impl AuthService {
    pub fn generate_token(user_id: i32, presets: Vec<String>, secret: &str) -> Result<String, AppError> {
        let expiration = chrono::Utc::now()
            .checked_add_signed(chrono::Duration::hours(24))
            .expect("valid timestamp")
            .timestamp() as usize;

        let claims = Claims {
            sub: user_id,
            exp: expiration,
            presets,
        };

        encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(secret.as_ref()),
        )
        .map_err(|e| {
            tracing::error!("Token generation error: {}", e);
            AppError::Internal("Failed to generate token".to_string())
        })
    }

    /// Verifies a user's password for E-Sign purposes.
    /// This is used for high-stakes actions like QC Approval/Rejection.
    pub async fn verify_esign(db: &sqlx::PgPool, user_id: i32, password: &str) -> Result<(), AppError> {
        let user = sqlx::query("SELECT password_hash FROM users WHERE user_id = $1")
            .bind(user_id)
            .fetch_one(db)
            .await
            .map_err(|_| AppError::Unauthorized)?;

        let password_hash: String = user.get("password_hash");

        if !bcrypt::verify(password, &password_hash).map_err(|_| AppError::Internal("Hashing error".to_string()))? {
            return Err(AppError::Forbidden("Invalid E-Sign credentials".to_string()));
        }

        Ok(())
    }
}
