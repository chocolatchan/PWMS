use sqlx::PgPool;
use tokio_cron_scheduler::{Job, JobScheduler};
use tracing::{info, error};

pub async fn start_expiry_worker(pool: PgPool) {
    let sched = JobScheduler::new().await.expect("Failed to create scheduler");

    // Job runs every day at 00:00 (Midnight)
    // "0 0 0 * * *"
    // For testing/demo, we can run it every hour: "0 0 * * * *"
    // Or even every 5 minutes: "0 */5 * * * *"
    
    let pool_clone = pool.clone();
    let job = Job::new_async("0 0 0 * * *", move |_uuid, _l| {
        let p = pool_clone.clone();
        Box::pin(async move {
            info!("🕒 Running CronJob: Locking expired batches...");
            match lock_expired_inventory(&p).await {
                Ok(count) => info!("✅ Locked {} expired inventory records.", count),
                Err(e) => error!("❌ Failed to lock expired inventory: {:?}", e),
            }
        })
    }).expect("Failed to create job");

    sched.add(job).await.expect("Failed to add job");
    
    info!("🚀 Expiry CronJob worker started (scheduled for 00:00 daily)");
    sched.start().await.expect("Failed to start scheduler");
}

async fn lock_expired_inventory(pool: &PgPool) -> Result<u64, sqlx::Error> {
    // 1. Update inventory_balances status to REJECTED for expired batches
    // We check expiry_date < current_date
    let result = sqlx::query!(
        r#"
        UPDATE inventory_balances
        SET status = 'REJECTED'::inventory_status
        WHERE expiry_date < CURRENT_DATE
          AND status != 'REJECTED'::inventory_status
        "#
    )
    .execute(pool)
    .await?;

    Ok(result.rows_affected())
}
