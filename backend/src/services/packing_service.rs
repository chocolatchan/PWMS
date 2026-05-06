use sqlx::PgPool;
use crate::models::dtos::{PackBoxRequest, CreateManifestRequest};
use rust_decimal::prelude::FromPrimitive;
use rust_decimal::Decimal;

pub struct PackingService;

impl PackingService {
    pub async fn pack_box(pool: &PgPool, user_id: i32, req: PackBoxRequest) -> Result<i32, String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        let weight = req.weight_kg.and_then(Decimal::from_f64);

        // 1. Tạo thùng hàng (Packed Box)
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
            weight,
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(|e| e.to_string())?
        .box_id;

        // 2. Lưu chi tiết hàng trong thùng (Box Items)
        for item in req.items {
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

        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(box_id)
    }

    pub async fn create_manifest(pool: &PgPool, user_id: i32, req: CreateManifestRequest) -> Result<i32, String> {
        let mut tx = pool.begin().await.map_err(|e| e.to_string())?;

        let temp = req.temp_before_departure.and_then(Decimal::from_f64);

        // 1. Tạo chuyến xe (Dispatch Manifest)
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

        // 2. Gán thùng hàng vào chuyến xe và cập nhật trạng thái
        for box_id in req.box_ids {
            sqlx::query!(
                "INSERT INTO manifest_boxes (manifest_id, box_id) VALUES ($1, $2)",
                manifest_id,
                box_id
            )
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;

            sqlx::query!(
                "UPDATE packed_boxes SET status = 'LOADED' WHERE box_id = $1",
                box_id
            )
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        }

        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(manifest_id)
    }
}
