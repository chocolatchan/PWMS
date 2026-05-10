-- Migration 022: Cleanup RBAC - Strict Permission Scoping
-- Each account should only see modules relevant to their actual role.
-- ═══════════════════════════════════════════════════════════════════
-- ACCOUNT     → PRESET             → PERMISSIONS            → DASHBOARD MODULES
-- ────────────────────────────────────────────────────────────────────────────────
-- inbound01   → INBOUND_STAFF      → inbound:read/write     → Nhập Hàng
-- qa01        → QC_INSPECTOR       → qc:inspect             → Kiểm Tra CL
-- qc01        → QC_INSPECTOR       → qc:inspect             → Kiểm Tra CL
-- chief01     → CHIEF_PHARMACIST   → qc:release, disposal   → Phê Duyệt
-- putaway01   → PUTAWAY_STAFF      → putaway:execute        → Cất Kệ
-- picker01    → PICKER             → outbound:execute       → Nhặt Hàng
-- packer01    → PACKER             → outbound:pack/read     → Đóng Gói
-- dispatch01  → DISPATCHER         → outbound:dispatch/read → Xuất Hàng
-- admin01     → WAREHOUSE_DIRECTOR → recall, audit, dispose → Returns, Tower, Phê Duyệt
-- ═══════════════════════════════════════════════════════════════════

-- ── Step 1: Create QC_INSPECTOR preset ──────────────────────────
INSERT INTO presets (preset_name, description) VALUES
('QC_INSPECTOR', 'Nhân viên kiểm tra chất lượng (chỉ QC)')
ON CONFLICT (preset_name) DO NOTHING;

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'QC_INSPECTOR' AND perm.permission_code = 'qc:inspect'
ON CONFLICT DO NOTHING;

-- ── Step 2: Trim CHIEF_PHARMACIST → only approval perms ─────────
DELETE FROM preset_permissions 
WHERE preset_id = (SELECT preset_id FROM presets WHERE preset_name = 'CHIEF_PHARMACIST');

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'CHIEF_PHARMACIST' 
AND perm.permission_code IN ('qc:release', 'disposal:approve')
ON CONFLICT DO NOTHING;

-- ── Step 3: Trim PICKER → only outbound:execute ─────────────────
DELETE FROM preset_permissions 
WHERE preset_id = (SELECT preset_id FROM presets WHERE preset_name = 'PICKER');

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'PICKER' AND perm.permission_code = 'outbound:execute'
ON CONFLICT DO NOTHING;

-- ── Step 4: Trim PACKER → only outbound:pack + read ─────────────
DELETE FROM preset_permissions 
WHERE preset_id = (SELECT preset_id FROM presets WHERE preset_name = 'PACKER');

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'PACKER' AND perm.permission_code IN ('outbound:read', 'outbound:pack')
ON CONFLICT DO NOTHING;

-- ── Step 5: Trim DISPATCHER → only outbound:dispatch + read ─────
DELETE FROM preset_permissions 
WHERE preset_id = (SELECT preset_id FROM presets WHERE preset_name = 'DISPATCHER');

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'DISPATCHER' AND perm.permission_code IN ('outbound:read', 'outbound:dispatch')
ON CONFLICT DO NOTHING;

-- ── Step 6: Trim PUTAWAY_STAFF → only putaway:execute ───────────
DELETE FROM preset_permissions 
WHERE preset_id = (SELECT preset_id FROM presets WHERE preset_name = 'PUTAWAY_STAFF');

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'PUTAWAY_STAFF' AND perm.permission_code = 'putaway:execute'
ON CONFLICT DO NOTHING;

-- ── Step 7: Trim WAREHOUSE_DIRECTOR → admin, recall, approval ───
DELETE FROM preset_permissions 
WHERE preset_id = (SELECT preset_id FROM presets WHERE preset_name = 'WAREHOUSE_DIRECTOR');

INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id FROM presets p, permissions perm
WHERE p.preset_name = 'WAREHOUSE_DIRECTOR'
AND perm.permission_code IN ('recall:execute', 'disposal:approve', 'audit:read', 'user:manage')
ON CONFLICT DO NOTHING;

-- ── Step 8: Reassign user → preset mappings ─────────────────────
-- qa01 → QC_INSPECTOR
DELETE FROM user_presets WHERE user_id = (SELECT user_id FROM users WHERE username = 'qa01');
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'qa01' AND p.preset_name = 'QC_INSPECTOR'
ON CONFLICT DO NOTHING;

-- qc01 → QC_INSPECTOR
DELETE FROM user_presets WHERE user_id = (SELECT user_id FROM users WHERE username = 'qc01');
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'qc01' AND p.preset_name = 'QC_INSPECTOR'
ON CONFLICT DO NOTHING;

-- chief01 → CHIEF_PHARMACIST (not WAREHOUSE_DIRECTOR)
DELETE FROM user_presets WHERE user_id = (SELECT user_id FROM users WHERE username = 'chief01');
INSERT INTO user_presets (user_id, preset_id)
SELECT u.user_id, p.preset_id FROM users u, presets p
WHERE u.username = 'chief01' AND p.preset_name = 'CHIEF_PHARMACIST'
ON CONFLICT DO NOTHING;
