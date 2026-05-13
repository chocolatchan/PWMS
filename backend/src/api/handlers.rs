use axum::{extract::{State, Path}, Json};
use sqlx::PgPool;
use crate::models::dtos::{
    ReceiveInboundReq, SubmitQcReq, CreateOrderReq, DispatchReq, IotTemperatureReq,
    GetPickTasksQuery,
};
use crate::services::inbound_qc_service::InboundQcService;
use crate::services::outbound_service::OutboundService;
use crate::services::order_service::OrderService;
use crate::services::auth_service::{AuthService, Claims};
use crate::error::AppError;
use crate::models::entities::{Product, TempZone};
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

/// GET /api/v2/products — list all products with available stock summary
pub async fn handle_list_products(
    State(pool): State<PgPool>,
    _claims: Claims,
) -> Result<Json<serde_json::Value>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            p.id,
            p.name,
            p.is_lasa,
            p.temp_zone::text as temp_zone,
            COALESCE(SUM(ib.quantity) FILTER (WHERE ib.status = 'AVAILABLE'), 0) as available_qty
        FROM products p
        LEFT JOIN inventory_balances ib ON ib.product_id = p.id
        GROUP BY p.id, p.name, p.is_lasa, p.temp_zone
        ORDER BY p.name
        "#
    )
    .fetch_all(&pool)
    .await?;

    let items: Vec<serde_json::Value> = rows.iter().map(|r| serde_json::json!({
        "id": r.id,
        "name": r.name,
        "is_lasa": r.is_lasa,
        "temp_zone": r.temp_zone,
        "available_qty": r.available_qty,
    })).collect();

    Ok(Json(serde_json::json!(items)))
}

/// GET /api/v2/orders — list recent orders with status and items
pub async fn handle_list_orders(
    State(pool): State<PgPool>,
    _claims: Claims,
) -> Result<Json<serde_json::Value>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            o.id,
            o.customer_name,
            o.created_at,
            c.id as container_id,
            c.current_status::text as container_status
        FROM orders o
        LEFT JOIN containers c ON c.order_id = o.id
        ORDER BY o.created_at DESC
        LIMIT 50
        "#
    )
    .fetch_all(&pool)
    .await?;

    let orders: Vec<serde_json::Value> = rows.iter().map(|r| serde_json::json!({
        "id": r.id,
        "customer_name": r.customer_name,
        "created_at": r.created_at,
        "container_id": r.container_id,
        "status": r.container_status,
    })).collect();

    Ok(Json(serde_json::json!(orders)))
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

#[utoipa::path(
    post,
    path = "/api/v2/inbound/quarantine",
    request_body = crate::models::dtos::MoveToQuarantineReq,
    responses(
        (status = 200, description = "Batch moved to quarantine", body = serde_json::Value),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_move_to_quarantine(
    State(pool): State<PgPool>,
    _claims: Claims,
    Json(req): Json<crate::models::dtos::MoveToQuarantineReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    InboundQcService::move_to_quarantine(&pool, req).await?;
    Ok(Json(serde_json::json!({ "status": "Moved to quarantine" })))
}

#[utoipa::path(
    post,
    path = "/api/v2/inbound/draft/bind",
    request_body = crate::models::dtos::BindDraftReq,
    responses(
        (status = 200, description = "Draft bound", body = serde_json::Value),
        (status = 409, description = "Conflict - Bound to another user"),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_bind_draft(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(req): Json<crate::models::dtos::BindDraftReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    let staff_id = Uuid::parse_str(&claims.sub).map_err(|_| AppError::Unauthorized("Invalid user ID in token".into()))?;
    let (po_details, payload_opt) = InboundQcService::bind_draft(&pool, &req.po_number, staff_id).await?;
    match payload_opt {
        Some(payload) => Ok(Json(serde_json::json!({ "status": "bound", "payload": payload, "po_details": po_details }))),
        None => Err(AppError::Conflict("PO is bound to other staff".into())),
    }
}

#[utoipa::path(
    post,
    path = "/api/v2/inbound/draft/save",
    request_body = crate::models::dtos::SaveDraftReq,
    responses(
        (status = 200, description = "Draft saved", body = serde_json::Value),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_save_draft(
    State(pool): State<PgPool>,
    _claims: Claims,
    Json(req): Json<crate::models::dtos::SaveDraftReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    InboundQcService::save_draft(&pool, &req.po_number, req.payload).await?;
    Ok(Json(serde_json::json!({ "status": "saved" })))
}

#[utoipa::path(
    get,
    path = "/api/v2/inbound/drafts",
    responses(
        (status = 200, description = "List of active drafts", body = Vec<serde_json::Value>),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_list_active_drafts(
    State(pool): State<PgPool>,
    claims: Claims,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    if claims.role != "ADMIN" {
        return Err(AppError::Forbidden("Only admins can list all drafts".into()));
    }

    let drafts = sqlx::query!(
        r#"
        SELECT d.po_number, d.staff_id, u.username as staff_name, d.created_at
        FROM inbound_drafts d
        JOIN users u ON u.id = d.staff_id
        ORDER BY d.created_at DESC
        "#
    )
    .fetch_all(&pool)
    .await?;

    let result = drafts.into_iter().map(|d| {
        serde_json::json!({
            "po_number": d.po_number,
            "staff_id": d.staff_id,
            "staff_name": d.staff_name,
            "created_at": d.created_at
        })
    }).collect();

    Ok(Json(result))
}

#[utoipa::path(
    post,
    path = "/api/v2/inbound/draft/unbind",
    request_body = crate::models::dtos::UnbindDraftReq,
    responses(
        (status = 200, description = "Draft unbound", body = serde_json::Value),
        (status = 403, description = "Forbidden (Requires ADMIN)"),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_unbind_draft(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(req): Json<crate::models::dtos::UnbindDraftReq>,
) -> Result<Json<serde_json::Value>, AppError> {
    // Check if user is admin or the owner of the draft
    let draft = sqlx::query!(
        "SELECT staff_id FROM inbound_drafts WHERE po_number = $1",
        req.po_number
    )
    .fetch_optional(&pool)
    .await?;

    if let Some(d) = draft {
        if claims.role != "ADMIN" && d.staff_id.to_string() != claims.sub {
             return Err(AppError::Forbidden("Only admins or the owner can unbind this PO".into()));
        }
    }

    InboundQcService::unbind_draft(&pool, &req.po_number).await?;
    Ok(Json(serde_json::json!({ "status": "unbound" })))
}

pub async fn handle_get_product_by_barcode(
    State(pool): State<PgPool>,
    Path(barcode): Path<String>,
) -> Result<Json<Product>, AppError> {
    let product = sqlx::query_as!(
        Product,
        r#"SELECT id, name, is_lasa, lasa_group, temp_zone as "temp_zone: TempZone", barcode FROM products WHERE barcode = $1"#,
        barcode
    )
    .fetch_optional(&pool)
    .await?
    .ok_or_else(|| AppError::NotFound(format!("Product with barcode {} not found", barcode)))?;

    Ok(Json(product))
}


#[utoipa::path(
    get,
    path = "/api/v2/inbound/draft/active",
    responses(
        (status = 200, description = "Active draft found", body = serde_json::Value),
        (status = 401, description = "Unauthorized")
    ),
    security(("jwt" = [])),
    tag = "Inbound"
)]
pub async fn handle_get_active_draft(
    State(pool): State<PgPool>,
    claims: Claims,
) -> Result<Json<serde_json::Value>, AppError> {
    let staff_id = Uuid::parse_str(&claims.sub).map_err(|_| AppError::Unauthorized("Invalid user ID in token".into()))?;
    let result_opt = InboundQcService::get_active_draft(&pool, staff_id).await?;
    match result_opt {
        Some((po_details, payload)) => Ok(Json(serde_json::json!({ "status": "active", "payload": payload, "po_details": po_details }))),
        None => Ok(Json(serde_json::json!({ "status": "none" }))),
    }
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

/// GET /api/v2/qc/batch/:batch_number
/// Returns batch details if it exists in QC_PENDING (quarantine) status.
/// Returns 404 if not found, 409 if found but not in quarantine.
pub async fn handle_get_qc_batch(
    State(pool): State<PgPool>,
    _claims: Claims,
    Path(batch_number): Path<String>,
) -> Result<Json<serde_json::Value>, AppError> {
    let row = sqlx::query!(
        r#"
        SELECT 
            ib.id,
            ib.batch_number,
            ib.expiry_date,
            ib.current_status as "status: String",
            p.name as product_name,
            p.id as product_id,
            COALESCE(inv.quantity, ib.actual_qty, 0) as "quantity!: i32"
        FROM inbound_batches ib
        JOIN products p ON p.id = ib.product_id
        LEFT JOIN inventory_balances inv ON inv.inbound_batch_id = ib.id
        WHERE ib.batch_number = $1
        LIMIT 1
        "#,
        batch_number
    )
    .fetch_optional(&pool)
    .await?
    .ok_or_else(|| AppError::NotFound(format!("Batch '{}' not found", batch_number)))?;

    if row.status != "QC_PENDING" {
        return Err(AppError::Conflict(format!(
            "Batch '{}' is not in quarantine (status: {})",
            batch_number, row.status
        )));
    }

    Ok(Json(serde_json::json!({
        "id": row.id,
        "batch_number": row.batch_number,
        "product_id": row.product_id,
        "product_name": row.product_name,
        "expiry_date": row.expiry_date,
        "quantity": row.quantity,
        "status": row.status,
    })))
}
