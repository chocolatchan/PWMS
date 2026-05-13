-- Add inbound drafts table for PO locking and drafting
CREATE TABLE IF NOT EXISTS inbound_drafts (
    po_number VARCHAR PRIMARY KEY,
    staff_id UUID NOT NULL REFERENCES users(id),
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_inbound_drafts_updated_at
BEFORE UPDATE ON inbound_drafts
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();
