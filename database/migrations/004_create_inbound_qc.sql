-- Migration 004: Inbound & QC Workflow
-- Định nghĩa quy trình nhập kho và kiểm soát chất lượng (GSP)

-- 1. Bảng đối tác (Nhà cung cấp / Khách hàng)
CREATE TABLE partners (
    partner_id SERIAL PRIMARY KEY,
    partner_type VARCHAR(20) NOT NULL, -- supplier, customer
    name VARCHAR(255) NOT NULL,
    tax_code VARCHAR(50),
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Phiếu nhập kho (Inbound Receipts)
CREATE TABLE inbound_receipts (
    receipt_id SERIAL PRIMARY KEY,
    receipt_number VARCHAR(50) NOT NULL UNIQUE,
    supplier_id INTEGER NOT NULL REFERENCES partners(partner_id),
    receipt_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT', -- DRAFT, PENDING_QC, COMPLETED, CANCELLED
    created_by INTEGER REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Chi tiết phiếu nhập
CREATE TABLE inbound_details (
    detail_id SERIAL PRIMARY KEY,
    receipt_id INTEGER NOT NULL REFERENCES inbound_receipts(receipt_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    batch_id INTEGER NOT NULL REFERENCES product_batches(batch_id),
    declared_qty INTEGER NOT NULL,
    actual_qty INTEGER,
    gate_note TEXT,
    quarantine_location_id INTEGER REFERENCES locations(location_id)
);

-- 4. Kiểm tra chất lượng (QC Inspections)
CREATE TABLE qc_inspections (
    inspection_id SERIAL PRIMARY KEY,
    detail_id INTEGER NOT NULL UNIQUE REFERENCES inbound_details(detail_id) ON DELETE CASCADE,
    inspected_by INTEGER NOT NULL REFERENCES users(user_id),
    inspection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    passed_qty INTEGER NOT NULL,
    failed_qty INTEGER NOT NULL,
    notes TEXT,
    is_signed BOOLEAN DEFAULT FALSE -- E-Sign flag
);

-- Gắn Audit Trigger cho các bảng nhạy cảm trong luồng nhập
CREATE TRIGGER audit_inbound_receipts_trigger
AFTER INSERT OR UPDATE OR DELETE ON inbound_receipts
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_qc_inspections_trigger
AFTER INSERT OR UPDATE OR DELETE ON qc_inspections
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

-- Separation of Duties (SoD) Trigger
-- Đảm bảo người kiểm tra (QA) không được là người tạo phiếu nhập (Staff/Admin)
CREATE OR REPLACE FUNCTION check_sod_qc_inspection()
RETURNS TRIGGER AS $body$
DECLARE
    v_receipt_creator_id INTEGER;
BEGIN
    SELECT ir.created_by INTO v_receipt_creator_id
    FROM inbound_receipts ir
    JOIN inbound_details id ON ir.receipt_id = id.receipt_id
    WHERE id.detail_id = NEW.detail_id;

    IF (NEW.inspected_by = v_receipt_creator_id) THEN
        RAISE EXCEPTION 'Separation of Duties violation: The person who created the receipt cannot be the same person who performs the QC inspection.';
    END IF;

    RETURN NEW;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER sod_qc_inspection_trigger
BEFORE INSERT OR UPDATE ON qc_inspections
FOR EACH ROW EXECUTE FUNCTION check_sod_qc_inspection();
