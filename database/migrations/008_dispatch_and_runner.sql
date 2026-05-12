-- Thêm cột outbound_shipment_id vào containers (liên kết với lô hàng xuất)
ALTER TABLE containers
ADD COLUMN IF NOT EXISTS outbound_shipment_id UUID REFERENCES outbound_shipments(id);

-- Thêm cột dispatched_at vào outbound_shipments (thời điểm dispatch thực tế)
ALTER TABLE outbound_shipments
ADD COLUMN IF NOT EXISTS dispatched_at TIMESTAMPTZ;

-- Index cho hiệu năng
CREATE INDEX IF NOT EXISTS idx_containers_outbound_shipment ON containers(outbound_shipment_id);
