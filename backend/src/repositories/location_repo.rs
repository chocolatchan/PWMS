use sqlx::PgPool;
use crate::models::entities::{Location, LockState};
use crate::error::AppError;

pub struct LocationRepository;

impl LocationRepository {
    pub async fn get_all(pool: &PgPool) -> Result<Vec<Location>, AppError> {
        let locations = sqlx::query_as!(
            Location,
            r#"
            SELECT 
                location_id as "location_id!", 
                location_code as "location_code!", 
                location_name as "location_name!", 
                zone_type as "zone_type!", 
                lock_state as "lock_state!: LockState"
            FROM locations
            "#
        )
        .fetch_all(pool)
        .await?;

        Ok(locations)
    }
}
