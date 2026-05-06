-- Migration 011: Phase 5 Packing & Dispatch (GDP/GSP Compliance)

-- 1. Bảng quản lý Thùng hàng (Packed Boxes)
CREATE TABLE packed_boxes (
    box_id SERIAL PRIMARY KEY,
    box_code VARCHAR(50) NOT NULL UNIQUE, -- Mã vạch dán trên thùng (vd: BOX-2026-001)
    order_id INTEGER NOT NULL REFERENCES sales_orders(order_id) ON DELETE CASCADE,
    packed_by INTEGER REFERENCES users(user_id), -- Ai là người đóng gói (Packer)
    seal_number VARCHAR(50), -- Số niêm phong chì/nhựa (Bắt buộc với GSP)
    is_toxic_box BOOLEAN DEFAULT FALSE, -- Thùng có chứa hàng kiểm soát đặc biệt?
    weight_kg DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'PACKED', -- PACKED, LOADED, DELIVERED
    packed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Chi tiết hàng trong từng Thùng (Chain of Custody)
CREATE TABLE box_items (
    item_id SERIAL PRIMARY KEY,
    box_id INTEGER NOT NULL REFERENCES packed_boxes(box_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    batch_id INTEGER NOT NULL REFERENCES product_batches(batch_id),
    packed_qty INTEGER NOT NULL,
    CONSTRAINT positive_packed_qty CHECK (packed_qty > 0)
);

-- 3. Bảng quản lý Chuyến xe / Bàn giao (Dispatch Manifests - GDP)
CREATE TABLE dispatch_manifests (
    manifest_id SERIAL PRIMARY KEY,
    manifest_code VARCHAR(50) NOT NULL UNIQUE,
    vehicle_plate VARCHAR(20) NOT NULL, -- Biển số xe lạnh
    driver_name VARCHAR(100) NOT NULL,
    driver_phone VARCHAR(20),
    temp_before_departure DECIMAL(5,2), -- Nhiệt độ thùng xe lúc xuất phát (Cực kỳ quan trọng với hàng Lạnh)
    status VARCHAR(20) DEFAULT 'DISPATCHED', -- DISPATCHED, COMPLETED, CANCELLED
    dispatched_by INTEGER REFERENCES users(user_id),
    dispatched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng trung gian nối Thùng hàng và Chuyến xe (1 chuyến chở nhiều thùng)
CREATE TABLE manifest_boxes (
    manifest_id INTEGER REFERENCES dispatch_manifests(manifest_id) ON DELETE CASCADE,
    box_id INTEGER UNIQUE REFERENCES packed_boxes(box_id) ON DELETE CASCADE,
    PRIMARY KEY (manifest_id, box_id)
);

-- 5. Bật Audit Trail (Bất biến)
CREATE TRIGGER audit_packed_boxes_trigger
AFTER INSERT OR UPDATE OR DELETE ON packed_boxes
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_dispatch_manifests_trigger
AFTER INSERT OR UPDATE OR DELETE ON dispatch_manifests
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();