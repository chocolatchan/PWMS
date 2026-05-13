-- 011_add_purchase_orders.sql
CREATE TABLE purchase_orders (
    po_number VARCHAR PRIMARY KEY,
    vendor_name VARCHAR,
    expected_date DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Seed some POs for testing
INSERT INTO purchase_orders (po_number, vendor_name, expected_date) VALUES 
('PO-2026-001', 'PharmaCorp', '2026-06-01'),
('PO-2026-002', 'MediSupply', '2026-06-15'),
('PO-QUARANTINE-TEST', 'TestVendor', '2026-05-13');
