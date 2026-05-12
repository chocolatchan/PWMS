-- database/migrations/007_add_auth.sql

-- Add password_hash column to users
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255) NOT NULL DEFAULT '';

-- Add index on username for fast lookup
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Add a table for permissions
CREATE TABLE IF NOT EXISTS permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL UNIQUE
);

-- Role-permission mapping
CREATE TABLE IF NOT EXISTS role_permissions (
    role VARCHAR NOT NULL,
    permission_id UUID NOT NULL REFERENCES permissions(id),
    PRIMARY KEY (role, permission_id)
);

-- Preload some basic permissions
INSERT INTO permissions (name) VALUES 
    ('inbound:create'),
    ('inbound:read'),
    ('qc:submit'),
    ('order:create'),
    ('order:allocate'),
    ('pick:scan'),
    ('pack:complete'),
    ('runner:move'),
    ('admin:users')
ON CONFLICT (name) DO NOTHING;

-- Pre-assign permissions to roles
INSERT INTO role_permissions (role, permission_id)
SELECT 'ADMIN', id FROM permissions
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'QA', id FROM permissions WHERE name IN ('inbound:read', 'qc:submit')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'PICKER', id FROM permissions WHERE name IN ('order:allocate', 'pick:scan')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'PACKER', id FROM permissions WHERE name IN ('pack:complete')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role, permission_id)
SELECT 'RUNNER', id FROM permissions WHERE name IN ('runner:move')
ON CONFLICT DO NOTHING;

-- Update existing default users with bcrypt hash for "admin123" (cost 10)
UPDATE users 
SET password_hash = '$2b$10$tOOni30QG93TjO381/S2yOHyLIs/R5o1Y.sJ7J9D9P7jQ52Z0qSj.'
WHERE password_hash = '';
