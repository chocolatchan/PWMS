use axum::{extract::State, Json};
use crate::{
    error::AppError,
    state::SharedState,
    http::middleware::auth::UserContext,
};
use serde::Serialize;
use sqlx::Row;

#[derive(Serialize)]
pub struct AuditLogEntry {
    pub id: i64,
    pub table_name: String,
    pub record_id: i32,
    pub action: String,
    pub changed_by: Option<String>,
    pub changed_at: chrono::DateTime<chrono::Utc>,
    pub old_data: Option<serde_json::Value>,
    pub new_data: Option<serde_json::Value>,
}

#[axum::debug_handler]
pub async fn list_audit_logs(
    State(state): State<SharedState>,
    _user_ctx: UserContext,
) -> Result<Json<Vec<AuditLogEntry>>, AppError> {
    let rows = sqlx::query(
        r#"
        SELECT 
            l.log_id,
            l.table_name,
            l.record_id,
            l.action,
            u.username as changed_by,
            l.changed_at,
            l.old_data,
            l.new_data
        FROM audit_logs l
        LEFT JOIN users u ON l.changed_by = u.user_id
        ORDER BY l.changed_at DESC
        LIMIT 100
        "#
    )
    .fetch_all(&state.db)
    .await?;

    let result = rows.into_iter().map(|r| {
        AuditLogEntry {
            id: r.get("log_id"),
            table_name: r.get("table_name"),
            record_id: r.get("record_id"),
            action: r.get("action"),
            changed_by: r.get("changed_by"),
            changed_at: r.get("changed_at"),
            old_data: r.get("old_data"),
            new_data: r.get("new_data"),
        }
    }).collect();

    Ok(Json(result))
}
