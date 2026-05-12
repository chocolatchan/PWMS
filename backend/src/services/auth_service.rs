use bcrypt::{hash, verify, DEFAULT_COST};
use jsonwebtoken::{encode, decode, Header, EncodingKey, DecodingKey, Validation};
use serde::{Serialize, Deserialize};
use uuid::Uuid;
use chrono::{Utc, Duration};
use sqlx::PgPool;
use crate::error::AppError;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Claims {
    pub sub: String,      // user id
    pub username: String,
    pub role: String,
    pub exp: usize,
}

pub struct AuthService;

impl AuthService {
    pub fn generate_token(user_id: &Uuid, username: &str, role: &str) -> Result<String, AppError> {
        let expiration = Utc::now()
            .checked_add_signed(Duration::hours(8))
            .expect("valid timestamp")
            .timestamp() as usize;

        let claims = Claims {
            sub: user_id.to_string(),
            username: username.to_string(),
            role: role.to_string(),
            exp: expiration,
        };

        let secret = std::env::var("JWT_SECRET").map_err(|_| AppError::InternalServerError("JWT_SECRET not set".into()))?;
        encode(&Header::default(), &claims, &EncodingKey::from_secret(secret.as_bytes()))
            .map_err(|e| AppError::InternalServerError(e.to_string()))
    }

    pub fn verify_token(token: &str) -> Result<Claims, AppError> {
        let secret = std::env::var("JWT_SECRET").map_err(|_| AppError::InternalServerError("JWT_SECRET not set".into()))?;
        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(secret.as_bytes()),
            &Validation::default(),
        ).map_err(|_| AppError::Unauthorized("Invalid token".into()))?;
        Ok(token_data.claims)
    }

    pub async fn login(pool: &PgPool, username: &str, password: &str) -> Result<String, AppError> {
        let user = sqlx::query!(
            "SELECT id, username, role, password_hash FROM users WHERE username = $1",
            username
        )
        .fetch_optional(pool)
        .await
        .map_err(|e| AppError::DatabaseError(e))?
        .ok_or_else(|| AppError::Unauthorized("Invalid credentials".into()))?;

        if !verify(password, &user.password_hash).map_err(|_| AppError::Unauthorized("Invalid credentials".into()))? {
            return Err(AppError::Unauthorized("Invalid credentials".into()));
        }

        Self::generate_token(&user.id, &user.username, &user.role)
    }

    pub async fn hash_password(password: &str) -> Result<String, AppError> {
        hash(password, DEFAULT_COST).map_err(|e| AppError::InternalServerError(e.to_string()))
    }
}
