-- Seed Inbound & Master Data for Development
-- This script adapts the user's request to the established schema

-- 1. Create missing Presets
INSERT INTO presets (preset_name, description) VALUES 
('INBOUND_STAFF', 'Nhân viên nhận hàng'),
('PUTAWAY_STAFF', 'Nhân viên cất hàng'),
('PICKER', 'Nhân viên nhặt hàng'),
('CHIEF_PHARMACIST', 'Thủ kho / Dược sĩ phụ trách'),
('WAREHOUSE_DIRECTOR', 'Giám đốc kho')
ON CONFLICT (preset_name) DO NOTHING;

-- 1.1 Link Permissions to New Presets
-- INBOUND_STAFF: Inbound read/write
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'INBOUND_STAFF' AND perm.permission_code IN ('inbound:read', 'inbound:write')
ON CONFLICT DO NOTHING;

-- PUTAWAY_STAFF: Putaway execute
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'PUTAWAY_STAFF' AND perm.permission_code IN ('inbound:read', 'putaway:execute')
ON CONFLICT DO NOTHING;

-- PICKER: Outbound read/execute
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'PICKER' AND perm.permission_code IN ('outbound:read', 'outbound:execute')
ON CONFLICT DO NOTHING;

-- CHIEF_PHARMACIST: High-level operations + Level 2 Approval
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'CHIEF_PHARMACIST' 
AND perm.permission_code IN ('inbound:read', 'inbound:write', 'qc:inspect', 'qc:release', 'outbound:read', 'outbound:execute', 'disposal:approve', 'putaway:execute')
ON CONFLICT DO NOTHING;

-- WAREHOUSE_DIRECTOR: All-access + Level 3 Approval + Admin
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'WAREHOUSE_DIRECTOR' 
AND perm.permission_code IN ('inbound:read', 'qc:release', 'outbound:read', 'recall:execute', 'disposal:approve', 'user:manage', 'audit:read')
ON CONFLICT DO NOTHING;

-- 2. Create Employees and Users
-- Password: password
-- Hash: $2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2

DO $$ 
DECLARE 
    v_emp_id INTEGER;
    v_user_id INTEGER;
BEGIN
    -- inbound01
    INSERT INTO employees (employee_code, full_name) VALUES ('EMP-INB-01', 'Nguyễn Inbound') 
    ON CONFLICT (employee_code) DO UPDATE SET full_name = EXCLUDED.full_name RETURNING employee_id INTO v_emp_id;
    INSERT INTO users (username, employee_id, password_hash) VALUES ('inbound01', v_emp_id, '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
    ON CONFLICT (username) DO UPDATE SET employee_id = EXCLUDED.employee_id RETURNING user_id INTO v_user_id;
    INSERT INTO user_presets (user_id, preset_id) SELECT v_user_id, preset_id FROM presets WHERE preset_name = 'INBOUND_STAFF' ON CONFLICT DO NOTHING;

    -- qa01
    INSERT INTO employees (employee_code, full_name) VALUES ('EMP-QA-01', 'Trần QA') 
    ON CONFLICT (employee_code) DO UPDATE SET full_name = EXCLUDED.full_name RETURNING employee_id INTO v_emp_id;
    INSERT INTO users (username, employee_id, password_hash) VALUES ('qa01', v_emp_id, '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
    ON CONFLICT (username) DO UPDATE SET employee_id = EXCLUDED.employee_id RETURNING user_id INTO v_user_id;
    INSERT INTO user_presets (user_id, preset_id) SELECT v_user_id, preset_id FROM presets WHERE preset_name = 'QA' ON CONFLICT DO NOTHING;

    -- putaway01
    INSERT INTO employees (employee_code, full_name) VALUES ('EMP-PUT-01', 'Lê Putaway') 
    ON CONFLICT (employee_code) DO UPDATE SET full_name = EXCLUDED.full_name RETURNING employee_id INTO v_emp_id;
    INSERT INTO users (username, employee_id, password_hash) VALUES ('putaway01', v_emp_id, '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
    ON CONFLICT (username) DO UPDATE SET employee_id = EXCLUDED.employee_id RETURNING user_id INTO v_user_id;
    INSERT INTO user_presets (user_id, preset_id) SELECT v_user_id, preset_id FROM presets WHERE preset_name = 'PUTAWAY_STAFF' ON CONFLICT DO NOTHING;

    -- picker01
    INSERT INTO employees (employee_code, full_name) VALUES ('EMP-PIC-01', 'Phạm Picker') 
    ON CONFLICT (employee_code) DO UPDATE SET full_name = EXCLUDED.full_name RETURNING employee_id INTO v_emp_id;
    INSERT INTO users (username, employee_id, password_hash) VALUES ('picker01', v_emp_id, '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
    ON CONFLICT (username) DO UPDATE SET employee_id = EXCLUDED.employee_id RETURNING user_id INTO v_user_id;
    INSERT INTO user_presets (user_id, preset_id) SELECT v_user_id, preset_id FROM presets WHERE preset_name = 'PICKER' ON CONFLICT DO NOTHING;

    -- chief01
    INSERT INTO employees (employee_code, full_name) VALUES ('EMP-CHI-01', 'Hoàng Thủ Kho') 
    ON CONFLICT (employee_code) DO UPDATE SET full_name = EXCLUDED.full_name RETURNING employee_id INTO v_emp_id;
    INSERT INTO users (username, employee_id, password_hash) VALUES ('chief01', v_emp_id, '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
    ON CONFLICT (username) DO UPDATE SET employee_id = EXCLUDED.employee_id RETURNING user_id INTO v_user_id;
    INSERT INTO user_presets (user_id, preset_id) SELECT v_user_id, preset_id FROM presets WHERE preset_name = 'CHIEF_PHARMACIST' ON CONFLICT DO NOTHING;

    -- director01
    INSERT INTO employees (employee_code, full_name) VALUES ('EMP-DIR-01', 'Võ Giám Đốc') 
    ON CONFLICT (employee_code) DO UPDATE SET full_name = EXCLUDED.full_name RETURNING employee_id INTO v_emp_id;
    INSERT INTO users (username, employee_id, password_hash) VALUES ('director01', v_emp_id, '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
    ON CONFLICT (username) DO UPDATE SET employee_id = EXCLUDED.employee_id RETURNING user_id INTO v_user_id;
    INSERT INTO user_presets (user_id, preset_id) SELECT v_user_id, preset_id FROM presets WHERE preset_name = 'WAREHOUSE_DIRECTOR' ON CONFLICT DO NOTHING;
END $$;

-- 3. Seed Partners
INSERT INTO partners (partner_id, partner_type, name, tax_code) VALUES
(1, 'supplier', 'Công ty Dược phẩm TW1', '01001010'),
(2, 'supplier', 'Dược Hậu Giang (DHG)', '01002020'),
(3, 'supplier', 'Sanofi Việt Nam', '01003030')
ON CONFLICT (partner_id) DO UPDATE SET name = EXCLUDED.name, tax_code = EXCLUDED.tax_code;

-- 4. Seed Locations
INSERT INTO locations (location_id, location_code, zone_type) VALUES
(1, 'STG-001', 'Quarantine'),
(2, 'STG-002', 'Quarantine'),
(3, 'TOX-001', 'Controlled')
ON CONFLICT (location_id) DO UPDATE SET zone_type = EXCLUDED.zone_type;

-- 5. Seed Products
INSERT INTO products (product_id, product_code, trade_name, packaging, base_unit) VALUES
(101, '893456700001', 'Paracetamol 500mg', 'Hộp 10 vỉ x 10 viên', 'Viên'),
(102, '893456700003', 'Morphine Sulfate', 'Ống tiêm', 'Ống')
ON CONFLICT (product_id) DO UPDATE SET trade_name = EXCLUDED.trade_name, packaging = EXCLUDED.packaging, base_unit = EXCLUDED.base_unit;
