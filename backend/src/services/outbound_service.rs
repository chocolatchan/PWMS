use crate::error::AppError;
use crate::models::entities::TaskStatus;
use crate::repositories::outbound_repo::OutboundRepo;
use crate::repositories::outbox_repo::OutboxRepo;
use serde_json::json;
use sqlx::PgPool;
use uuid::Uuid;

pub struct OutboundService;

impl OutboundService {
    pub async fn scan_pick_item(
        pool: &PgPool,
        task_id: Uuid,
        barcode: String,
        input_qty: i32,
        picker_id: Uuid,
    ) -> Result<(), AppError> {
        // Validation: Positive quantity
        if input_qty <= 0 {
            return Err(AppError::BadRequest(
                "Quantity must be positive.".to_string(),
            ));
        }

        let mut tx = pool.begin().await?;

        // 1. Fetch task and product info
        let task_info = OutboundRepo::get_pick_task_and_product(&mut tx, task_id).await?;

        // 2. Validate task status
        if task_info.status == TaskStatus::Completed {
            return Err(AppError::BadRequest(
                "Pick task is already completed.".to_string(),
            ));
        }

        // 3. CRITICAL DOMAIN RULE (LASA)
        if task_info.is_lasa && input_qty > 1 {
            return Err(AppError::BadRequest(
                "LASA items require individual physical barcode scans (qty must be exactly 1)."
                    .to_string(),
            ));
        }

        // 4. Validate quantity bounds
        if task_info.picked_qty + input_qty > task_info.required_qty {
            return Err(AppError::BadRequest(format!(
                "Cannot pick more than required. Required: {}, Already Picked: {}, Input: {}",
                task_info.required_qty, task_info.picked_qty, input_qty
            )));
        }

        // 5. Update task progress
        OutboundRepo::increment_picked_qty(&mut tx, task_id, input_qty, picker_id).await?;

        let new_picked_qty = task_info.picked_qty + input_qty;

        // 6. If task is finished, perform inventory deduction and state transition
        if new_picked_qty == task_info.required_qty {
            // Deduct from physical inventory
            if let Some(inv_balance_id) = task_info.inventory_balance_id {
                OutboundRepo::deduct_inventory_on_pick(
                    &mut tx,
                    inv_balance_id,
                    task_info.required_qty,
                )
                .await?;
            } else {
                return Err(AppError::InternalServerError(
                    "Pick task has no inventory_balance_id assigned.".to_string(),
                ));
            }

            // Transition task and container status
            let container_ready = OutboundRepo::complete_pick_task_and_check_container(
                &mut tx,
                task_id,
                task_info.container_id,
            )
            .await?;

            if container_ready {
                OutboxRepo::insert_event(
                    &mut tx,
                    "CONTAINER_READY_FOR_PACKING",
                    json!({
                        "container_id": task_info.container_id
                    }),
                )
                .await?;
            }
        }

        // 7. Audit event
        OutboxRepo::insert_event(
            &mut tx,
            "ITEM_PICKED",
            json!({
                "task_id": task_id,
                "container_id": task_info.container_id,
                "barcode": barcode,
                "picked_qty": input_qty,
                "total_picked": new_picked_qty,
                "is_completed": new_picked_qty == task_info.required_qty
            }),
        )
        .await?;

        tx.commit().await?;

        Ok(())
    }

    pub async fn pack_container(
        pool: &PgPool,
        container_id: Uuid,
        packer_id: Uuid,
    ) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        let packed = OutboundRepo::complete_packing(&mut tx, container_id, packer_id).await?;

        if !packed {
            return Err(AppError::BadRequest(
                "Container not found or not in AT_PACKING status.".to_string(),
            ));
        }

        OutboxRepo::insert_event(
            &mut tx,
            "CONTAINER_PACKED",
            json!({
                "container_id": container_id,
                "packer_id": packer_id
            }),
        )
        .await?;

        tx.commit().await?;

        Ok(())
    }

    pub async fn dispatch_container(
        pool: &PgPool,
        req: &crate::models::dtos::DispatchReq,
    ) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        OutboundRepo::dispatch_container(
            &mut tx,
            req.container_id,
            &req.vehicle_seal_number,
            req.dispatch_temperature,
        )
        .await?;

        OutboxRepo::insert_event(
            &mut tx,
            "CONTAINER_DISPATCHED",
            json!({ "container_id": req.container_id }),
        )
        .await?;

        tx.commit().await?;
        Ok(())
    }

    pub async fn get_pick_tasks(
        pool: &PgPool,
        container_id: Option<Uuid>,
        location_code: Option<String>,
    ) -> Result<Vec<crate::models::dtos::PickTaskResponse>, AppError> {
        let tasks = sqlx::query_as!(
            crate::models::dtos::PickTaskResponse,
            r#"
            SELECT 
                pt.id,
                pt.container_id as "container_id!",
                p.name as "product_name!",
                pt.batch_number,
                pt.required_qty as "required_qty!",
                COALESCE(pt.picked_qty, 0) as "picked_qty!",
                pt.status::text as "status!",
                l.zone_code as "location_code!"
            FROM pick_tasks pt
            JOIN products p ON pt.product_id = p.id
            JOIN inventory_balances ib ON pt.inventory_balance_id = ib.id
            JOIN locations l ON ib.location_id = l.id
            WHERE ($1::uuid IS NULL OR pt.container_id = $1)
              AND ($2::text IS NULL OR l.zone_code = $2)
            ORDER BY pt.status, pt.id
            "#,
            container_id,
            location_code
        )
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::DatabaseError(e))?;

        Ok(tasks)
    }
}
