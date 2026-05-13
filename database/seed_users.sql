-- database/seed_users.sql

-- 1. Ensure all permissions exist
INSERT INTO permissions (name) VALUES 
    ('inbound:receive'),
    ('sales:create_order'),
    ('dispatch:process'),
    ('manager:iot')
ON CONFLICT (name) DO NOTHING;

-- 2. Assign permissions to new roles
INSERT INTO role_permissions (role, permission_id)
SELECT 'INBOUND', id FROM permissions WHERE name IN ('inbound:create', 'inbound:read', 'inbound:receive')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'SALES', id FROM permissions WHERE name IN ('order:create', 'sales:create_order')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'DISPATCHER', id FROM permissions WHERE name IN ('dispatch:process')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'MANAGER', id FROM permissions WHERE name IN ('manager:iot')
ON CONFLICT DO NOTHING;

-- 3. Create template users (password is "admin123")
-- Hash for "admin123": $2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO
INSERT INTO users (id, username, role, password_hash) VALUES 
    ('d8e37e80-42c8-47ee-9e00-2aed32ab351e', 'admin01', 'ADMIN', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'inbound01', 'INBOUND', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'qa01', 'QA', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'sales01', 'SALES', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'picker01', 'PICKER', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'packer01', 'PACKER', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'dispatcher01', 'DISPATCHER', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO'),
    (gen_random_uuid(), 'manager01', 'MANAGER', '$2b$12$0G9xMxi628mm31IfRyWzvewrH6aEbSJOCK.xQx8WK8kfr1AOUAZeO')
ON CONFLICT (username) DO UPDATE SET 
    id = EXCLUDED.id,
    role = EXCLUDED.role,
    password_hash = EXCLUDED.password_hash;
