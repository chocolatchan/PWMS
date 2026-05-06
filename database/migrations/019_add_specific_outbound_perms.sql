-- Migration 019: Add Specific Outbound Permissions
-- This allows distinguishing between Packing and Dispatch roles.

-- 1. Insert new permissions
INSERT INTO permissions (permission_code, description) VALUES 
('outbound:pack', 'Thực hiện đóng gói hàng hóa'),
('outbound:dispatch', 'Thực hiện xuất hàng và kiểm tra cổng')
ON CONFLICT (permission_code) DO NOTHING;

-- 2. Update PICKER preset to have both by default (for legacy support)
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'PICKER' AND perm.permission_code IN ('outbound:pack', 'outbound:dispatch')
ON CONFLICT DO NOTHING;

-- 3. Create specific Presets for Packer and Dispatcher
INSERT INTO presets (preset_name, description) VALUES 
('PACKER', 'Nhân viên đóng gói'),
('DISPATCHER', 'Nhân viên điều phối xuất hàng')
ON CONFLICT (preset_name) DO NOTHING;

-- 4. Assign specific permissions to new presets
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'PACKER' AND perm.permission_code IN ('outbound:read', 'outbound:pack')
ON CONFLICT DO NOTHING;

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name = 'DISPATCHER' AND perm.permission_code IN ('outbound:read', 'outbound:dispatch')
ON CONFLICT DO NOTHING;

-- 5. Update our test accounts to use these specific presets
DELETE FROM user_presets WHERE user_id IN (SELECT user_id FROM users WHERE username IN ('packer01', 'dispatch01'));

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'packer01' AND p.preset_name = 'PACKER'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'dispatch01' AND p.preset_name = 'DISPATCHER'
ON CONFLICT DO NOTHING;
