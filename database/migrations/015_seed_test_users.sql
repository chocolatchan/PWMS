-- Migration 015: Seed Test Users
-- Create employee records first
INSERT INTO employees (employee_code, full_name) VALUES 
('EMP-INB-01', 'Inbound Staff 01'),
('EMP-QA-01', 'QA Staff 01'),
('EMP-MGT-01', 'Chief Pharmacist 01'),
('EMP-PUT-01', 'Putaway Staff 01'),
('EMP-PIC-01', 'Picking Staff 01')
ON CONFLICT (employee_code) DO NOTHING;

-- Insert users
INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'inbound01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-INB-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'qa01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-QA-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'chief01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-MGT-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'putaway01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-PUT-01'
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (employee_id, username, password_hash, is_active)
SELECT employee_id, 'picker01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', true 
FROM employees WHERE employee_code = 'EMP-PIC-01'
ON CONFLICT (username) DO NOTHING;

-- Assign Presets to Users
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'inbound01' AND p.preset_name = 'INBOUND_STAFF'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'qa01' AND p.preset_name = 'CHIEF_PHARMACIST'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'chief01' AND p.preset_name = 'WAREHOUSE_DIRECTOR'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'putaway01' AND p.preset_name = 'PUTAWAY_STAFF'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'picker01' AND p.preset_name = 'PICKER'
ON CONFLICT DO NOTHING;
