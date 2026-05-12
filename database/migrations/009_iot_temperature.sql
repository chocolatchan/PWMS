-- Bảng temperature_logs
CREATE TABLE IF NOT EXISTS temperature_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    location_id UUID NOT NULL REFERENCES locations(id),
    logger_id VARCHAR NOT NULL,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    temperature_celsius DECIMAL(5,2) NOT NULL,
    is_alert BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT
);

-- Thêm cột alert_threshold_celsius cho locations (cho phép cấu hình theo từng vị trí)
ALTER TABLE locations
ADD COLUMN IF NOT EXISTS alert_threshold_celsius DECIMAL(5,2) DEFAULT 8.0;

-- Cập nhật ngưỡng mặc định cho các zone đã có
UPDATE locations SET alert_threshold_celsius = 8.0 WHERE alert_threshold_celsius IS NULL;
