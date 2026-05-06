-- Migration 009: Seed RBAC Permissions
-- This maps the database to the AppPermissions constants in the Flutter frontend

-- 1. Insert Granular Permissions
INSERT INTO permissions (permission_code, description) VALUES 
('inbound:read', 'Xem danh sách nhập kho'),
('inbound:write', 'Tạo/Sửa phiếu nhập kho'),
('qc:inspect', 'Thực hiện kiểm tra chất lượng'),
('qc:release', 'Phê duyệt giải phóng hàng'),
('outbound:read', 'Xem danh sách xuất kho'),
('outbound:execute', 'Thực hiện xuất kho'),
('recall:execute', 'Thực hiện thu hồi hàng loạt'),
('disposal:approve', 'Phê duyệt tiêu hủy'),
('user:manage', 'Quản lý người dùng'),
('audit:read', 'Xem nhật ký hệ thống'),
('putaway:execute', 'Thực hiện cất hàng (Putaway)')
ON CONFLICT (permission_code) DO NOTHING;

-- 2. Link Permissions to Presets
-- Admin: All permissions
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id 
FROM presets p, permissions perm 
WHERE p.preset_name = 'Admin'
ON CONFLICT DO NOTHING;

-- Staff: Inbound & Outbound read/write
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id 
FROM presets p, permissions perm 
WHERE p.preset_name = 'Staff' 
AND perm.permission_code IN ('inbound:read', 'inbound:write', 'outbound:read', 'outbound:execute', 'putaway:execute')
ON CONFLICT DO NOTHING;

-- QA: QC Inspection & Release
INSERT INTO preset_permissions (preset_id, permission_id)
SELECT p.preset_id, perm.permission_id 
FROM presets p, permissions perm 
WHERE p.preset_name = 'QA' 
AND perm.permission_code IN ('qc:inspect', 'qc:release', 'inbound:read')
ON CONFLICT DO NOTHING;
