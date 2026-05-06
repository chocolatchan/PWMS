-- Migration 010: Phase 4 Outbound, Totes & GSP Compliance Core

-- 1. Nâng cấp danh mục Sản phẩm (Hỗ trợ SO Screening)
ALTER TABLE products
ADD COLUMN is_toxic BOOLEAN NOT NULL DEFAULT FALSE,
ADD COLUMN is_lasa BOOLEAN NOT NULL DEFAULT FALSE;

-- 2. Nâng cấp Location (Khắc phục Boolean Blindness)
ALTER TABLE locations
ADD COLUMN lock_state VARCHAR(50) NOT NULL DEFAULT 'AVAILABLE'; 
-- Trạng thái: AVAILABLE, LOCKED_BY_TASK, LOCKED_TEMP_BREACH, MAINTENANCE

-- 3. Quản lý Rổ hàng (Totes - Vehicle)
CREATE TABLE totes (
    tote_id SERIAL PRIMARY KEY,
    tote_code VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(20) DEFAULT 'AVAILABLE', -- AVAILABLE, IN_USE
    current_user_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL, -- 3-Way Lock
    current_location_id INTEGER REFERENCES locations(location_id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_totes_code_prefix ON totes (tote_code varchar_pattern_ops);

-- 4. Đơn hàng xuất (Sales Orders - SO)
CREATE TABLE sales_orders (
    order_id SERIAL PRIMARY KEY,
    order_code VARCHAR(50) NOT NULL UNIQUE,
    partner_id INTEGER NOT NULL REFERENCES partners(partner_id),
    status VARCHAR(30) DEFAULT 'PENDING', -- PENDING, SCREENED, PICKING, PACKING, SHIPPED, PAUSED_RECALL
    order_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales_order_lines (
    line_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES sales_orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    requested_qty INTEGER NOT NULL,
    allocated_qty INTEGER DEFAULT 0, -- Số lượng đã hard-allocate trong DB
    picked_qty INTEGER DEFAULT 0,    -- Số lượng thực tế đã nằm trong Tote
    is_toxic_line BOOLEAN NOT NULL DEFAULT FALSE, 
    is_lasa_line BOOLEAN NOT NULL DEFAULT FALSE
);

-- 5. Outbound Picking Tasks (The 3-Way Lock Execution)
CREATE TABLE picking_tasks (
    task_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES sales_orders(order_id),
    tote_id INTEGER REFERENCES totes(tote_id),
    assigned_user_id INTEGER REFERENCES users(user_id),
    zone_type VARCHAR(50) NOT NULL, -- AVL, CLD, LAS, TOX
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, IN_PROGRESS, COMPLETED, PAUSED
    started_at TIMESTAMP,
    completed_at TIMESTAMP
);

-- 6. Map Audit Trigger (Bắt buộc theo chuẩn GSP)
CREATE TRIGGER audit_totes_trigger
AFTER INSERT OR UPDATE OR DELETE ON totes
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_sales_orders_trigger
AFTER INSERT OR UPDATE OR DELETE ON sales_orders
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_picking_tasks_trigger
AFTER INSERT OR UPDATE OR DELETE ON picking_tasks
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();