use crate::state::{SharedState, AlertMsg};
use tokio_cron_scheduler::{Job, JobScheduler};

pub struct SensorService;

impl SensorService {
    pub async fn start_monitoring(state: SharedState) -> Result<(), Box<dyn std::error::Error>> {
        let sched = JobScheduler::new().await?;

        // Cronjob: Run every 30 seconds
        let job = Job::new_async("1/30 * * * * *", move |_uuid, _l| {
            let state_clone = state.clone();
            Box::pin(async move {
                Self::trigger_check_now(state_clone).await;
            })
        })?;

        sched.add(job).await?;
        
        // Start the scheduler in the background
        tokio::spawn(async move {
            if let Err(e) = sched.start().await {
                tracing::error!("Error starting cron scheduler: {:?}", e);
            }
        });

        Ok(())
    }

    pub async fn trigger_check_now(state: SharedState) {
        // In a real WMS, this would query IoT sensors or a time-series DB.
        // Here, we simulate a random check. We'll query if there's any product in 'Cold' storage
        // and randomly trigger a warning if a hypothetical sensor reports > 8°C.
        
        let cold_products = sqlx::query!(
            r#"
            SELECT DISTINCT p.product_id, p.trade_name, l.location_code
            FROM inventory_balances ib
            JOIN products p ON ib.product_id = p.product_id
            JOIN locations l ON ib.location_id = l.location_id
            WHERE l.zone_type = 'Cold' AND ib.available_qty > 0
            LIMIT 5
            "#
        )
        .fetch_all(&state.db)
        .await
        .unwrap_or_default();

        if cold_products.is_empty() {
            return;
        }

        // Simulate a 10% chance of a temperature alert
        if rand::random::<f64>() < 0.10 {
            // Pick the first cold product for the alert
            let target = &cold_products[0];
            
            let alert = AlertMsg {
                event: "TEMP_ALERT".to_string(),
                product_id: Some(target.product_id),
                message: format!(
                    "CRITICAL: Temperature in {} exceeds 8°C! Product {} is at risk of GDP violation.",
                    target.location_code, target.trade_name
                ),
            };

            // Broadcast to all connected WebSocket clients
            if state.ws_sender.receiver_count() > 0 {
                let _ = state.ws_sender.send(alert);
                tracing::warn!("Broadcasted TEMP_ALERT for location {}", target.location_code);
            }
        }
    }
}
