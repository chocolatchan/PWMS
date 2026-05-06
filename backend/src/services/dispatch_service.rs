use crate::models::dtos::{CreateManifestRequest, PackBoxRequest};
use bigdecimal::{BigDecimal, FromPrimitive};
use sqlx::PgPool;

pub struct DispatchService;

impl DispatchService {
    pub async fn pack_box(
        pool: &PgPool,
        user_id: i32,
        req: &PackBoxRequest,
    ) -> Result<i32, String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        let weight = req.weight_kg.and_then(BigDecimal::from_f64);

        // 1. Insert into packed_boxes
        let box_id: i32 = sqlx::query!(
            r#"
            INSERT INTO packed_boxes (box_code, order_id, packed_by, seal_number, is_toxic_box, weight_kg, status)
            VALUES ($1, $2, $3, $4, $5, $6, 'PACKED')
            RETURNING box_id
            "#,
            req.box_code,
            req.order_id,
            user_id,
            req.seal_number,
            req.is_toxic_box,
            weight
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(|e| e.to_string())?
        .box_id;

        // 2. Lặp qua items, insert vào box_items
        for item in &req.items {
            sqlx::query!(
                r#"
                INSERT INTO box_items (box_id, product_id, batch_id, packed_qty)
                VALUES ($1, $2, $3, $4)
                "#,
                box_id,
                item.product_id,
                item.batch_id,
                item.packed_qty
            )
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        }

        // 3. Update sales_orders status = 'PACKING'
        sqlx::query!(
            "UPDATE sales_orders SET status = 'PACKING' WHERE order_id = $1",
            req.order_id
        )
        .execute(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;

        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(box_id)
    }

    pub async fn create_manifest(
        pool: &PgPool,
        user_id: i32,
        req: &CreateManifestRequest,
    ) -> Result<i32, String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        let temp = req.temp_before_departure.and_then(BigDecimal::from_f64);

        // 1. Insert vào dispatch_manifests trả về manifest_id
        let manifest_id: i32 = sqlx::query!(
            r#"
            INSERT INTO dispatch_manifests (manifest_code, vehicle_plate, driver_name, driver_phone, temp_before_departure, dispatched_by, status)
            VALUES ($1, $2, $3, $4, $5, $6, 'DISPATCHED')
            RETURNING manifest_id
            "#,
            req.manifest_code,
            req.vehicle_plate,
            req.driver_name,
            req.driver_phone,
            temp,
            user_id
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(|e| e.to_string())?
        .manifest_id;

        // 2. Lặp qua req.box_ids để gán vào chuyến xe và cập nhật trạng thái thùng
        for box_id in &req.box_ids {
            // Insert vào manifest_boxes
            sqlx::query!(
                "INSERT INTO manifest_boxes (manifest_id, box_id) VALUES ($1, $2)",
                manifest_id,
                box_id
            )
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;

            // Update packed_boxes set status = 'LOADED'
            sqlx::query!(
                "UPDATE packed_boxes SET status = 'LOADED' WHERE box_id = $1",
                box_id
            )
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        }

        // Commit tx
        tx.commit().await.map_err(|e| e.to_string())?;

        Ok(manifest_id)
    }
}
