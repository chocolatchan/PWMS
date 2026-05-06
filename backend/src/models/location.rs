use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, sqlx::Type, PartialEq, Clone, Copy)]
#[sqlx(type_name = "VARCHAR", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum LockState {
    Available,
    LockedByTask,
    LockedTempBreach,
    Maintenance,
}

impl Default for LockState {
    fn default() -> Self {
        LockState::Available
    }
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Location {
    pub location_id: i32,
    pub location_code: String,
    pub location_name: String,
    pub zone_type: String,
    pub lock_state: LockState,
}
