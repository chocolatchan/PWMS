use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use chrono::{DateTime, Utc, NaiveDate};

#[derive(Debug, Serialize, Deserialize, sqlx::Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "VARCHAR", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum LockState {
    Available,
    LockedByTask,
    LockedTempBreach,
    Maintenance,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct Product {
    pub product_id: i32,
    pub product_code: String,
    pub trade_name: String,
    pub base_unit: String,
    pub storage_condition: String,
    pub is_toxic: bool,
    pub is_lasa: bool,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct Location {
    pub location_id: i32,
    pub location_code: String,
    pub location_name: String,
    pub zone_type: String,
    pub lock_state: LockState,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct Tote {
    pub tote_id: i32,
    pub tote_code: String,
    pub status: String,
    pub current_user_id: Option<i32>,
    pub current_location_id: Option<i32>,
    pub updated_at: DateTime<Utc>,
}

pub enum ToteCategory {
    Standard,
    Quarantine,
    Toxic,
    Return,
    Rejected,
}

impl ToteCategory {
    pub fn from_code(code: &str) -> Result<Self, crate::error::AppError> {
        let code = code.to_uppercase();
        if code.starts_with("STD-") { Ok(ToteCategory::Standard) }
        else if code.starts_with("QRN-") { Ok(ToteCategory::Quarantine) }
        else if code.starts_with("TOX-") { Ok(ToteCategory::Toxic) }
        else if code.starts_with("RET-") { Ok(ToteCategory::Return) }
        else if code.starts_with("REJ-") { Ok(ToteCategory::Rejected) }
        else { Err(crate::error::AppError::BadRequest("Định dạng mã Rổ không hợp lệ (Phải là STD, QRN, TOX, RET, REJ)".to_string())) }
    }
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct SalesOrder {
    pub order_id: i32,
    pub order_code: String,
    pub partner_id: i32,
    pub status: String,
    pub order_date: NaiveDate,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct SalesOrderLine {
    pub line_id: i32,
    pub order_id: i32,
    pub product_id: i32,
    pub requested_qty: i32,
    pub allocated_qty: i32,
    pub picked_qty: i32,
    pub is_toxic_line: bool,
    pub is_lasa_line: bool,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct PickingTask {
    pub task_id: i32,
    pub order_id: i32,
    pub tote_id: Option<i32>,
    pub assigned_user_id: Option<i32>,
    pub zone_type: String,
    pub status: String,
    pub started_at: Option<DateTime<Utc>>,
    pub completed_at: Option<DateTime<Utc>>,
}

// --- PHASE 5: PACKING & DISPATCH ---

#[derive(Debug, Serialize, Deserialize, sqlx::Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "VARCHAR", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum BoxStatus {
    Packed,
    Loaded,
    Delivered,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "VARCHAR", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ManifestStatus {
    Dispatched,
    Completed,
    Cancelled,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct PackedBox {
    pub box_id: i32,
    pub box_code: String,
    pub order_id: i32,
    pub packed_by: Option<i32>,
    pub seal_number: Option<String>,
    pub is_toxic_box: bool,
    pub weight_kg: Option<bigdecimal::BigDecimal>,
    pub status: BoxStatus,
    pub packed_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct BoxItem {
    pub item_id: i32,
    pub box_id: i32,
    pub product_id: i32,
    pub batch_id: i32,
    pub packed_qty: i32,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct DispatchManifest {
    pub manifest_id: i32,
    pub manifest_code: String,
    pub vehicle_plate: String,
    pub driver_name: String,
    pub driver_phone: Option<String>,
    pub temp_before_departure: Option<bigdecimal::BigDecimal>,
    pub status: ManifestStatus,
    pub dispatched_by: Option<i32>,
    pub dispatched_at: DateTime<Utc>,
}
