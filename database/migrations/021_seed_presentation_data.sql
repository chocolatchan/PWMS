-- Migration 021: Seed Presentation Data
-- This migration populates the database with realistic mock data for UI demonstrations.

-- 1. Locations
INSERT INTO locations (location_code, location_name, zone_type, lock_state) VALUES 
('AVL-001', 'Kệ Standard 01', 'Released', 'AVAILABLE'),
('AVL-002', 'Kệ Standard 02', 'Released', 'AVAILABLE'),
('QRN-001', 'Khu vực Biệt trữ', 'Quarantine', 'AVAILABLE'),
('CLD-001', 'Kho Lạnh (2-8°C)', 'Cold', 'AVAILABLE'),
('REJ-001', 'Khu vực Chờ hủy', 'Rejected', 'AVAILABLE'),
('LAS-001', 'Kệ Thuốc LASA', 'LASA', 'AVAILABLE'),
('TOX-001', 'Tủ Thuốc Độc', 'Toxic', 'AVAILABLE'),
('DISPATCH-01', 'Cửa Xuất Hàng 01', 'Released', 'AVAILABLE')
ON CONFLICT (location_code) DO NOTHING;

-- 2. Totes (Containers)
INSERT INTO totes (tote_code, status) VALUES 
('QRN-001', 'AVAILABLE'),
('QRN-002', 'AVAILABLE'),
('STD-001', 'AVAILABLE'),
('STD-002', 'AVAILABLE'),
('TOX-001', 'AVAILABLE'),
('CLD-001', 'AVAILABLE')
ON CONFLICT (tote_code) DO NOTHING;

-- 3. Product Batches (Additional)
INSERT INTO product_batches (product_id, batch_number, expiration_date) 
SELECT p.product_id, 'L001/24', '2027-12-31' FROM products p WHERE p.product_code = 'P001'
ON CONFLICT DO NOTHING;

INSERT INTO product_batches (product_id, batch_number, expiration_date) 
SELECT p.product_id, 'L002/24', '2028-06-30' FROM products p WHERE p.product_code = 'P002'
ON CONFLICT DO NOTHING;

INSERT INTO product_batches (product_id, batch_number, expiration_date) 
SELECT p.product_id, 'TOX-M01', '2026-12-31' FROM products p WHERE p.product_code = 'P003'
ON CONFLICT DO NOTHING;

-- 4. Inbound Receipts
INSERT INTO inbound_receipts (receipt_number, supplier_id, receipt_date, status)
SELECT 'PO-2026-001', partner_id, '2026-05-01', 'PENDING_QC' 
FROM partners WHERE name = 'Zuellig Pharma Vietnam'
ON CONFLICT DO NOTHING;

-- 5. Inventory Balances (Initial Stock)
-- Note: Using subqueries to find IDs
INSERT INTO inventory_balances (batch_id, product_id, location_id, status, available_qty, expiration_date)
SELECT b.batch_id, b.product_id, l.location_id, l.zone_type, 1000, b.expiration_date
FROM product_batches b, locations l
WHERE b.batch_number = 'L001/24' AND l.location_code = 'AVL-001'
ON CONFLICT (batch_id, location_id) DO NOTHING;

INSERT INTO inventory_balances (batch_id, product_id, location_id, status, available_qty, expiration_date)
SELECT b.batch_id, b.product_id, l.location_id, l.zone_type, 50, b.expiration_date
FROM product_batches b, locations l
WHERE b.batch_number = 'TOX-M01' AND l.location_code = 'TOX-001'
ON CONFLICT (batch_id, location_id) DO NOTHING;

-- 6. Sales Orders (Pending)
INSERT INTO sales_orders (order_code, partner_id, status, order_date)
SELECT 'SO-1001', partner_id, 'PICKING', '2026-05-05'
FROM partners WHERE partner_type = 'supplier' LIMIT 1 -- Just for demo
ON CONFLICT DO NOTHING;

-- 7. Sales Order Lines
INSERT INTO sales_order_lines (order_id, product_id, requested_qty, allocated_qty)
SELECT o.order_id, p.product_id, 200, 200
FROM sales_orders o, products p
WHERE o.order_code = 'SO-1001' AND p.product_code = 'P001'
ON CONFLICT DO NOTHING;

-- 8. Picking Tasks
INSERT INTO picking_tasks (order_id, zone_type, status)
SELECT order_id, 'AVL', 'PENDING'
FROM sales_orders WHERE order_code = 'SO-1001'
ON CONFLICT DO NOTHING;
