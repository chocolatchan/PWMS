use crate::models::dtos::{ReceiveInboundReq, SubmitQcReq};
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

        WarehouseRepo::insert_outbox_event(
            &mut tx,
            "INBOUND_RECEIVED",
            json!({ "po_number": req.po_number, "batches_count": req.batches.len() })
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
            json!({ "inbound_batch_id": req.inbound_batch_id, "decision": req.decision })
        )
        .await?;

        tx.commit().await?;

        Ok(())
    }
}
