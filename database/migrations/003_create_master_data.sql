-- Migration 003: Master Data
-- Định nghĩa các bảng danh mục thuốc, số lô, vị trí kho và quy đổi đơn vị

-- 1. Bảng danh mục sản phẩm (Thuốc/Dược phẩm)
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_code VARCHAR(50) NOT NULL UNIQUE,
    trade_name VARCHAR(255) NOT NULL,
    active_ingredient VARCHAR(255),
    dosage_form VARCHAR(100),
    packaging VARCHAR(100),
    storage_condition VARCHAR(255),
    base_unit VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng quy đổi đơn vị tính
CREATE TABLE unit_conversion (
    conversion_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    unit_name VARCHAR(50) NOT NULL,
    conversion_rate DECIMAL(12,4) NOT NULL,
    UNIQUE(product_id, unit_name)
);

-- 3. Bảng vị trí kho (Location)
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_code VARCHAR(20) NOT NULL UNIQUE,
    location_name VARCHAR(100),
    zone_type VARCHAR(50) NOT NULL, -- Released, Quarantine, Cold, Rejected, LASA, Controlled
    temp_min DECIMAL(5,2),
    temp_max DECIMAL(5,2),
    humidity_min DECIMAL(5,2),
    humidity_max DECIMAL(5,2),
    max_capacity INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng lô sản phẩm (Batch)
CREATE TABLE product_batches (
    batch_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    batch_number VARCHAR(50) NOT NULL,
    manufacture_date DATE,
    expiration_date DATE NOT NULL,
    UNIQUE(product_id, batch_number, expiration_date)
);

-- Thêm index cho tìm kiếm lô
CREATE INDEX idx_batches_product_expiry ON product_batches(product_id, expiration_date);
