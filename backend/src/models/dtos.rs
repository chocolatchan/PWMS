use serde::Deserialize;
use uuid::Uuid;
use crate::models::entities::QcDecision;
use utoipa::ToSchema;

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct BatchPayload {
    pub product_id: Uuid,
    pub batch_number: String,
    pub expected_qty: i32,
    pub actual_qty: i32,
}

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct ReceiveInboundReq {
    pub po_number: String,
    pub vehicle_seal_number: Option<String>,
    pub arrival_temperature: Option<f64>,
    pub batches: Vec<BatchPayload>,
}

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct SubmitQcReq {
    pub inbound_batch_id: Uuid,
    pub min_temp: Option<f64>,
    pub max_temp: Option<f64>,
    pub decision: QcDecision,
    pub deviation_report_id: Option<String>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct StartPickTaskReq {
    pub order_id: Uuid,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct OrderItemPayload {
    pub product_id: Uuid,
    pub required_qty: i32,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct CreateOrderReq {
    pub customer_name: String,
    pub items: Vec<OrderItemPayload>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct DispatchReq {
    pub container_id: Uuid,
    pub vehicle_seal_number: String,
    pub dispatch_temperature: Option<f64>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct IotTemperatureReq {
    pub location_code: String,
    pub logger_id: String,
    pub temperature_celsius: f64,
}

#[derive(Debug, serde::Serialize, Clone, ToSchema)]
pub struct OutboxEventMessage {
    pub id: Uuid,
    pub event_type: String,
    pub payload: serde_json::Value,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct GetPickTasksQuery {
    pub container_id: Option<Uuid>,
    pub location_code: Option<String>,
}

#[derive(Debug, serde::Serialize, ToSchema)]
pub struct PickTaskResponse {
    pub id: Uuid,
    pub product_name: String,
    pub required_qty: i32,
    pub picked_qty: i32,
    pub status: String,
    pub location_code: String,
}
