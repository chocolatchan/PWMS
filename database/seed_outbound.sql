-- Seed Outbound Test Data
INSERT INTO totes (tote_code, status) VALUES ('TOTE-001', 'AVAILABLE') ON CONFLICT (tote_code) DO NOTHING;

INSERT INTO sales_orders (order_code, customer_name, status) 
VALUES ('SO-TEST-001', 'QA Tester', 'PENDING') 
ON CONFLICT DO NOTHING;

-- Lấy ID vừa tạo (giả định là 1 nếu db sạch)
INSERT INTO sales_order_lines (order_id, product_id, qty, is_toxic_line, is_lasa_line)
VALUES (1, 1, 10, false, false)
ON CONFLICT DO NOTHING;

INSERT INTO picking_tasks (order_id, status, zone_type, priority)
VALUES (1, 'PENDING', 'AVL', 1)
ON CONFLICT DO NOTHING;

-- Seed một batch bị RECALLED để test Circuit Breaker
UPDATE inventory_balances SET status = 'RECALLED' WHERE batch_id = 99;
