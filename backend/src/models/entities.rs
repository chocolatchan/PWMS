use serde::{Deserialize, Serialize};
use sqlx::{FromRow, Type};
use uuid::Uuid;
use chrono::{DateTime, Utc, NaiveDate};

// --- ENUMS ---

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "inbound_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum InboundStatus {
    Arrived,
    InQuarantine,
    QcInProgress,
    Completed,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "batch_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum BatchStatus {
    Received,
    QcPending,
    QcDone,
    QcRejected,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "temp_zone", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum TempZone {
    Ambient,
    Chilled,
    Cold,
}

use utoipa::ToSchema;

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy, ToSchema)]
#[sqlx(type_name = "qc_decision", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum QcDecision {
    Approved,
    Rejected,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "location_zone_type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum LocationZoneType {
    Quarantine,
    AcceptedInv,
    RejectedInv,
    Packing,
    OutboundLane,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "inventory_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum InventoryStatus {
    Quarantine,
    Available,
    Reserved,
    Rejected,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "container_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ContainerStatus {
    Picking,
    AtInvGate,
    InTransit,
    AtPacking,
    Packed,
    Dispatched,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "task_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum TaskStatus {
    Pending,
    InProgress,
    Completed,
    Failed,
}

#[derive(Debug, Serialize, Deserialize, Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "trip_type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum TripType {
    Internal,
    Outbound,
    External,
}

// --- ENTITIES ---

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub role: String,
    pub created_at: DateTime<Utc>,
    pub password_hash: String,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Product {
    pub id: Uuid,
    pub name: String,
    pub is_lasa: bool,
    pub lasa_group: Option<String>,
    pub temp_zone: TempZone,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Location {
    pub id: Uuid,
    pub zone_code: String,
    pub zone_type: LocationZoneType,
    pub is_full: bool,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Order {
    pub id: Uuid,
    pub customer_name: String,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct InboundShipment {
    pub id: Uuid,
    pub po_number: String,
    pub vehicle_seal_number: Option<String>,
    pub arrival_temperature: Option<f64>,
    pub data_logger_id: Option<String>,
    pub status: InboundStatus,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct InboundBatch {
    pub id: Uuid,
    pub inbound_shipment_id: Uuid,
    pub current_status: BatchStatus,
    pub product_id: Option<Uuid>,
    pub batch_number: Option<String>,
    pub expected_qty: Option<i32>,
    pub actual_qty: Option<i32>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct QcInspection {
    pub id: Uuid,
    pub inbound_batch_id: Uuid,
    pub qa_staff_id: Uuid,
    pub min_temp: Option<f64>,
    pub max_temp: Option<f64>,
    pub deviation_report_id: Option<String>,
    pub decision: QcDecision,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct InventoryBalance {
    pub id: Uuid,
    pub product_id: Uuid,
    pub location_id: Uuid,
    pub inbound_batch_id: Uuid,
    pub batch_number: String,
    pub expiry_date: NaiveDate,
    pub quantity: i32,
    pub status: InventoryStatus,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct OutboundShipment {
    pub id: Uuid,
    pub order_id: Uuid,
    pub vehicle_seal_number: Option<String>,
    pub dispatch_temperature: Option<f64>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Container {
    pub id: Uuid,
    pub order_id: Uuid,
    pub current_status: ContainerStatus,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct PickTask {
    pub id: Uuid,
    pub container_id: Uuid,
    pub product_id: Option<Uuid>,
    pub inventory_balance_id: Option<Uuid>,
    pub batch_number: String,
    pub required_qty: i32,
    pub picked_qty: i32,
    pub picker_id: Option<Uuid>,
    pub status: TaskStatus,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct RunnerTrip {
    pub id: Uuid,
    pub runner_id: Uuid,
    pub trip_type: TripType,
    pub status: TaskStatus,
    pub created_at: DateTime<Utc>,
    pub completed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct PackTask {
    pub id: Uuid,
    pub container_id: Uuid,
    pub packer_id: Option<Uuid>,
    pub status: TaskStatus,
    pub packed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct OutboxEvent {
    pub id: Uuid,
    pub event_type: String,
    pub payload: serde_json::Value,
    pub processed: bool,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct OrderItem {
    pub id: Uuid,
    pub order_id: Uuid,
    pub product_id: Uuid,
    pub required_qty: i32,
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct TemperatureLog {
    pub id: Uuid,
    pub location_id: Uuid,        // Bổ sung
    pub logger_id: String,
    pub recorded_at: DateTime<Utc>,
    pub temperature_celsius: f64, // Sửa tên cho khớp DB
    pub is_alert: bool,           // Bổ sung
    pub notes: Option<String>,    // Bổ sung
}

#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct InventoryAdjustment {
    pub id: Uuid,
    pub inventory_balance_id: Uuid,
    pub adjusted_by: Uuid,
    pub approved_by: Option<Uuid>,      // Bổ sung
    pub previous_quantity: i32,         // Sửa tên từ old_quantity
    pub new_quantity: i32,
    pub delta: i32,                     // Bổ sung
    pub reason: String,
    pub reference_doc_number: Option<String>, // Bổ sung
    pub created_at: DateTime<Utc>,
    pub approved_at: Option<DateTime<Utc>>,   // Bổ sung
}
