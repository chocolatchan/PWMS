-- Migration 007: Seed Sample Users for Development
-- Password for all users is 'password'
-- Hash: $2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2

-- 1. Insert Sample Employees
INSERT INTO employees (employee_code, full_name, phone)
VALUES 
('EMP-001', 'Admin User', '0912345678'),
('EMP-002', 'Warehouse Staff', '0922334455'),
('EMP-003', 'Quality Assurance', '0933445566')
ON CONFLICT (employee_code) DO NOTHING;

-- 2. Insert Sample Users
INSERT INTO users (employee_id, username, password_hash)
VALUES 
((SELECT employee_id FROM employees WHERE employee_code = 'EMP-001'), 'admin', '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2'),
((SELECT employee_id FROM employees WHERE employee_code = 'EMP-002'), 'staff', '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2'),
((SELECT employee_id FROM employees WHERE employee_code = 'EMP-003'), 'qa', '$2b$12$G.aHxyuHfyHyE/7hkrSVfO2vq2g4PSOlneCqgTT4wkUw5WgeNAs/2')
ON CONFLICT (username) DO NOTHING;

-- 3. Assign Presets
-- Assign Admin
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id 
FROM users u, presets p 
WHERE u.username = 'admin' AND p.preset_name = 'Admin'
ON CONFLICT DO NOTHING;

-- Assign Staff
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id 
FROM users u, presets p 
WHERE u.username = 'staff' AND p.preset_name = 'Staff'
ON CONFLICT DO NOTHING;

-- Assign QA
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id 
FROM users u, presets p 
WHERE u.username = 'qa' AND p.preset_name = 'QA'
ON CONFLICT DO NOTHING;
