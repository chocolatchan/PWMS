use axum::{
    async_trait,
    extract::FromRequestParts,
    http::request::Parts,
};

use jsonwebtoken::{decode, DecodingKey, Validation};
use crate::{error::AppError, services::auth::Claims, state::SharedState};

#[derive(Clone, Debug)]
pub struct UserContext {
    pub user_id: i32,
    pub presets: Vec<String>,
}

#[async_trait]
impl FromRequestParts<SharedState> for UserContext {
    type Rejection = AppError;

    async fn from_request_parts(parts: &mut Parts, state: &SharedState) -> Result<Self, Self::Rejection> {
        // 1. Check if already extracted (e.g. by a previous middleware)
        if let Some(ctx) = parts.extensions.get::<UserContext>() {
            return Ok(ctx.clone());
        }

        // 2. Decode JWT
        let auth_header = parts.headers.get(axum::http::header::AUTHORIZATION)
            .and_then(|val| val.to_str().ok())
            .and_then(|val| val.strip_prefix("Bearer "))
            .ok_or(AppError::Unauthorized)?;

        let token_data = decode::<Claims>(
            auth_header,
            &DecodingKey::from_secret(state.config.jwt_secret.as_ref()),
            &Validation::default(),
        )
        .map_err(|_| AppError::Unauthorized)?;

        let ctx = UserContext {
            user_id: token_data.claims.sub,
            presets: token_data.claims.presets,
        };

        // 3. Inject into Extensions for downstream use
        parts.extensions.insert(ctx.clone());

        Ok(ctx)
    }
}
