-- Full Workflow Test Data (v4 Correct UUIDs)
-- 1. Create a New PO (Ready to Receive)
INSERT INTO purchase_orders (po_number, vendor_name, expected_date, status)
VALUES ('PO-TEST-001', 'PharmaDist Corp', CURRENT_DATE + INTERVAL '7 days', 'OPEN')
ON CONFLICT (po_number) DO NOTHING;

INSERT INTO purchase_order_items (po_number, product_id, expected_qty, received_qty)
VALUES ('PO-TEST-001', '11111111-1111-1111-1111-111111111111', 100, 0)
ON CONFLICT DO NOTHING;

-- 2. Create a Received Batch (Ready for QC)
INSERT INTO inbound_shipments (id, po_number, vehicle_seal_number, arrival_temperature, status)
VALUES ('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'PO-TEST-001', 'SEAL-123', 4.5, 'ARRIVED')
ON CONFLICT DO NOTHING;

INSERT INTO inbound_batches (id, inbound_shipment_id, product_id, batch_number, expiry_date, expected_qty, actual_qty, current_status)
VALUES ('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '11111111-1111-1111-1111-111111111111', 'BATCH-QC-PENDING', CURRENT_DATE + INTERVAL '2 years', 50, 50, 'QC_PENDING')
ON CONFLICT DO NOTHING;

-- 3. Create a QC Done Batch (Ready for Runner to move to Inventory Gate)
INSERT INTO inbound_batches (id, inbound_shipment_id, product_id, batch_number, expiry_date, expected_qty, actual_qty, current_status)
VALUES ('b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '22222222-2222-2222-2222-222222222222', 'BATCH-QC-DONE', CURRENT_DATE + INTERVAL '1 year', 20, 20, 'QC_DONE')
ON CONFLICT DO NOTHING;

INSERT INTO qc_inspections (id, inbound_batch_id, qa_staff_id, decision, min_temp, max_temp)
VALUES (gen_random_uuid(), 'b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', 'd8e37e80-42c8-47ee-9e00-2aed32ab351e', 'APPROVED', 2.1, 4.8)
ON CONFLICT DO NOTHING;

-- 4. Create Available Stock (Ready to be Ordered)
INSERT INTO inbound_batches (id, inbound_shipment_id, product_id, batch_number, expiry_date, expected_qty, actual_qty, current_status)
VALUES ('b3b3b3b3-b3b3-b3b3-b3b3-b3b3b3b3b3b3', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '33333333-3333-3333-3333-333333333333', 'BATCH-AVAILABLE-01', CURRENT_DATE + INTERVAL '18 months', 500, 500, 'QC_DONE')
ON CONFLICT DO NOTHING;

INSERT INTO inventory_balances (id, product_id, batch_number, location_id, inbound_batch_id, expiry_date, quantity, status)
VALUES (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', 'BATCH-AVAILABLE-01', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'b3b3b3b3-b3b3-b3b3-b3b3-b3b3b3b3b3b3', CURRENT_DATE + INTERVAL '18 months', 500, 'AVAILABLE')
ON CONFLICT DO NOTHING;

-- 5. Create an Open Order
INSERT INTO orders (id, customer_name)
VALUES ('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', 'Hospital Central')
ON CONFLICT DO NOTHING;

-- 6. Create a Container for Picking
INSERT INTO containers (id, order_id, current_status)
VALUES ('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', 'c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', 'PICKING')
ON CONFLICT DO NOTHING;

-- Allocate some stock for this container via pick_tasks
INSERT INTO pick_tasks (id, container_id, product_id, inventory_balance_id, batch_number, required_qty, picked_qty, status)
VALUES ('e1e1e1e1-1111-1111-1111-111111111111', 'd1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '33333333-3333-3333-3333-333333333333', (SELECT id FROM inventory_balances WHERE batch_number = 'BATCH-AVAILABLE-01' LIMIT 1), 'BATCH-AVAILABLE-01', 10, 0, 'PENDING')
ON CONFLICT DO NOTHING;

-- 7. Create a Picked Container (Ready to Pack)
INSERT INTO containers (id, order_id, current_status)
VALUES ('e2e2e2e2-2222-2222-2222-222222222222', 'c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', 'AT_PACKING')
ON CONFLICT DO NOTHING;

INSERT INTO pick_tasks (id, container_id, product_id, inventory_balance_id, batch_number, required_qty, picked_qty, status)
VALUES ('e3e3e3e3-3333-3333-3333-333333333333', 'e2e2e2e2-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', (SELECT id FROM inventory_balances WHERE batch_number = 'BATCH-AVAILABLE-01' LIMIT 1), 'BATCH-AVAILABLE-01', 5, 5, 'COMPLETED')
ON CONFLICT DO NOTHING;

INSERT INTO pack_tasks (id, container_id, packer_id, status)
VALUES (gen_random_uuid(), 'e2e2e2e2-2222-2222-2222-222222222222', 'd8e37e80-42c8-47ee-9e00-2aed32ab351e', 'COMPLETED')
ON CONFLICT DO NOTHING;

-- 8. Create a Packed Container (Ready to Dispatch)
INSERT INTO containers (id, order_id, current_status)
VALUES ('f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1f1', 'c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', 'PACKED')
ON CONFLICT DO NOTHING;
