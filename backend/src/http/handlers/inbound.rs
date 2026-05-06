use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use crate::{
    error::AppError,
    services::inbound::{InboundService, InboundReceiptPayload, InboundItemPayload},
    state::SharedState,
    http::middleware::auth::UserContext,
    models::SubmitItemPayload,
};

use validator::Validate;

#[derive(Deserialize)]
pub struct PartnerQuery {
    pub r#type: Option<String>,
}

#[axum::debug_handler]
pub async fn list_partners(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
    axum::extract::Query(query): axum::extract::Query<PartnerQuery>,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let partner_type = query.r#type.unwrap_or_else(|| "supplier".to_string());
    
    let rows = sqlx::query!(
        "SELECT partner_id, name, tax_code FROM partners WHERE partner_type = $1",
        partner_type
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        serde_json::json!({
            "id": r.partner_id,
            "name": r.name,
            "tax_code": r.tax_code
        })
    }).collect();

    Ok(Json(result))
}

#[derive(Deserialize)]
pub struct CreateReceiptHeaderPayload {
    pub receipt_number: String,
    pub supplier_id: i32,
    pub receipt_date: String,
}

#[axum::debug_handler]
pub async fn create_receipt_header(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<CreateReceiptHeaderPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    let receipt_date = chrono::NaiveDate::parse_from_str(&payload.receipt_date, "%Y-%m-%d")
        .map_err(|_| AppError::BadRequest("Invalid receipt_date format. Expected YYYY-MM-DD".to_string()))?;

    let rec = sqlx::query!(
        r#"
        INSERT INTO inbound_receipts (receipt_number, supplier_id, receipt_date, created_by, status)
        VALUES ($1, $2, $3, $4, 'DRAFT')
        RETURNING receipt_id, receipt_number, supplier_id, receipt_date, status, created_at
        "#,
        payload.receipt_number,
        payload.supplier_id,
        receipt_date,
        user_ctx.user_id
    ).fetch_one(&state.db).await?;

    // We need to get supplier name for the DTO
    let supplier_name = sqlx::query_scalar!(
        "SELECT name FROM partners WHERE partner_id = $1",
        rec.supplier_id
    ).fetch_one(&state.db).await.unwrap_or_default();

    Ok(Json(serde_json::json!({
        "id": rec.receipt_id,
        "receipt_number": rec.receipt_number,
        "supplier_id": rec.supplier_id,
        "supplier_name": supplier_name,
        "receipt_date": rec.receipt_date.to_string(),
        "status": rec.status,
        "created_at": rec.created_at.map(|dt| dt.to_string()).unwrap_or_default()
    })))
}
pub async fn list_inbound_receipts(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            r.receipt_id,
            r.receipt_number,
            r.receipt_date,
            r.supplier_id,
            p.name as supplier_name,
            r.status,
            r.created_at
        FROM inbound_receipts r
        JOIN partners p ON r.supplier_id = p.partner_id
        ORDER BY r.created_at DESC
        "#
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        serde_json::json!({
            "id": r.receipt_id,
            "receipt_number": r.receipt_number,
            "supplier_id": r.supplier_id,
            "supplier_name": r.supplier_name,
            "receipt_date": r.receipt_date.to_string(),
            "status": r.status,
            "created_at": r.created_at.map(|dt| dt.to_string()).unwrap_or_default()
        })
    }).collect();

    Ok(Json(result))
}

#[axum::debug_handler]
pub async fn get_receipt_details(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
    axum::extract::Path(id): axum::extract::Path<i32>,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            d.detail_id as id,
            d.product_id,
            p.product_code,
            p.trade_name as product_name,
            d.declared_qty as expected_qty,
            d.actual_qty as received_qty
        FROM inbound_details d
        JOIN products p ON d.product_id = p.product_id
        WHERE d.receipt_id = $1
        "#,
        id
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        serde_json::json!({
            "id": r.id,
            "product_id": r.product_id,
            "product_code": r.product_code,
            "product_name": r.product_name,
            "expected_qty": r.expected_qty,
            "received_qty": r.received_qty.unwrap_or(0)
        })
    }).collect();

    Ok(Json(result))
}



#[axum::debug_handler]
pub async fn submit_inbound_item(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<SubmitItemPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    payload.validate()?;
    
    let tote_upper = payload.tote_code.to_uppercase();

    let (expected_prefix, inv_status) = InboundService::submit_inbound_item(
        &state.db,
        user_ctx.user_id,
        payload
    ).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "tote_prefix": expected_prefix,
        "inventory_status": inv_status,
        "message": format!("Item registered → Tote {} → Status {}", tote_upper, inv_status)
    })))
}


#[axum::debug_handler]
pub async fn finish_receipt(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
    axum::extract::Path(id): axum::extract::Path<i32>,
) -> Result<Json<serde_json::Value>, AppError> {
    sqlx::query!(
        "UPDATE inbound_receipts SET status = 'RECEIVED' WHERE receipt_id = $1",
        id
    ).execute(&state.db).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "message": "Receipt marked as received"
    })))
}

#[derive(Deserialize, Serialize, Validate)]
pub struct InboundItemRequest {
    pub product_id: i32,
    pub batch_id: i32,
    #[validate(range(min = 1, message = "Declared quantity must be at least 1"))]
    pub declared_qty: i32,
}

#[derive(Deserialize, Serialize, Validate)]
pub struct CreateInboundPayload {
    #[validate(length(min = 1, message = "Receipt number cannot be empty"))]
    pub receipt_number: String,
    pub supplier_id: i32,
    pub receipt_date: String, // Expecting YYYY-MM-DD
    pub invoice_no: Option<String>,
    pub invoice_date: Option<String>,
    pub received_date: Option<String>,
    pub note: Option<String>,
    pub status: Option<String>, // Default to 'PENDING_QC' if not provided
    #[validate(length(min = 1, message = "At least one item is required"))]
    pub items: Vec<InboundItemRequest>,
}

#[axum::debug_handler]
pub async fn create_inbound(
    State(state): State<SharedState>,
    user_ctx: UserContext,
    Json(payload): Json<CreateInboundPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    payload.validate().map_err(|e| AppError::BadRequest(e.to_string()))?;
    
    // Convert string dates to NaiveDate
    let receipt_date = chrono::NaiveDate::parse_from_str(&payload.receipt_date, "%Y-%m-%d")
        .map_err(|_| AppError::BadRequest("Invalid receipt_date format. Expected YYYY-MM-DD".to_string()))?;

    let invoice_date = match &payload.invoice_date {
        Some(d) => Some(chrono::NaiveDate::parse_from_str(d, "%Y-%m-%d")
            .map_err(|_| AppError::BadRequest("Invalid invoice_date format".to_string()))?),
        None => None,
    };

    let received_date = match &payload.received_date {
        Some(d) => Some(chrono::NaiveDate::parse_from_str(d, "%Y-%m-%d")
            .map_err(|_| AppError::BadRequest("Invalid received_date format".to_string()))?),
        None => None,
    };

    let items = payload.items.into_iter().map(|i| InboundItemPayload {
        product_id: i.product_id,
        batch_id: i.batch_id,
        declared_qty: i.declared_qty,
    }).collect();

    let req = InboundReceiptPayload {
        receipt_number: payload.receipt_number,
        supplier_id: payload.supplier_id,
        receipt_date,
        invoice_no: payload.invoice_no,
        invoice_date,
        received_date,
        note: payload.note,
        status: payload.status.unwrap_or_else(|| "PENDING_QC".to_string()),
        items,
    };

    let receipt_id = InboundService::create_inbound_receipt(&state.db, &state.ws_sender, user_ctx.user_id, req).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "message": "Inbound receipt created and goods placed in quarantine",
        "receipt_id": receipt_id
    })))
}
