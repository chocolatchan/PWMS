-- Migration 013: Seed V4 RBAC Presets and Permissions
-- This ensures the new roles needed for SOP V4.0 are available in the system

-- 1. Create missing Presets
INSERT INTO presets (preset_name, description) VALUES 
('INBOUND_STAFF', 'Nhân viên nhận hàng'),
('PUTAWAY_STAFF', 'Nhân viên cất hàng'),
('PICKER', 'Nhân viên nhặt hàng'),
('CHIEF_PHARMACIST', 'Thủ kho / Dược sĩ phụ trách'),
('WAREHOUSE_DIRECTOR', 'Giám đốc kho')
ON CONFLICT (preset_name) DO NOTHING;

-- 2. Link Permissions to New Presets
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
