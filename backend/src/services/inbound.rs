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

    pub async fn submit_inbound_item(
        pool: &PgPool,
        user_id: i32,
        payload: crate::models::SubmitItemPayload,
    ) -> Result<(String, String), AppError> {
        let mut tx = pool.begin().await?;
        inject_audit_context(&mut tx, user_id).await?;

        // 1. Look up product
        let product = sqlx::query!(
            "SELECT product_id, is_toxic FROM products WHERE product_id = $1",
            payload.product_id
        ).fetch_one(&mut *tx).await
            .map_err(|_| AppError::NotFound("Product not found".to_string()))?;

        // 2. Classify based on physical attributes
        let is_return = payload.is_return;
        let expected_prefix = if is_return {
            "RET-"
        } else if product.is_toxic {
            "TOX-"
        } else if !payload.is_coa_available {
            "QRN-"
        } else {
            "STD-"
        };
        let inv_status = if is_return {
            "RETURNED_QUARANTINE"
        } else if product.is_toxic {
            "TOXIC_INBOUND"
        } else if !payload.is_coa_available {
            "QUARANTINE"
        } else {
            "INBOUND_PENDING"
        };

        // 3. Parse tote_code
        let tote_upper = payload.tote_code.to_uppercase();
        if !tote_upper.starts_with(expected_prefix) {
            return Err(AppError::BadRequest(format!(
                "Sai loại rổ! Hàng này bắt buộc phải dùng rổ có tiền tố: {}", expected_prefix
            )));
        }

        // 4. Check Over-receiving
        if payload.declared_qty > payload.expected_qty {
            return Err(AppError::BadRequest(format!(
                "Nhập lố số lượng PO (Over-receiving): Khai báo {} > Dự kiến {}", 
                payload.declared_qty, payload.expected_qty
            )));
        }

        // 5. Khởi tạo hoặc cập nhật Tote đang được Inbound sử dụng
        let tote_id = sqlx::query_scalar!(
            r#"
            INSERT INTO totes (tote_code, status, current_user_id) 
            VALUES ($1, 'IN_USE', $2)
            ON CONFLICT (tote_code) DO UPDATE SET status = 'IN_USE', current_user_id = EXCLUDED.current_user_id
            RETURNING tote_id
            "#,
            tote_upper,
            user_id
        ).fetch_one(&mut *tx).await?;

        // 6. Check Pure Tote: Nếu rổ đang chứa sản phẩm khác
        let existing_items = sqlx::query!(
            r#"
            SELECT product_id FROM inbound_details 
            WHERE tote_id = $1 AND product_id != $2
            LIMIT 1
            "#,
            tote_id,
            payload.product_id
        ).fetch_optional(&mut *tx).await?;

        if existing_items.is_some() {
            return Err(AppError::BadRequest("Rổ đã chứa hàng khác (Not a Pure Tote)".to_string()));
        }

        let manufacture_date = chrono::NaiveDate::parse_from_str(&payload.manufacture_date, "%Y-%m-%d")
            .map_err(|_| AppError::BadRequest("Invalid manufacture_date. Expected YYYY-MM-DD".to_string()))?;
        let expiry_date = chrono::NaiveDate::parse_from_str(&payload.expiry_date, "%Y-%m-%d")
            .map_err(|_| AppError::BadRequest("Invalid expiry_date. Expected YYYY-MM-DD".to_string()))?;

        if expiry_date <= manufacture_date {
            return Err(AppError::BadRequest("Hạn dùng phải sau ngày sản xuất".to_string()));
        }

        let batch_id = sqlx::query_scalar!(
            r#"
            INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date)
            VALUES ($1, $2, $3, $4)
            ON CONFLICT (product_id, batch_number, expiration_date) DO UPDATE SET manufacture_date = EXCLUDED.manufacture_date
            RETURNING batch_id
            "#,
            payload.product_id,
            payload.batch_number,
            manufacture_date,
            expiry_date
        ).fetch_one(&mut *tx).await?;

        let quarantine_loc = match payload.quarantine_location_id {
            Some(loc_id) => loc_id,
            None => Self::determine_quarantine_location(&mut tx, payload.product_id).await?
        };

        // 7. Tính toán base_qty = actual_qty * uom_rate
        let base_qty = (payload.declared_qty as f64 * payload.uom_rate).round() as i32;

        // 8. Lưu inbound_details với reason_code
        sqlx::query!(
            r#"
            INSERT INTO inbound_details (receipt_id, product_id, batch_id, declared_qty, gate_note, quarantine_location_id, tote_id, is_return, quarantine_reason_code)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            "#,
            payload.receipt_id,
            payload.product_id,
            batch_id,
            payload.declared_qty, 
            payload.gate_note,
            quarantine_loc,
            tote_id, 
            is_return,
            payload.reason_code
        ).execute(&mut *tx).await?;

        // 9. Lưu vào inventory_balances với base_qty
        sqlx::query!(
            r#"
            INSERT INTO inventory_balances (batch_id, product_id, location_id, status, available_qty, expiration_date)
            VALUES ($1, $2, $3, $4, $5, $6)
            ON CONFLICT (batch_id, location_id) DO UPDATE SET 
                available_qty = inventory_balances.available_qty + EXCLUDED.available_qty,
                last_updated = CURRENT_TIMESTAMP
            "#,
            batch_id,
            payload.product_id,
            quarantine_loc,
            inv_status,
            base_qty,
            expiry_date
        ).execute(&mut *tx).await?;

        // 10. Log the inbound transaction
        sqlx::query!(
            r#"
            INSERT INTO inventory_transactions (batch_id, transaction_type, to_location_id, quantity_change, executor_id)
            VALUES ($1, 'INBOUND', $2, $3, $4)
            "#,
            batch_id,
            quarantine_loc,
            base_qty,
            user_id
        ).execute(&mut *tx).await?;

        tx.commit().await?;

        Ok((expected_prefix.to_string(), inv_status.to_string()))
    }
}
