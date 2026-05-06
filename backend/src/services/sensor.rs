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
        // Query cold locations with products
        let cold_products = sqlx::query!(
            r#"
            SELECT DISTINCT p.product_id, p.trade_name, l.location_code, l.location_id, l.lock_state
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

        // Simulate a 10% chance of a temperature breach
        if rand::random::<f64>() < 0.10 {
            let target = &cold_products[0];
            
            // SOP V4.0 Phase 3.3 — Cold Chain Breach Auto-Lock
            // 1. Lock the location
            let _ = sqlx::query!(
                "UPDATE locations SET lock_state = 'LOCKED_TEMP_BREACH' WHERE location_id = $1 AND lock_state = 'AVAILABLE'",
                target.location_id
            )
            .execute(&state.db)
            .await;

            // 2. Auto-quarantine all items in this location
            let _ = sqlx::query!(
                "UPDATE inventory_balances SET status = 'COLD_BREACH_QUARANTINE' WHERE location_id = $1 AND status IN ('Released', 'AVAILABLE')",
                target.location_id
            )
            .execute(&state.db)
            .await;

            // 3. Pause picking tasks picking from this location
            let _ = sqlx::query!(
                r#"
                UPDATE picking_tasks SET status = 'PAUSED' 
                WHERE task_id IN (
                    SELECT DISTINCT pt.task_id 
                    FROM picking_tasks pt
                    JOIN sales_order_lines sol ON pt.order_id = sol.order_id
                    JOIN inventory_balances ib ON sol.product_id = ib.product_id AND ib.location_id = $1
                    WHERE pt.status IN ('PENDING', 'IN_PROGRESS')
                )
                "#,
                target.location_id
            )
            .execute(&state.db)
            .await;

            // 4. Log temperature breach
            let _ = sqlx::query!(
                "INSERT INTO temperature_logs (location_id, temperature, humidity) VALUES ($1, 9.5, 80.0)",
                target.location_id
            )
            .execute(&state.db)
            .await;

            // 5. Alert
            let alert = AlertMsg {
                event: "COLD_BREACH".to_string(),
                product_id: Some(target.product_id),
                message: format!(
                    "🚨 COLD CHAIN BREACH: Location {} — Temperature >8°C! Product {} auto-quarantined. Location LOCKED. All picking tasks PAUSED.",
                    target.location_code, target.trade_name
                ),
            };

            if state.ws_sender.receiver_count() > 0 {
                let _ = state.ws_sender.send(alert);
                tracing::warn!("COLD BREACH: Location {} locked, items quarantined", target.location_code);
            }
        }
    }
}
