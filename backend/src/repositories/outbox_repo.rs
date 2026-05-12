use sqlx::{Postgres, Transaction};

pub struct OutboxRepo;

impl OutboxRepo {
    pub async fn insert_event(
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
