use axum::{
    extract::Request,
    middleware::Next,
    response::Response,
    http::HeaderMap,
};
use crate::error::AppError;

pub async fn api_key_middleware(
    headers: HeaderMap,
    mut req: Request,
    next: Next,
) -> Result<Response, AppError> {
    let api_key = headers
        .get("X-API-Key")
        .and_then(|v| v.to_str().ok())
        .ok_or_else(|| AppError::Unauthorized("Missing X-API-Key header".into()))?;

    let expected_key = std::env::var("IOT_API_KEY")
        .unwrap_or_else(|_| "your_static_key_for_iot_devices".into());

    if api_key != expected_key {
        return Err(AppError::Unauthorized("Invalid API key".into()));
    }

    // Thêm metadata nếu cần (ví dụ gắn quyền IoT vào extension)
    req.extensions_mut().insert("iot_authenticated");
    Ok(next.run(req).await)
}
