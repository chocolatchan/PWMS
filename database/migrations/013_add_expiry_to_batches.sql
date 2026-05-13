-- 013_add_expiry_to_batches.sql
ALTER TABLE inbound_batches ADD COLUMN IF NOT EXISTS expiry_date DATE;

-- Update existing batches if any (just for safety)
UPDATE inbound_batches SET expiry_date = CURRENT_DATE + INTERVAL '1 year' WHERE expiry_date IS NULL;
