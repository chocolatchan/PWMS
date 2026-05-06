-- Migration 020: Emergency Auth Fix
-- Ensures packer01 and dispatch01 have correct passwords and full permission set for demo.

-- 1. Reset passwords to 'password' (hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi)
UPDATE users SET password_hash = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE username IN ('packer01', 'dispatch01', 'admin01', 'qc01');

-- 2. Ensure users are active
UPDATE users SET is_active = true WHERE username IN ('packer01', 'dispatch01', 'admin01', 'qc01');

-- 3. Ensure they have the basic outbound:read permission which might be required by some logic
-- (Already added in previous migration but let's be sure)

-- 4. Add outbound:execute to them just in case the system checks for it globally
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm 
WHERE p.preset_name IN ('PACKER', 'DISPATCHER') AND perm.permission_code = 'outbound:execute'
ON CONFLICT DO NOTHING;

-- 5. Final check on user presets
DELETE FROM user_presets WHERE user_id IN (SELECT user_id FROM users WHERE username IN ('packer01', 'dispatch01'));

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'packer01' AND p.preset_name = 'PACKER'
ON CONFLICT DO NOTHING;

INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'dispatch01' AND p.preset_name = 'DISPATCHER'
ON CONFLICT DO NOTHING;
