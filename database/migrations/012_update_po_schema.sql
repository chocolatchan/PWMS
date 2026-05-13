-- 012_update_po_schema.sql
-- Ensure status column exists in purchase_orders
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='purchase_orders' AND column_name='status') THEN
        ALTER TABLE purchase_orders ADD COLUMN status VARCHAR NOT NULL DEFAULT 'OPEN';
    END IF;
END $$;

-- Create items table
CREATE TABLE IF NOT EXISTS purchase_order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    po_number VARCHAR NOT NULL REFERENCES purchase_orders(po_number),
    product_id UUID NOT NULL REFERENCES products(id),
    expected_qty INT NOT NULL CHECK (expected_qty > 0),
    received_qty INT NOT NULL DEFAULT 0 CHECK (received_qty <= expected_qty),
    UNIQUE (po_number, product_id)
);

-- Seed some PO items
INSERT INTO purchase_order_items (po_number, product_id, expected_qty) VALUES
('PO-2026-001', '11111111-1111-1111-1111-111111111111', 100),
('PO-2026-001', '22222222-2222-2222-2222-222222222222', 50),
('PO-2026-002', '33333333-3333-3333-3333-333333333333', 200)
ON CONFLICT (po_number, product_id) DO NOTHING;
