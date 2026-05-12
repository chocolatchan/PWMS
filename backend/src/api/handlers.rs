use axum::{extract::State, Json};
use sqlx::PgPool;
use crate::models::dtos::{
    ReceiveInboundReq, SubmitQcReq, CreateOrderReq, DispatchReq, IotTemperatureReq,
    GetPickTasksQuery,
};
use crate::services::inbound_qc_service::InboundQcService;
use crate::services::outbound_service::OutboundService;
use crate::services::order_service::OrderService;
use crate::error::AppError;
use crate::services::auth_service::{AuthService, Claims};
use uuid::Uuid;

use utoipa::ToSchema;

#[derive(serde::Deserialize, ToSchema)]
pub struct LoginReq {
    pub username: String,
    pub password: String,
}

#[utoipa::path(
    post,
    path = "/api/v2/login",
    request_body = LoginReq,
    responses(
        (status = 200, description = "Login successful", body = serde_json::Value),
        (status = 401, description = "Invalid credentials")
    ),
    tag = "Auth"
)]
pub async fn handle_login(
    State(pool): State<PgPool>,
    Json(req): Json<LoginReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    let token = AuthService::login(&pool, &req.username, &req.password).await?;
    Ok(Json(serde_json::json!({ "token": token })))
}

#[utoipa::path(
    post,
    path = "/api/v2/orders",
    request_body = CreateOrderReq,
    responses(
        (status = 200, description = "Order created and allocated", body = serde_json::Value),
        (status = 401, description = "Unauthorized"),
        (status = 422, description = "Insufficient stock")
    ),
    security(("jwt" = [])),
    tag = "Outbound"
)]
pub async fn handle_create_order(
    State(pool): State<PgPool>,
    _claims: Claims,
    Json(req): Json<CreateOrderReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    // Audit log could use claims.sub here
    let order_id = OrderService::create_and_allocate(&pool, req).await?;
    Ok(Json(serde_json::json!({ 
        "status": "Order created and allocated successfully", 
        "order_id": order_id 
    })))
}

#[utoipa::path(
    post,
    path = "/api/v2/inbound",
    request_body = ReceiveInboundReq,
    responses(
        (status = 200, description = "Inbound shipment received", body = serde_json::Value),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_receive_inbound(
    State(pool): State<PgPool>,
    _claims: Claims,
    Json(req): Json<ReceiveInboundReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    InboundQcService::process_inbound(&pool, req).await?;
    Ok(Json(serde_json::json!({ "status": "Inbound received" })))
}

#[utoipa::path(
    post,
    path = "/api/v2/qc",
    request_body = SubmitQcReq,
    responses(
        (status = 200, description = "QC result submitted", body = serde_json::Value),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_submit_qc(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(req): Json<SubmitQcReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    let qa_staff_id = Uuid::parse_str(&claims.sub).map_err(|_| AppError::Unauthorized("Invalid user ID in token".into()))?;
    InboundQcService::process_qc(&pool, req, qa_staff_id).await?;
    Ok(Json(serde_json::json!({ "status": "QC processed" })))
}

#[derive(serde::Deserialize, ToSchema)]
pub struct ScanPickReq {
    pub task_id: Uuid,
    pub barcode: String,
    pub input_qty: i32,
}

#[utoipa::path(
    post,
    path = "/api/v2/outbound/pick",
    request_body = ScanPickReq,
    responses(
        (status = 200, description = "Item picked successfully", body = serde_json::Value),
        (status = 400, description = "Bad request (e.g. LASA violation)"),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Outbound"
)]
pub async fn handle_scan_pick(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(req): Json<ScanPickReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    let picker_id = Uuid::parse_str(&claims.sub).map_err(|_| AppError::Unauthorized("Invalid user ID in token".into()))?;
    OutboundService::scan_pick_item(&pool, req.task_id, req.barcode, req.input_qty, picker_id).await?;
    Ok(Json(serde_json::json!({ "status": "Item picked" })))
}

#[derive(serde::Deserialize, ToSchema)]
pub struct PackContainerReq {
    pub container_id: Uuid,
}

#[utoipa::path(
    post,
    path = "/api/v2/outbound/pack",
    request_body = PackContainerReq,
    responses(
        (status = 200, description = "Container packed successfully", body = serde_json::Value),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Outbound"
)]
pub async fn handle_pack_container(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(req): Json<PackContainerReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    let packer_id = Uuid::parse_str(&claims.sub).map_err(|_| AppError::Unauthorized("Invalid user ID in token".into()))?;
    OutboundService::pack_container(&pool, req.container_id, packer_id).await?;
    Ok(Json(serde_json::json!({ "status": "Container packed" })))
}

#[utoipa::path(
    post,
    path = "/api/v2/outbound/dispatch",
    request_body = DispatchReq,
    responses(
        (status = 200, description = "Container dispatched successfully", body = serde_json::Value),
        (status = 401, description = "Unauthorized"),
        (status = 403, description = "Forbidden (Requires ADMIN or DISPATCHER role)")
    ),
    security(("jwt" = [])),
    tag = "Outbound"
)]
pub async fn handle_dispatch(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(req): Json<DispatchReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    if claims.role != "ADMIN" && claims.role != "DISPATCHER" {
        return Err(AppError::Forbidden("Requires ADMIN or DISPATCHER role".into()));
    }
    OutboundService::dispatch_container(&pool, &req).await?;
    Ok(Json(serde_json::json!({ "status": "dispatched" })))
}

use crate::services::iot_service::IotService;

#[utoipa::path(
    post,
    path = "/api/v2/iot/temperature",
    request_body = IotTemperatureReq,
    responses(
        (status = 200, description = "Temperature logged successfully", body = serde_json::Value),
        (status = 401, description = "Unauthorized (Invalid or missing API Key)")
    ),
    security(("api_key" = [])),
    tag = "IoT"
)]
pub async fn handle_iot_temperature(
    State(pool): State<PgPool>,
    Json(req): Json<IotTemperatureReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    IotService::log_temperature(
        &pool,
        &req.location_code,
        &req.logger_id,
        req.temperature_celsius,
    )
    .await?;
    Ok(Json(serde_json::json!({ "status": "ok" })))
}

#[utoipa::path(
    get,
    path = "/api/v2/outbound/pick-tasks",
    params(
        ("container_id" = Option<Uuid>, Query, description = "Filter by container ID"),
        ("location_code" = Option<String>, Query, description = "Filter by location code")
    ),
    responses(
        (status = 200, description = "List of pick tasks", body = [crate::models::dtos::PickTaskResponse]),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Outbound"
)]
pub async fn handle_get_pick_tasks(
    State(pool): State<PgPool>,
    _claims: Claims,
    axum::extract::Query(query): axum::extract::Query<GetPickTasksQuery>,
) -> Result<Json<Vec<crate::models::dtos::PickTaskResponse>>, AppError> {
    let tasks = OutboundService::get_pick_tasks(&pool, query.container_id, query.location_code).await?;
    Ok(Json(tasks))
}



