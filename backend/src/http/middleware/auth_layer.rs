use axum::{
    body::Body,
    http::Request,
    middleware::Next,
    response::Response,
    extract::State,
};
use crate::state::SharedState;
use crate::http::middleware::auth::UserContext;
use crate::error::AppError;
use axum::extract::FromRequestParts;

pub async fn auth_middleware(
    State(state): State<SharedState>,
    req: Request<Body>,
    next: Next,
) -> Result<Response, AppError> {
    // We can reuse the UserContext extractor logic here
    let (mut parts, body) = req.into_parts();
    
    // Call the extractor
    let _user_ctx = UserContext::from_request_parts(&mut parts, &state).await?;
    
    // The extractor ALREADY inserted it into extensions in our updated version!
    // So we just rebuild the request and continue.
    let req = Request::from_parts(parts, body);
    
    Ok(next.run(req).await)
}
