use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Product {
    pub product_id: i32,
    pub product_code: String,
    pub trade_name: String,
    pub base_unit: String,
    pub storage_condition: String,
    pub is_toxic: bool,
    pub is_lasa: bool,
}
