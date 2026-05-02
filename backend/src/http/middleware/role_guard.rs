use axum::{
    body::Body,
    http::Request,
    middleware::Next,
    response::Response,
};
use crate::error::AppError;
use super::auth::UserContext;

pub async fn require_preset(
    req: Request<Body>,
    next: Next,
    required_preset: &'static str,
) -> Result<Response, AppError> {
    let user_ctx = req.extensions().get::<UserContext>()
        .ok_or(AppError::Unauthorized)?;

    if !user_ctx.presets.iter().any(|p| p == required_preset) {
        return Err(AppError::Forbidden(format!(
            "This action requires the '{}' preset",
            required_preset
        )));
    }

    Ok(next.run(req).await)
}
