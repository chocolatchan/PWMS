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
-- Hash: $2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.
INSERT INTO users (username, role, password_hash) VALUES 
    ('admin01', 'ADMIN', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('inbound01', 'INBOUND', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('qa01', 'QA', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('sales01', 'SALES', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('picker01', 'PICKER', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('packer01', 'PACKER', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('dispatcher01', 'DISPATCHER', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'),
    ('manager01', 'MANAGER', '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.')
ON CONFLICT (username) DO NOTHING;
