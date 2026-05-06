-- Migration 018: Seed Operational Accounts for Demo
-- This adds specific accounts for each module to facilitate easier testing/demo.

-- 1. Create more employee records
INSERT INTO employees (employee_code, full_name) VALUES 
('EMP-PACK-01', 'Nguyen Van Pack'),
('EMP-DISP-01', 'Le Thi Dispatch'),
('EMP-ADMIN-01', 'Admin Master'),
('EMP-QC-01', 'QC Inspector 01')
ON CONFLICT (employee_code) DO NOTHING;

-- 2. Insert users with standard password 'password123' (hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi)
INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'packer01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-PACK-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'dispatch01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-DISP-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'admin01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-ADMIN-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'qc01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-QC-01'
ON CONFLICT (username) DO NOTHING;

-- 3. Assign Presets to Users
-- Packer & Dispatcher use PICKER preset (which has outbound:execute)
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'packer01' AND p.preset_name = 'PICKER'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'dispatch01' AND p.preset_name = 'PICKER'
ON CONFLICT DO NOTHING;

-- Admin uses WAREHOUSE_DIRECTOR
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'admin01' AND p.preset_name = 'WAREHOUSE_DIRECTOR'
ON CONFLICT DO NOTHING;

-- QC Inspector uses CHIEF_PHARMACIST (which has qc:inspect)
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'qc01' AND p.preset_name = 'CHIEF_PHARMACIST'
ON CONFLICT DO NOTHING;
