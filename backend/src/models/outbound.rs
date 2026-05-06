use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc, NaiveDate};

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Tote {
    pub tote_id: i32,
    pub tote_code: String,
    pub color: String,
    pub status: String,
    pub current_user_id: Option<i32>,
    pub current_location_id: Option<i32>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct SalesOrder {
    pub order_id: i32,
    pub order_code: String,
    pub partner_id: i32,
    pub status: String,
    pub order_date: NaiveDate,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
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

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
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
