use sqlx::PgPool;
use serde_json::json;
use crate::error::AppError;
use crate::repositories::outbox_repo::OutboxRepo;

pub struct IotService;

impl IotService {
    pub async fn log_temperature(
        pool: &PgPool,
        location_code: &str,
        logger_id: &str,
        temperature: f64,
    ) -> Result<(), AppError> {
        let mut tx = pool.begin().await?;

        // 1. Tìm location_id và threshold
        let location = sqlx::query!(
            r#"
            SELECT id, alert_threshold_celsius
            FROM locations
            WHERE zone_code = $1
            "#,
            location_code
        )
        .fetch_optional(&mut *tx)
        .await?
        .ok_or_else(|| AppError::NotFound("Location not found".into()))?;

        // Extract threshold using Option logic correctly for sqlx BigDecimal
        let threshold_bigdec = location.alert_threshold_celsius;
        let mut threshold = 8.0;
        if let Some(t) = threshold_bigdec {
            use bigdecimal::ToPrimitive;
            threshold = t.to_f64().unwrap_or(8.0);
        }

        let is_alert = temperature > threshold;

        // 2. Ghi log nhiệt độ (có trường is_alert đã tính)
        sqlx::query!(
            r#"
            INSERT INTO temperature_logs (location_id, logger_id, temperature_celsius, is_alert)
            VALUES ($1, $2, $3, $4)
            "#,
            location.id,
            logger_id,
            bigdecimal::BigDecimal::try_from(temperature).unwrap_or_default(),
            is_alert
        )
        .execute(&mut *tx)
        .await?;

        // 3. Nếu vượt ngưỡng, ghi event vào outbox trong cùng transaction
        if is_alert {
            let payload = json!({
                "location_code": location_code,
                "logger_id": logger_id,
                "temperature": temperature,
                "threshold": threshold,
                "alert_time": chrono::Utc::now()
            });
            OutboxRepo::insert_event(&mut tx, "TEMPERATURE_ALERT", payload).await?;
        }

        tx.commit().await?;
        Ok(())
    }
}
