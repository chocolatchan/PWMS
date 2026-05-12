use sqlx::PgPool;
use std::time::Duration;
use tokio::time::sleep;
use tokio::sync::{watch, broadcast};
use crate::models::dtos::OutboxEventMessage;

pub async fn start_outbox_worker(pool: PgPool, mut shutdown: watch::Receiver<()>, event_tx: broadcast::Sender<OutboxEventMessage>) {
    tracing::info!("🚀 Outbox worker started");
    loop {
        // Check if shutdown signal has been sent
        if *shutdown.borrow() == () && shutdown.has_changed().unwrap_or(false) {
             tracing::info!("🛑 Outbox worker shutting down...");
             break;
        }

        if let Err(e) = process_outbox_batch(&pool, &event_tx).await {
            tracing::error!("Error processing outbox batch: {:?}", e);
        }

        // Wait for next poll or shutdown signal
        tokio::select! {
            _ = sleep(Duration::from_secs(2)) => {}
            _ = shutdown.changed() => {
                tracing::info!("🛑 Outbox worker received shutdown signal during sleep.");
                break;
            }
        }
    }
    tracing::info!("👋 Outbox worker stopped.");
}

async fn process_outbox_batch(pool: &PgPool, event_tx: &broadcast::Sender<OutboxEventMessage>) -> Result<(), sqlx::Error> {
    let mut tx = pool.begin().await?;

    // Fetch up to 50 unprocessed events using FOR UPDATE SKIP LOCKED for safe concurrent processing
    let events = sqlx::query!(
        r#"
        SELECT id, event_type, payload
        FROM outbox_events
        WHERE processed = false
        FOR UPDATE SKIP LOCKED
        LIMIT 50
        "#
    )
    .fetch_all(&mut *tx)
    .await?;

    for event in events {
        tracing::info!("📢 Broadcasting event: {} (ID: {})", event.event_type, event.id);
        
        let msg = OutboxEventMessage {
            id: event.id,
            event_type: event.event_type,
            payload: event.payload,
        };

        // Broadcast to all connected WS clients
        let _ = event_tx.send(msg);

        // Mark as processed
        sqlx::query!(
            "UPDATE outbox_events SET processed = true WHERE id = $1",
            event.id
        )
        .execute(&mut *tx)
        .await?;
    }

    tx.commit().await?;
    Ok(())
}
