-- database/seed_v2_data.sql

-- 1. Create Inbound Shipment and Batch for Inventory (Already Received, Ready for Putaway/QC)
INSERT INTO inbound_shipments (id, po_number, status)
VALUES ('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'PO-SEED-001', 'ARRIVED')
ON CONFLICT DO NOTHING;

INSERT INTO inbound_batches (id, inbound_shipment_id, product_id, batch_number, actual_qty, current_status)
VALUES ('f2a3b4c5-d6e7-4f8a-9b0c-1d2e3f4a5b6c', 'e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', '11111111-1111-1111-1111-111111111111', 'BATCH-2026-X', 1000, 'QC_DONE')
ON CONFLICT DO NOTHING;

-- 1.5 Create Inbound Shipment and Batch for Testing "Move To Quarantine" Flow
INSERT INTO inbound_shipments (id, po_number, status)
VALUES ('55555555-5555-5555-5555-555555555555', 'PO-QUARANTINE-TEST', 'ARRIVED')
ON CONFLICT DO NOTHING;

-- This batch is in 'RECEIVED' state, ready to be moved to quarantine!
INSERT INTO inbound_batches (id, inbound_shipment_id, product_id, batch_number, expected_qty, actual_qty, current_status)
VALUES ('66666666-6666-6666-6666-666666666666', '55555555-5555-5555-5555-555555555555', '22222222-2222-2222-2222-222222222222', 'BATCH-TEST-QRN', 500, 500, 'RECEIVED')
ON CONFLICT DO NOTHING;

-- 2. Add Inventory Balance (Product: Paracetamol 500mg, Location: PCK-D1)
INSERT INTO inventory_balances (id, product_id, location_id, inbound_batch_id, batch_number, expiry_date, quantity, status)
SELECT 
    'c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f',
    (SELECT id FROM products WHERE name = 'Paracetamol 500mg' LIMIT 1), 
    (SELECT id FROM locations WHERE zone_code LIKE 'PCK-%' LIMIT 1), 
    'f2a3b4c5-d6e7-4f8a-9b0c-1d2e3f4a5b6c', 
    'BATCH-2026-X', 
    '2028-12-31', 
    1000, 
    'AVAILABLE'
ON CONFLICT DO NOTHING;

-- 3. Create an Order
INSERT INTO orders (id, customer_name)
VALUES ('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'Warehouse Tester')
ON CONFLICT DO NOTHING;

-- 4. Create a Container (Tote) for the order
INSERT INTO containers (id, order_id, current_status)
VALUES ('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'PICKING')
ON CONFLICT DO NOTHING;

-- 5. Create a Pick Task for the Container
INSERT INTO pick_tasks (container_id, product_id, batch_number, required_qty, picked_qty, status)
SELECT 
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',
    (SELECT id FROM products WHERE name = 'Paracetamol 500mg' LIMIT 1),
    'BATCH-2026-X',
    10,
    0,
    'PENDING'
ON CONFLICT DO NOTHING;
