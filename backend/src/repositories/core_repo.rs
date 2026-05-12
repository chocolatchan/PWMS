use sqlx::{Postgres, Transaction};
use bigdecimal::BigDecimal;
use bigdecimal::FromPrimitive;
use uuid::Uuid;
use crate::models::dtos::{ReceiveInboundReq, SubmitQcReq};
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
                INSERT INTO inbound_batches (inbound_shipment_id, product_id, batch_number, expected_qty, actual_qty, current_status)
                VALUES ($1, $2, $3, $4, $5, 'RECEIVED'::batch_status)
                "#,
                shipment_id,
                batch.product_id,
                batch.batch_number,
                batch.expected_qty,
                batch.actual_qty
            )
            .execute(&mut **tx)
            .await?;
        }

        Ok(())
    }

    pub async fn update_inventory_from_qc(
        tx: &mut Transaction<'_, Postgres>,
        req: SubmitQcReq,
        qa_staff_id: Uuid,
    ) -> Result<(), sqlx::Error> {
        // 1. Save QC Result
        sqlx::query!(
            r#"
            INSERT INTO qc_inspections (inbound_batch_id, qa_staff_id, min_temp, max_temp, deviation_report_id, decision)
            VALUES ($1, $2, $3, $4, $5, $6::qc_decision)
            "#,
            req.inbound_batch_id,
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
            req.inbound_batch_id
        )
        .execute(&mut **tx)
        .await?;

        // 3. Đẩy vào Tồn kho nếu APPROVED
        if req.decision == QcDecision::Approved {
            let batch = sqlx::query!(
                r#"
                SELECT product_id, batch_number, actual_qty 
                FROM inbound_batches 
                WHERE id = $1
                "#,
                req.inbound_batch_id
            )
            .fetch_one(&mut **tx)
            .await?;

            sqlx::query!(
                r#"
                INSERT INTO inventory_balances (product_id, location_id, inbound_batch_id, batch_number, expiry_date, quantity, status)
                VALUES ($1, (SELECT id FROM locations WHERE zone_type = 'ACCEPTED_INV' LIMIT 1), $2, $3, CURRENT_DATE + INTERVAL '1 year', $4, 'AVAILABLE'::inventory_status)
                "#,
                batch.product_id.expect("Product ID must exist after QC"),
                req.inbound_batch_id,
                batch.batch_number.expect("Batch Number must exist after QC"),
                batch.actual_qty.unwrap_or(0)
            )
            .execute(&mut **tx)
            .await?;
        } else {
            // Đẩy vào Tồn kho REJECTED
            let batch = sqlx::query!(
                r#"
                SELECT product_id, batch_number, actual_qty 
                FROM inbound_batches 
                WHERE id = $1
                "#,
                req.inbound_batch_id
            )
            .fetch_one(&mut **tx)
            .await?;

            sqlx::query!(
                r#"
                INSERT INTO inventory_balances (product_id, location_id, inbound_batch_id, batch_number, expiry_date, quantity, status)
                VALUES ($1, (SELECT id FROM locations WHERE zone_type = 'REJECTED_INV' LIMIT 1), $2, $3, CURRENT_DATE + INTERVAL '1 year', $4, 'REJECTED'::inventory_status)
                "#,
                batch.product_id.expect("Product ID must exist after QC"),
                req.inbound_batch_id,
                batch.batch_number.expect("Batch Number must exist after QC"),
                batch.actual_qty.unwrap_or(0)
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
}
