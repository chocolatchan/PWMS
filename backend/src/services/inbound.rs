use crate::error::AppError;
use sqlx::{PgPool, Postgres, Transaction, Row};
use shared::database::inject_audit_context;

pub struct InboundItemPayload {
    pub product_id: i32,
    pub batch_id: i32,
    pub declared_qty: i32,
}

pub struct InboundReceiptPayload {
    pub receipt_number: String,
    pub supplier_id: i32,
    pub receipt_date: chrono::NaiveDate,
    pub invoice_no: Option<String>,
    pub invoice_date: Option<chrono::NaiveDate>,
    pub received_date: Option<chrono::NaiveDate>,
    pub note: Option<String>,
    pub status: String, // 'DRAFT' or 'PENDING_QC'
    pub items: Vec<InboundItemPayload>,
}

pub struct InboundService;

impl InboundService {
    /// Automatically determines the appropriate quarantine location based on product storage conditions.
    async fn determine_quarantine_location(tx: &mut Transaction<'_, Postgres>, product_id: i32) -> Result<i32, AppError> {
        // 1. Get product storage condition
        let product = sqlx::query(
            "SELECT storage_condition FROM products WHERE product_id = $1"
        )
        .bind(product_id)
        .fetch_one(&mut **tx)
        .await
        .map_err(|_| AppError::NotFound("Product not found".to_string()))?;

        let condition: Option<String> = product.try_get("storage_condition")?;
        
        // Map condition to zone_type
        let zone_type = match condition.as_deref() {
            Some(c) if c.to_lowercase().contains("cold") || c.to_lowercase().contains("2-8") => "Cold",
            Some(c) if c.to_lowercase().contains("controlled") => "Controlled",
            _ => "Quarantine", // Default to normal quarantine
        };

        // 2. Find an available location of that zone_type
        let location = sqlx::query(
            "SELECT location_id FROM locations WHERE zone_type = $1 LIMIT 1"
        )
        .bind(zone_type)
        .fetch_optional(&mut **tx)
        .await?;

        match location {
            Some(loc) => Ok(loc.try_get("location_id")?),
            None => {
                // Fallback to any generic Quarantine location if specific one isn't found
                let fallback = sqlx::query(
                    "SELECT location_id FROM locations WHERE zone_type = 'Quarantine' LIMIT 1"
                )
                .fetch_optional(&mut **tx)
                .await?;
                
                match fallback {
                    Some(loc) => Ok(loc.try_get("location_id")?),
                    None => Err(AppError::Internal("No quarantine locations configured in the warehouse".to_string()))
                }
            }
        }
    }

    pub async fn create_inbound_receipt(
        pool: &PgPool,
        ws_sender: &tokio::sync::broadcast::Sender<crate::state::AlertMsg>,
        user_id: i32,
        payload: InboundReceiptPayload,
    ) -> Result<i32, AppError> {
        // 0. Check for duplicate receipt number
        let exists = sqlx::query("SELECT 1 FROM inbound_receipts WHERE receipt_number = $1")
            .bind(&payload.receipt_number)
            .fetch_optional(pool)
            .await?;
        
        if exists.is_some() {
            return Err(AppError::BadRequest(format!("Receipt number {} already exists", payload.receipt_number)));
        }

        let mut tx = pool.begin().await?;

        // 1. Inject Audit Context
        inject_audit_context(&mut tx, user_id).await?;

        // 2. Create Receipt Header
        let receipt_record = sqlx::query(
            r#"
            INSERT INTO inbound_receipts (
                receipt_number, supplier_id, receipt_date, 
                invoice_no, invoice_date, received_date, 
                note, status, created_by
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            RETURNING receipt_id
            "#
        )
        .bind(&payload.receipt_number)
        .bind(payload.supplier_id)
        .bind(payload.receipt_date)
        .bind(&payload.invoice_no)
        .bind(payload.invoice_date)
        .bind(payload.received_date)
        .bind(&payload.note)
        .bind(&payload.status)
        .bind(user_id)
        .fetch_one(&mut *tx)
        .await?;

        let receipt_id: i32 = receipt_record.try_get("receipt_id")?;

        // 3. Create Inbound Details for each item
        for item in payload.items {
            // Determine Quarantine Location
            let quarantine_loc = Self::determine_quarantine_location(&mut tx, item.product_id).await?;

            sqlx::query(
                r#"
                INSERT INTO inbound_details (receipt_id, product_id, batch_id, declared_qty, quarantine_location_id)
                VALUES ($1, $2, $3, $4, $5)
                "#
            )
            .bind(receipt_id)
            .bind(item.product_id)
            .bind(item.batch_id)
            .bind(item.declared_qty)
            .bind(quarantine_loc)
            .execute(&mut *tx)
            .await?;
        }

        tx.commit().await?;

        // 4. WebSocket Alert
        if payload.status == "PENDING_QC" {
            let _ = ws_sender.send(crate::state::AlertMsg {
                event: "INBOUND_CREATED".to_string(),
                product_id: None,
                message: format!("New Inbound Receipt {} created and pending QC verification.", payload.receipt_number),
            });
        }

        Ok(receipt_id)
    }
}
