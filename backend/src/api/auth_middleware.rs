use axum::{
    extract::{Request, FromRequestParts},
    middleware::Next,
    response::Response,
    http::HeaderMap,
    async_trait,
};
use crate::services::auth_service::{AuthService, Claims};
use crate::error::AppError;

pub async fn auth_middleware(headers: HeaderMap, mut req: Request, next: Next) -> Result<Response, AppError> {
    let auth_header = headers
        .get("Authorization")
        .and_then(|h| h.to_str().ok())
        .ok_or_else(|| AppError::Unauthorized("Missing Authorization header".into()))?;

    if !auth_header.starts_with("Bearer ") {
        return Err(AppError::Unauthorized("Invalid auth scheme".into()));
    }

    let token = &auth_header[7..];
    let claims = AuthService::verify_token(token)?;

    // Insert claims into request extensions for later use
    req.extensions_mut().insert(claims);
    Ok(next.run(req).await)
}

#[async_trait]
impl<S> FromRequestParts<S> for Claims
where
    S: Send + Sync,
{
    type Rejection = AppError;

    async fn from_request_parts(parts: &mut axum::http::request::Parts, _state: &S) -> Result<Self, Self::Rejection> {
        parts.extensions.get::<Claims>().cloned().ok_or(AppError::Unauthorized("Missing claims".into()))
    }
}

