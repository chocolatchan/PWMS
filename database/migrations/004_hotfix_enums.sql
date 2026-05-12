-- Add new variants to enums. Must be run outside a transaction block if possible,
-- but SQLx migrations might require COMMIT before ALTER TYPE in older Postgres versions.
-- Note: 'ADD VALUE' cannot be executed inside a transaction block.
ALTER TYPE container_status ADD VALUE 'DISPATCHED';
ALTER TYPE batch_status ADD VALUE 'QC_REJECTED';
