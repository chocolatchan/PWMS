use sqlx::{Postgres, Transaction};
use bigdecimal::BigDecimal;
use bigdecimal::FromPrimitive;
use uuid::Uuid;
use crate::models::dtos::{ReceiveInboundReq, SubmitQcReq, PoItemDto, PoDetailsResponse};
use crate::models::entities::{BatchStatus, QcDecision};

pub struct WarehouseRepo;

impl WarehouseRepo {
    pub async fn insert_inbound_shipment_and_batches(
        tx: &mut Transaction<'_, Postgres>,
        req: ReceiveInboundReq,
    ) -> Result<(), sqlx::Error> {
        let shipment_id = sqlx::query!(
            r#"
            INSERT INTO inbound_shipments (po_number, vehicle_seal_number, arrival_temperature, status)
            VALUES ($1, $2, $3, 'ARRIVED'::inbound_status)
            RETURNING id
            "#,
            req.po_number,
            req.vehicle_seal_number,
            req.arrival_temperature.and_then(BigDecimal::from_f64),
        )
        .fetch_one(&mut **tx)
        .await?
        .id;

        for batch in req.batches {
            sqlx::query!(
                r#"
                INSERT INTO inbound_batches (inbound_shipment_id, product_id, batch_number, expiry_date, expected_qty, actual_qty, current_status)
                VALUES ($1, $2, $3, $4, $5, $6, 'RECEIVED'::batch_status)
                "#,
                shipment_id,
                batch.product_id,
                batch.batch_number,
                batch.expiry_date,
                batch.expected_qty,
                batch.actual_qty
            )
            .execute(&mut **tx)
            .await?;
        }

        Ok(())
    }

    pub async fn move_to_quarantine(
        tx: &mut Transaction<'_, Postgres>,
        req: crate::models::dtos::MoveToQuarantineReq,
    ) -> Result<(), sqlx::Error> {
        // 1. Get batch info by batch_number
        let batch = sqlx::query!(
            r#"
            SELECT id, product_id, batch_number, expiry_date, actual_qty 
            FROM inbound_batches 
            WHERE batch_number = $1 AND current_status = 'RECEIVED'::batch_status
            LIMIT 1
            "#,
            req.batch_number
        )
        .fetch_one(&mut **tx)
        .await?;

        // 2. Insert into inventory_balances with QUARANTINE status
        sqlx::query!(
            r#"
            INSERT INTO inventory_balances (product_id, location_id, inbound_batch_id, batch_number, expiry_date, quantity, status)
            VALUES ($1, (SELECT id FROM locations WHERE zone_code = $2 LIMIT 1), $3, $4, $5, $6, 'QUARANTINE'::inventory_status)
            "#,
            batch.product_id.expect("Product ID must exist"),
            req.location_code,
            batch.id,
            batch.batch_number.expect("Batch Number must exist"),
            batch.expiry_date,
            batch.actual_qty.unwrap_or(0)
        )
        .execute(&mut **tx)
        .await?;

        // 3. Update inbound_batches to QC_PENDING
        sqlx::query!(
            "UPDATE inbound_batches SET current_status = 'QC_PENDING'::batch_status WHERE id = $1",
            batch.id
        )
        .execute(&mut **tx)
        .await?;

        Ok(())
    }

    pub async fn update_inventory_from_qc(
        tx: &mut Transaction<'_, Postgres>,
        req: SubmitQcReq,
        qa_staff_id: Uuid,
    ) -> Result<(), sqlx::Error> {
        // 0. Resolve batch_number to id
        let batch_id = sqlx::query!(
            "SELECT id FROM inbound_batches WHERE batch_number = $1 AND current_status = 'QC_PENDING'::batch_status LIMIT 1",
            req.batch_number
        )
        .fetch_one(&mut **tx)
        .await?
        .id;

        // 1. Save QC Result
        sqlx::query!(
            r#"
            INSERT INTO qc_inspections (inbound_batch_id, qa_staff_id, min_temp, max_temp, deviation_report_id, decision)
            VALUES ($1, $2, $3, $4, $5, $6::qc_decision)
            "#,
            batch_id,
            qa_staff_id,
            req.min_temp.and_then(BigDecimal::from_f64),
            req.max_temp.and_then(BigDecimal::from_f64),
            req.deviation_report_id,
            req.decision as QcDecision
        )
        .execute(&mut **tx)
        .await?;

        // 2. Cập nhật trạng thái Batch
        let new_batch_status = if req.decision == QcDecision::Approved { BatchStatus::QcDone } else { BatchStatus::QcRejected };
        sqlx::query!(
            "UPDATE inbound_batches SET current_status = $1::batch_status WHERE id = $2",
            new_batch_status as BatchStatus,
            batch_id
        )
        .execute(&mut **tx)
        .await?;

        // 3. Đẩy vào Tồn kho nếu APPROVED
        if req.decision == QcDecision::Approved {
            sqlx::query!(
                r#"
                UPDATE inventory_balances 
                SET status = 'AVAILABLE'::inventory_status,
                    location_id = (SELECT id FROM locations WHERE zone_type = 'ACCEPTED_INV' LIMIT 1)
                WHERE inbound_batch_id = $1
                "#,
                batch_id
            )
            .execute(&mut **tx)
            .await?;
        } else {
            // Đẩy vào Tồn kho REJECTED
            sqlx::query!(
                r#"
                UPDATE inventory_balances 
                SET status = 'REJECTED'::inventory_status,
                    location_id = (SELECT id FROM locations WHERE zone_type = 'REJECTED_INV' LIMIT 1)
                WHERE inbound_batch_id = $1
                "#,
                batch_id
            )
            .execute(&mut **tx)
            .await?;
        }

        Ok(())
    }

    pub async fn insert_outbox_event(
        tx: &mut Transaction<'_, Postgres>,
        event_type: &str,
        payload: serde_json::Value,
    ) -> Result<(), sqlx::Error> {
        let json_payload = sqlx::types::Json(payload); 
        
        sqlx::query!(
            r#"
            INSERT INTO outbox_events (event_type, payload, processed)
            VALUES ($1, $2, false)
            "#,
            event_type,
            json_payload as _
        )
        .execute(&mut **tx)
        .await?;

        Ok(())
    }

    pub async fn get_po_details(
        tx: &mut Transaction<'_, Postgres>,
        po_number: &str,
    ) -> Result<PoDetailsResponse, crate::error::AppError> {
        let po = sqlx::query!(
            "SELECT po_number, vendor_name, status FROM purchase_orders WHERE po_number = $1",
            po_number
        )
        .fetch_optional(&mut **tx)
        .await?
        .ok_or_else(|| crate::error::AppError::NotFound(format!("PO {} not found", po_number)))?;

        if po.status == "CLOSED" {
            return Err(crate::error::AppError::Forbidden(format!("PO {} is already closed", po_number)));
        }

        let items = sqlx::query_as!(
            PoItemDto,
            r#"
            SELECT 
                poi.product_id, 
                p.name as product_name, 
                poi.expected_qty, 
                poi.received_qty
            FROM purchase_order_items poi
            JOIN products p ON p.id = poi.product_id
            WHERE poi.po_number = $1
            "#,
            po_number
        )
        .fetch_all(&mut **tx)
        .await?;

        Ok(PoDetailsResponse {
            po_number: po.po_number,
            vendor_name: po.vendor_name,
            status: po.status,
            items,
        })
    }

    pub async fn bind_draft(
        tx: &mut Transaction<'_, Postgres>,
        po_number: &str,
        staff_id: Uuid,
    ) -> Result<(PoDetailsResponse, Option<sqlx::types::JsonValue>), crate::error::AppError> {
        // 1. Get PO Details and check existence/status
        let po_details = Self::get_po_details(tx, po_number).await?;

        // 2. Check existing draft
        let existing = sqlx::query!(
            "SELECT staff_id, payload FROM inbound_drafts WHERE po_number = $1",
            po_number
        )
        .fetch_optional(&mut **tx)
        .await?;

        if let Some(record) = existing {
            if record.staff_id != staff_id {
                return Ok((po_details, None)); // Conflict
            }
            return Ok((po_details, Some(record.payload))); // Return existing payload
        }

        sqlx::query!(
            "INSERT INTO inbound_drafts (po_number, staff_id) VALUES ($1, $2)",
            po_number,
            staff_id
        )
        .execute(&mut **tx)
        .await?;

        Ok((po_details, Some(serde_json::json!({}))))
    }

    pub async fn save_draft(
        tx: &mut Transaction<'_, Postgres>,
        po_number: &str,
        payload: serde_json::Value,
    ) -> Result<(), sqlx::Error> {
        sqlx::query!(
            "UPDATE inbound_drafts SET payload = $1 WHERE po_number = $2",
            payload,
            po_number
        )
        .execute(&mut **tx)
        .await?;
        Ok(())
    }

    pub async fn unbind_draft(
        tx: &mut Transaction<'_, Postgres>,
        po_number: &str,
    ) -> Result<(), sqlx::Error> {
        sqlx::query!(
            "DELETE FROM inbound_drafts WHERE po_number = $1",
            po_number
        )
        .execute(&mut **tx)
        .await?;
        Ok(())
    }

    pub async fn get_active_draft_by_staff(
        tx: &mut Transaction<'_, Postgres>,
        staff_id: Uuid,
    ) -> Result<Option<(PoDetailsResponse, sqlx::types::JsonValue)>, crate::error::AppError> {
        let record = sqlx::query!(
            "SELECT po_number, payload FROM inbound_drafts WHERE staff_id = $1 LIMIT 1",
            staff_id
        )
        .fetch_optional(&mut **tx)
        .await?;

        if let Some(r) = record {
            let po_details = Self::get_po_details(tx, &r.po_number).await?;
            let mut payload = r.payload;
            if let Some(obj) = payload.as_object_mut() {
                if !obj.contains_key("po_number") {
                    obj.insert("po_number".to_string(), serde_json::Value::String(r.po_number));
                }
            }
            return Ok(Some((po_details, payload)));
        }
        Ok(None)
    }
}
