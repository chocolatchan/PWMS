-- Migration 005: Inventory & Warehouse Operations
-- Quản lý các tác vụ kho, giao dịch và số dư tồn kho chi tiết

-- 1. Bảng các tác vụ kho (Warehouse Tasks)
CREATE TABLE warehouse_tasks (
    task_id SERIAL PRIMARY KEY,
    task_type VARCHAR(20) NOT NULL, -- INBOUND, OUTBOUND, RELOCATE, ADJUSTMENT, DISPOSAL
    batch_id INTEGER REFERENCES product_batches(batch_id),
    inspection_id INTEGER REFERENCES qc_inspections(inspection_id),
    from_location_id INTEGER REFERENCES locations(location_id),
    to_location_id INTEGER REFERENCES locations(location_id),
    target_qty INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- PENDING, IN_PROGRESS, DONE, CANCELLED
    created_by INTEGER REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Nhật ký giao dịch kho (Inventory Transactions)
-- Đây là bảng lịch sử chi tiết cho mọi biến động tồn kho
CREATE TABLE inventory_transactions (
    transaction_id SERIAL PRIMARY KEY,
    task_id INTEGER REFERENCES warehouse_tasks(task_id),
    batch_id INTEGER NOT NULL REFERENCES product_batches(batch_id),
    transaction_type VARCHAR(20) NOT NULL, -- INBOUND, OUTBOUND, RELOCATE, ADJUSTMENT, DISPOSAL, SYSTEM_EXPIRED
    from_location_id INTEGER REFERENCES locations(location_id),
    to_location_id INTEGER REFERENCES locations(location_id),
    quantity_change INTEGER NOT NULL, -- Số lượng thay đổi (+/-)
    executor_id INTEGER REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Số dư tồn kho thực tế (Inventory Balances)
CREATE TABLE inventory_balances (
    balance_id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES product_batches(batch_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    location_id INTEGER NOT NULL REFERENCES locations(location_id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL, -- Quarantine, Released, Rejected, Expired, Recalled
    available_qty INTEGER NOT NULL DEFAULT 0,
    expiration_date DATE NOT NULL, -- Denormalized for FEFO sorting
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT positive_inventory CHECK (available_qty >= 0),
    CONSTRAINT unique_batch_location UNIQUE (batch_id, location_id)
);

-- Index cho hiệu năng truy vấn
CREATE INDEX idx_inv_tasks_status ON warehouse_tasks(status);
CREATE INDEX idx_inv_transactions_batch ON inventory_transactions(batch_id);
CREATE INDEX idx_inventory_balances_fefo ON inventory_balances(status, expiration_date);

-- Gắn Audit Trigger cho các bảng nhạy cảm
CREATE TRIGGER audit_warehouse_tasks_trigger
AFTER INSERT OR UPDATE OR DELETE ON warehouse_tasks
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_inventory_transactions_trigger
AFTER INSERT OR UPDATE OR DELETE ON inventory_transactions
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_inventory_balances_trigger
AFTER INSERT OR UPDATE OR DELETE ON inventory_balances
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Tự động cập nhật inventory_balances từ inventory_transactions
CREATE OR REPLACE FUNCTION sync_inventory_balance()
RETURNS TRIGGER AS $body$
DECLARE
    v_product_id INTEGER;
    v_expiry_date DATE;
    v_status VARCHAR(20);
BEGIN
    -- Lấy thông tin product_id và expiration_date từ product_batches
    SELECT product_id, expiration_date INTO v_product_id, v_expiry_date
    FROM product_batches
    WHERE batch_id = NEW.batch_id;

    -- 1. Xử lý bên NHẬN (to_location_id)
    IF (NEW.to_location_id IS NOT NULL) THEN
        -- Xác định trạng thái mặc định cho vị trí nhận
        SELECT zone_type INTO v_status FROM locations WHERE location_id = NEW.to_location_id;
        
        INSERT INTO inventory_balances (batch_id, product_id, location_id, status, available_qty, expiration_date)
        VALUES (NEW.batch_id, v_product_id, NEW.to_location_id, v_status, NEW.quantity_change, v_expiry_date)
        ON CONFLICT (batch_id, location_id) 
        DO UPDATE SET 
            available_qty = inventory_balances.available_qty + NEW.quantity_change,
            last_updated = CURRENT_TIMESTAMP;
    END IF;

    -- 2. Xử lý bên XUẤT (from_location_id)
    IF (NEW.from_location_id IS NOT NULL) THEN
        UPDATE inventory_balances 
        SET available_qty = available_qty - NEW.quantity_change,
            last_updated = CURRENT_TIMESTAMP
        WHERE batch_id = NEW.batch_id AND location_id = NEW.from_location_id;
        
        -- (Tùy chọn) Xóa bản ghi nếu tồn kho bằng 0 để làm sạch bảng
        -- DELETE FROM inventory_balances WHERE available_qty = 0;
    END IF;

    RETURN NEW;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_inventory_balance
AFTER INSERT ON inventory_transactions
FOR EACH ROW EXECUTE FUNCTION sync_inventory_balance();
