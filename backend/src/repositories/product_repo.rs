use sqlx::PgPool;
use crate::models::entities::Product;
use crate::models::dtos::CreateProductRequest;
use crate::error::AppError;

pub struct ProductRepository;

impl ProductRepository {
    pub async fn create_product(pool: &PgPool, p: CreateProductRequest) -> Result<Product, AppError> {
        let product = sqlx::query_as!(
            Product,
            r#"
            INSERT INTO products (product_code, trade_name, base_unit, storage_condition, is_toxic, is_lasa)
            VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING 
                product_id as "product_id!", 
                product_code as "product_code!", 
                trade_name as "trade_name!", 
                base_unit as "base_unit!", 
                storage_condition as "storage_condition!", 
                is_toxic as "is_toxic!", 
                is_lasa as "is_lasa!"
            "#,
            p.product_code,
            p.trade_name,
            p.base_unit,
            p.storage_condition,
            p.is_toxic,
            p.is_lasa
        )
        .fetch_one(pool)
        .await?;

        Ok(product)
    }

    pub async fn find_by_code(pool: &PgPool, code: &str) -> Result<Option<Product>, AppError> {
        let product = sqlx::query_as!(
            Product,
            r#"
            SELECT 
                product_id as "product_id!", 
                product_code as "product_code!", 
                trade_name as "trade_name!", 
                base_unit as "base_unit!", 
                storage_condition as "storage_condition!", 
                is_toxic as "is_toxic!", 
                is_lasa as "is_lasa!"
            FROM products
            WHERE product_code = $1
            "#,
            code
        )
        .fetch_optional(pool)
        .await?;

        Ok(product)
    }
}
