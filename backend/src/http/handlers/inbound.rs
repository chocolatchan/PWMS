use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use crate::{
    error::AppError,
    services::inbound::{InboundService, InboundReceiptPayload, InboundItemPayload},
    state::SharedState,
    http::middleware::auth::UserContext,
};

use validator::Validate;

#[axum::debug_handler]
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
            p.name as supplier_name,
            r.status
        FROM inbound_receipts r
        JOIN partners p ON r.supplier_id = p.partner_id
        ORDER BY r.created_at DESC
        "#
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        serde_json::json!({
            "id": r.receipt_id,
            "number": r.receipt_number,
            "date": r.receipt_date,
            "supplier": r.supplier_name,
            "status": r.status
        })
    }).collect();

    Ok(Json(result))
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
