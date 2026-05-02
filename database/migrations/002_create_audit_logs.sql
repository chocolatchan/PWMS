-- Migration 002: Audit Trail System
-- Cấu trúc bảng lưu trữ lịch sử thay đổi dữ liệu (Trigger-based)

CREATE TABLE audit_logs (
    log_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    old_data JSONB,              -- NULL nếu là INSERT
    new_data JSONB,              -- NULL nếu là DELETE
    changed_by INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index để query nhanh theo bảng hoặc bản ghi
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX idx_audit_logs_changed_at ON audit_logs(changed_at);

-- Chặn quyền DELETE/UPDATE trên bảng audit_logs để đảm bảo tính bất biến (GSP/GDP)
DO $$
BEGIN
    CREATE OR REPLACE FUNCTION block_audit_modification()
    RETURNS TRIGGER AS $body$
    BEGIN
        RAISE EXCEPTION 'Audit logs are immutable and cannot be modified or deleted.';
    END;
    $body$ LANGUAGE plpgsql;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'prevent_audit_modification') THEN
        CREATE TRIGGER prevent_audit_modification
        BEFORE UPDATE OR DELETE ON audit_logs
        FOR EACH STATEMENT
        EXECUTE FUNCTION block_audit_modification();
    END IF;
END $$;

-- Generic Function để capture Audit Trail
CREATE OR REPLACE FUNCTION audit_trigger_func()
RETURNS TRIGGER AS $body$
DECLARE
    v_old_data JSONB := NULL;
    v_new_data JSONB := NULL;
    v_record_id INTEGER;
    v_user_id INTEGER;
BEGIN
    -- Lấy ID người dùng từ session variable 'app.current_user_id'
    -- (Thiết lập bởi ứng dụng Axum trước mỗi transaction)
    BEGIN
        v_user_id := NULLIF(current_setting('app.current_user_id', true), '')::INTEGER;
    EXCEPTION WHEN OTHERS THEN
        v_user_id := NULL;
    END;

    IF (TG_OP = 'INSERT') THEN
        v_new_data := to_jsonb(NEW);
        
        -- Lấy ID của bản ghi (Giả định PK là cột đầu tiên hoặc lấy từ schema)
        v_record_id := (v_new_data->(
            SELECT a.attname
            FROM pg_index i
            JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE i.indrelid = TG_RELID AND i.indisprimary
            LIMIT 1
        ))::TEXT::INTEGER;

        INSERT INTO audit_logs (table_name, record_id, action, new_data, changed_by)
        VALUES (TG_TABLE_NAME, v_record_id, 'INSERT', v_new_data, v_user_id);
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN
        v_old_data := to_jsonb(OLD);
        v_new_data := to_jsonb(NEW);
        
        -- Chỉ ghi log nếu dữ liệu thực sự thay đổi
        IF (v_old_data = v_new_data) THEN
            RETURN NEW;
        END IF;

        v_record_id := (v_new_data->(
            SELECT a.attname
            FROM pg_index i
            JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE i.indrelid = TG_RELID AND i.indisprimary
            LIMIT 1
        ))::TEXT::INTEGER;

        INSERT INTO audit_logs (table_name, record_id, action, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, v_record_id, 'UPDATE', v_old_data, v_new_data, v_user_id);
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := to_jsonb(OLD);
        
        v_record_id := (v_old_data->(
            SELECT a.attname
            FROM pg_index i
            JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE i.indrelid = TG_RELID AND i.indisprimary
            LIMIT 1
        ))::TEXT::INTEGER;

        INSERT INTO audit_logs (table_name, record_id, action, old_data, changed_by)
        VALUES (TG_TABLE_NAME, v_record_id, 'DELETE', v_old_data, v_user_id);
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$body$ LANGUAGE plpgsql;

-- Áp dụng Audit Trigger cho các bảng liên quan đến Auth
CREATE TRIGGER audit_users_trigger
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_user_presets_trigger
AFTER INSERT OR UPDATE OR DELETE ON user_presets
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
