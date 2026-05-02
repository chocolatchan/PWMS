-- Migration 006: GSP/GDP Compliance Logs
-- Định nghĩa các bảng phục vụ kiểm soát vận chuyển, thu hồi, hiệu chuẩn và môi trường

-- 1. Nhật ký vận chuyển (Dispatch Records)
CREATE TABLE dispatch_records (
    dispatch_id SERIAL PRIMARY KEY,
    task_id INTEGER REFERENCES warehouse_tasks(task_id),
    vehicle_plate VARCHAR(20),
    driver_name VARCHAR(100),
    truck_temp_before DECIMAL(5,2),
    seal_number VARCHAR(50),
    gate_pass_signed BOOLEAN DEFAULT FALSE,
    dispatch_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Nhật ký hàng trả về / Thu hồi (Return Receipts)
CREATE TABLE return_receipts (
    return_id SERIAL PRIMARY KEY,
    original_invoice VARCHAR(50),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'PENDING_QA', -- PENDING_QA, RE_LABELED, REJECTED
    returned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Nhật ký hiệu chuẩn thiết bị (Calibration Logs)
CREATE TABLE calibration_logs (
    log_id SERIAL PRIMARY KEY,
    device_id VARCHAR(50) NOT NULL,
    prev_value DECIMAL(10,2),
    new_value DECIMAL(10,2),
    calibrated_by INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    certificate_url TEXT,
    next_due_date DATE,
    calibrated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Nhật ký điều kiện môi trường (Temperature/Humidity Logs)
CREATE TABLE temperature_logs (
    log_id SERIAL PRIMARY KEY,
    location_id INTEGER REFERENCES locations(location_id) ON DELETE CASCADE,
    temperature DECIMAL(5,2) NOT NULL,
    humidity DECIMAL(5,2),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index để báo cáo nhiệt độ nhanh theo thời gian và vị trí
CREATE INDEX idx_temp_logs_location_time ON temperature_logs(location_id, recorded_at);

-- Gắn Audit Trigger cho các bảng liên quan đến quyết định nghiệp vụ
CREATE TRIGGER audit_dispatch_records_trigger
AFTER INSERT OR UPDATE OR DELETE ON dispatch_records
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_return_receipts_trigger
AFTER INSERT OR UPDATE OR DELETE ON return_receipts
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_calibration_logs_trigger
AFTER INSERT OR UPDATE OR DELETE ON calibration_logs
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Seed additional presets for GSP/GDP compliance
INSERT INTO presets (preset_name, description) VALUES 
('Returns Handler', 'Chuyên trách Logistics ngược và thu hồi'), 
('Dispatch Specialist', 'Kiểm soát Gateway và vận chuyển (GDP)'), 
('Technical Admin', 'Quản trị kỹ thuật và hiệu chuẩn sensor'), 
('Compliance Auditor', 'Thanh tra và kiểm toán tuân thủ (Read-only)')
ON CONFLICT (preset_name) DO NOTHING;
