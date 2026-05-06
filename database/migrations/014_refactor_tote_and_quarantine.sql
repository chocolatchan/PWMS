-- Migration 014: Refactor Inbound Details & Totes for SOP V4.0 Compliance
ALTER TABLE inbound_details 
ADD COLUMN IF NOT EXISTS quarantine_reason_code VARCHAR(50),
ADD COLUMN IF NOT EXISTS tote_id INTEGER REFERENCES totes(tote_id);

ALTER TABLE totes 
DROP COLUMN IF EXISTS color;

CREATE INDEX IF NOT EXISTS idx_totes_tote_code_btree ON totes(tote_code);
