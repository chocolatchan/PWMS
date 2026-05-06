use serde::{Deserialize, Serialize};
use validator::Validate;


#[derive(Debug, Deserialize, Serialize)]
pub struct CreateProductRequest {
    pub product_code: String,
    pub trade_name: String,
    pub base_unit: String,
    pub storage_condition: String,
    #[serde(default)]
    pub is_toxic: bool,
    #[serde(default)]
    pub is_lasa: bool,
}

#[derive(Debug, Serialize)]
pub struct ProductResponse {
    pub product_id: i32,
    pub product_code: String,
    pub trade_name: String,
    pub is_toxic: bool,
    pub is_lasa: bool,
}

#[derive(Debug, Serialize)]
pub struct ScreenOrderResponse {
    pub message: String,
    pub created_task_ids: Vec<i32>,
}

#[derive(Debug, Deserialize)]
pub struct StartTaskRequest {
    pub task_id: i32,
    pub tote_code: String,
}

#[derive(Debug, Deserialize)]
pub struct SubmitPickRequest {
    pub task_id: i32,
    pub order_id: i32,
    pub product_id: i32,
    pub batch_id: i32,
    pub location_id: i32,
    pub qty: i32,
}

// --- PHASE 5 DTOs ---

#[derive(Debug, Deserialize, Serialize)]
pub struct BoxItemDto {
    pub product_id: i32,
    pub batch_id: i32,
    pub packed_qty: i32,
}

#[derive(Debug, Deserialize)]
pub struct PackBoxRequest {
    pub order_id: i32,
    pub box_code: String,
    pub seal_number: Option<String>,
    pub is_toxic_box: bool,
    pub weight_kg: Option<f64>,
    pub items: Vec<BoxItemDto>,
}

#[derive(Debug, Deserialize)]
pub struct CreateManifestRequest {
    pub manifest_code: String,
    pub vehicle_plate: String,
    pub driver_name: String,
    pub driver_phone: Option<String>,
    pub temp_before_departure: Option<f64>,
    pub box_ids: Vec<i32>,
}

#[derive(Debug, Deserialize, Serialize, Validate)]
pub struct SubmitItemPayload {
    pub receipt_id: i32,
    pub product_id: i32,
    pub batch_number: String,
    pub manufacture_date: String,
    pub expiry_date: String,
    #[validate(range(min = 1))]
    pub declared_qty: i32,
    #[validate(range(min = 1))]
    pub expected_qty: i32,
    pub uom_rate: f64,
    pub tote_code: String,
    pub is_coa_available: bool,
    pub is_return: bool,
    pub gate_note: Option<String>,
    pub reason_code: Option<String>,
    pub quarantine_location_id: Option<i32>,
}

