use axum::{extract::State, Json};
use serde::Deserialize;
use crate::{
    error::AppError,
    services::inventory::{InventoryService, OutboundRequest},
    state::SharedState,
    http::middleware::auth::UserContext,
};

use validator::Validate;

#[derive(Deserialize, Validate)]
pub struct CreateOutboundPayload {
    pub product_id: i32,
    #[validate(range(min = 1, message = "Target quantity must be at least 1"))]
    pub target_qty: i32,
    pub to_location_id: Option<i32>,
    #[validate(length(min = 1))]
    pub task_type: String,
}

#[axum::debug_handler]
pub async fn create_outbound(
    State(state): State<SharedState>,
    user_ctx: UserContext, // Extracted by auth middleware
    Json(payload): Json<CreateOutboundPayload>,
) -> Result<Json<serde_json::Value>, AppError> {
    payload.validate().map_err(|e| AppError::BadRequest(e.to_string()))?;
    
    // In a real app, you would validate the preset here or in a guard middleware.
    // e.g., if !user_ctx.presets.contains(&"Dispatch Specialist".to_string()) { return Err(...) }

    let req = OutboundRequest {
        product_id: payload.product_id,
        target_qty: payload.target_qty,
        to_location_id: payload.to_location_id,
        task_type: payload.task_type,
    };

    InventoryService::execute_outbound(&state.db, user_ctx.user_id, req).await?;

    Ok(Json(serde_json::json!({
        "status": "success",
        "message": "Outbound task executed successfully"
    })))
}

#[axum::debug_handler]
pub async fn list_inventory(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            b.balance_id,
            p.trade_name,
            p.product_code,
            batch.batch_number,
            b.available_qty,
            b.status,
            b.expiration_date,
            l.location_code,
            l.zone_type
        FROM inventory_balances b
        JOIN products p ON b.product_id = p.product_id
        JOIN product_batches batch ON b.batch_id = batch.batch_id
        JOIN locations l ON b.location_id = l.location_id
        ORDER BY b.expiration_date ASC
        LIMIT 100
        "#
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        serde_json::json!({
            "id": r.balance_id,
            "product": r.trade_name,
            "sku": r.product_code,
            "batch": r.batch_number,
            "quantity": r.available_qty,
            "status": r.status,
            "expiry": r.expiration_date,
            "location": r.location_code,
            "zone": r.zone_type
        })
    }).collect();

    Ok(Json(result))
}

#[axum::debug_handler]
pub async fn get_batch_traceability(
    State(state): State<SharedState>,
    axum::extract::Path(batch_number): axum::extract::Path<String>,
    _user_ctx: UserContext,
) -> Result<Json<Vec<serde_json::Value>>, AppError> {
    let rows = sqlx::query!(
        r#"
        SELECT 
            t.transaction_type,
            t.quantity_change,
            t.created_at,
            u.username,
            l_from.location_code as from_loc,
            l_to.location_code as to_loc,
            p.trade_name
        FROM inventory_transactions t
        JOIN product_batches pb ON t.batch_id = pb.batch_id
        JOIN products p ON pb.product_id = p.product_id
        JOIN users u ON t.executor_id = u.user_id
        LEFT JOIN locations l_from ON t.from_location_id = l_from.location_id
        LEFT JOIN locations l_to ON t.to_location_id = l_to.location_id
        WHERE pb.batch_number = $1
        ORDER BY t.created_at DESC
        "#,
        batch_number
    ).fetch_all(&state.db).await?;

    let result = rows.into_iter().map(|r| {
        let msg = match r.transaction_type.as_str() {
            "INBOUND" => format!("Initial receipt of {}", r.trade_name),
            "INBOUND_QC_PASS" => format!("QC Passed - Goods released to stock"),
            "INBOUND_QC_FAIL" => format!("QC Failed - Goods quarantined for rejection"),
            "RELOCATE" => format!("Internal transfer"),
            "OUTBOUND" => format!("Goods dispatched"),
            _ => format!("Inventory update")
        };

        serde_json::json!({
            "type": r.transaction_type,
            "qty": r.quantity_change,
            "date": r.created_at,
            "user": r.username,
            "from": r.from_loc,
            "to": r.to_loc,
            "message": msg
        })
    }).collect();

    Ok(Json(result))
}
