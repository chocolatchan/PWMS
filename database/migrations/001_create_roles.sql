-- Migration 001: Auth & User System
-- Xóa bảng roles cũ (nếu có) và tạo hệ thống Permission/Preset mới

DROP TABLE IF EXISTS roles CASCADE;

-- 1. Bảng lưu các mã quyền hành động
CREATE TABLE permissions (
    permission_id SERIAL PRIMARY KEY,
    permission_code VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng lưu các bộ quyền thiết lập sẵn (Preset)
CREATE TABLE presets (
    preset_id SERIAL PRIMARY KEY,
    preset_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Bảng trung gian nối Preset và Permission (N-N)
CREATE TABLE preset_permissions (
    preset_id INTEGER REFERENCES presets(preset_id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES permissions(permission_id) ON DELETE CASCADE,
    PRIMARY KEY (preset_id, permission_id)
);

-- 4. Bảng thông tin nhân viên
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    cccd VARCHAR(20) UNIQUE,
    phone VARCHAR(20),
    birth_date DATE,
    start_date DATE DEFAULT CURRENT_DATE
);

-- 5. Bảng tài khoản người dùng
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id) ON DELETE CASCADE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Bảng gán Preset cho người dùng (N-N)
CREATE TABLE user_presets (
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    preset_id INTEGER REFERENCES presets(preset_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, preset_id)
);

-- Seed basic presets
INSERT INTO presets (preset_name, description) VALUES 
('Admin', 'Toàn quyền hệ thống'),
('Staff', 'Nhân viên vận hành kho'),
('QA', 'Nhân viên kiểm soát chất lượng');
