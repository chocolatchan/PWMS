-- Migration 008: Enhance Inbound Receipts
-- Thêm các trường thông tin từ Mockup vào bảng phiếu nhập kho

ALTER TABLE inbound_receipts 
ADD COLUMN invoice_no VARCHAR(100),
ADD COLUMN invoice_date DATE,
ADD COLUMN received_date DATE,
ADD COLUMN note TEXT;

-- Update status to support more states if needed
-- Status was already: DRAFT, PENDING_QC, COMPLETED, CANCELLED
