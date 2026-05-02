use sqlx::{Postgres, Transaction};
use crate::error::AppError;

/// Injects the user_id into the PostgreSQL session context for the Audit Trigger.
/// This MUST be called immediately after starting a new transaction for any write operations.
pub async fn inject_audit_context(tx: &mut Transaction<'_, Postgres>, user_id: i32) -> Result<(), AppError> {
    sqlx::query("SELECT set_config('app.current_user_id', $1, true)")
        .bind(user_id.to_string())
        .execute(&mut **tx)
        .await?;
    Ok(())
}
