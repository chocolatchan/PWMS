-- Safely drop the trigger and function if they exist
DROP TRIGGER IF EXISTS trigger_apply_inv_adj ON inventory_balances CASCADE;
DROP FUNCTION IF EXISTS apply_inventory_adjustment CASCADE;

-- Create the order_items table
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    required_qty INT NOT NULL CHECK (required_qty > 0),
    UNIQUE (order_id, product_id)
);

-- Alter inbound_batches table to add new columns
ALTER TABLE inbound_batches
    ADD COLUMN product_id UUID REFERENCES products(id),
    ADD COLUMN batch_number VARCHAR,
    ADD COLUMN expected_qty INT CHECK (expected_qty >= 0),
    ADD COLUMN actual_qty INT CHECK (actual_qty >= 0);

-- Add necessary indexes
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_inbound_batches_product_id ON inbound_batches(product_id);
