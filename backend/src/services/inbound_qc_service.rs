use crate::models::dtos::{ReceiveInboundReq, SubmitQcReq, PoDetailsResponse};
use crate::repositories::core_repo::WarehouseRepo;
use crate::error::AppError;
use sqlx::PgPool;
use serde_json::json;
use uuid::Uuid;

pub struct InboundQcService;

impl InboundQcService {
    pub async fn process_inbound(pool: &PgPool, req: ReceiveInboundReq) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        WarehouseRepo::insert_inbound_shipment_and_batches(&mut tx, req.clone())
            .await?;

        // Cập nhật số lượng đã nhận trong PO items
        for batch in &req.batches {
            sqlx::query!(
                "UPDATE purchase_order_items SET received_qty = received_qty + $1 WHERE po_number = $2 AND product_id = $3",
                batch.actual_qty,
                req.po_number,
                batch.product_id
            )
            .execute(&mut *tx)
            .await?;
        }

        // Kiểm tra xem PO đã hoàn tất chưa
        let remaining: Option<i64> = sqlx::query_scalar!(
            "SELECT SUM(expected_qty - received_qty) FROM purchase_order_items WHERE po_number = $1",
            req.po_number
        )
        .fetch_one(&mut *tx)
        .await?;

        if remaining.unwrap_or(0) <= 0 {
            sqlx::query!(
                "UPDATE purchase_orders SET status = 'CLOSED' WHERE po_number = $1",
                req.po_number
            )
            .execute(&mut *tx)
            .await?;
        }

        WarehouseRepo::insert_outbox_event(
            &mut tx,
            "INBOUND_RECEIVED",
            json!({ "po_number": req.po_number, "batches_count": req.batches.len() })
        )
        .await?;

        WarehouseRepo::unbind_draft(&mut tx, &req.po_number).await?;

        tx.commit().await?;

        Ok(())
    }

    pub async fn bind_draft(pool: &PgPool, po_number: &str, staff_id: Uuid) -> Result<(PoDetailsResponse, Option<sqlx::types::JsonValue>), AppError> {
        let mut tx = pool.begin().await?;
        let result = WarehouseRepo::bind_draft(&mut tx, po_number, staff_id).await?;
        tx.commit().await?;
        Ok(result)
    }

    pub async fn save_draft(pool: &PgPool, po_number: &str, payload: serde_json::Value) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;
        WarehouseRepo::save_draft(&mut tx, po_number, payload).await?;
        tx.commit().await?;
        Ok(())
    }

    pub async fn unbind_draft(pool: &PgPool, po_number: &str) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;
        WarehouseRepo::unbind_draft(&mut tx, po_number).await?;
        tx.commit().await?;
        Ok(())
    }

    pub async fn get_active_draft(pool: &PgPool, staff_id: Uuid) -> Result<Option<(PoDetailsResponse, sqlx::types::JsonValue)>, AppError> {
        let mut tx = pool.begin().await?;
        let result = WarehouseRepo::get_active_draft_by_staff(&mut tx, staff_id).await?;
        tx.commit().await?;
        Ok(result)
    }

    pub async fn move_to_quarantine(pool: &PgPool, req: crate::models::dtos::MoveToQuarantineReq) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        WarehouseRepo::move_to_quarantine(&mut tx, req.clone()).await?;

        WarehouseRepo::insert_outbox_event(
            &mut tx,
            "BATCH_QUARANTINED",
            json!({ "batch_number": req.batch_number, "location_code": req.location_code })
        )
        .await?;

        tx.commit().await?;

        Ok(())
    }

    pub async fn process_qc(pool: &PgPool, req: SubmitQcReq, qa_staff_id: Uuid) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        WarehouseRepo::update_inventory_from_qc(&mut tx, req.clone(), qa_staff_id)
            .await?;

        WarehouseRepo::insert_outbox_event(
            &mut tx,
            "QC_PROCESSED",
            json!({ "batch_number": req.batch_number, "decision": req.decision })
        )
        .await?;

        tx.commit().await?;

        Ok(())
    }
}
