use serde::{Deserialize, Serialize};
use uuid::Uuid;
use crate::models::entities::QcDecision;
use utoipa::ToSchema;

#[derive(Debug, Serialize, Deserialize, Clone, ToSchema)]
pub struct PoItemDto {
    pub product_id: Uuid,
    pub product_name: String,
    pub expected_qty: i32,
    pub received_qty: i32,
}

#[derive(Debug, Serialize, Deserialize, Clone, ToSchema)]
pub struct PoDetailsResponse {
    pub po_number: String,
    pub vendor_name: Option<String>,
    pub status: String,
    pub items: Vec<PoItemDto>,
}

use chrono::NaiveDate;

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct BatchPayload {
    pub product_id: Uuid,
    pub batch_number: String,
    pub expiry_date: NaiveDate,
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
pub struct MoveToQuarantineReq {
    pub batch_number: String,
    pub location_code: String,
}

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct BindDraftReq {
    pub po_number: String,
}

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct SaveDraftReq {
    pub po_number: String,
    pub payload: serde_json::Value,
}

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct UnbindDraftReq {
    pub po_number: String,
}

#[derive(Debug, Deserialize, Clone, ToSchema)]
pub struct SubmitQcReq {
    pub batch_number: String,
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

#[derive(Debug, Deserialize, ToSchema)]
pub struct PackContainerReq {
    pub container_id: Uuid,
    pub packer_id: String,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct RunnerMoveReq {
    pub id: Uuid, // container_id or batch_id
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

#[derive(Debug, Deserialize, ToSchema)]
pub struct ContainerStatusQuery {
    pub status: Option<String>,
}

#[derive(Debug, serde::Serialize, ToSchema)]
pub struct PickTaskResponse {
    pub id: Uuid,
    pub container_id: Uuid,
    pub product_name: String,
    pub batch_number: Option<String>,
    pub required_qty: i32,
    pub picked_qty: i32,
    pub status: String,
    pub location_code: String,
}

#[derive(Debug, Serialize, ToSchema)]
pub struct UserResponse {
    pub id: uuid::Uuid,
    pub username: String,
    pub role: String,
    pub created_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct CreateUserReq {
    pub username: String,
    pub role: String,
    pub password: String,
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct UpdateUserRoleReq {
    pub role: String,
}
