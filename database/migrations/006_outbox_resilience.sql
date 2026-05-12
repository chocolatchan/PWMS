-- database/migrations/006_outbox_resilience.sql
ALTER TABLE outbox_events 
ADD COLUMN IF NOT EXISTS retry_count INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_error TEXT,
ADD COLUMN IF NOT EXISTS next_retry_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

CREATE INDEX IF NOT EXISTS idx_outbox_retry ON outbox_events(processed, next_retry_at) 
WHERE processed = false;
