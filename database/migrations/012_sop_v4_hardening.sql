-- Migration 012: SOP V4.0 Hardening
-- Fills schema gaps for full GSP/GDP compliance per SOP V4.0

-- ============================================================
-- 1. APPROVAL CHAIN (3-Level Approval: QA → Thủ kho → GĐ)
-- ============================================================
CREATE TABLE approval_chain (
    approval_id SERIAL PRIMARY KEY,
    action_type VARCHAR(30) NOT NULL,  -- QC_RELEASE, QC_REJECT, RECALL, DISPOSAL
    entity_type VARCHAR(30) NOT NULL,  -- inbound_details, recall_actions
    entity_id INTEGER NOT NULL,        -- FK to the entity being approved
    
    -- Level 1: QA
    level1_user_id INTEGER REFERENCES users(user_id),
    level1_signed_at TIMESTAMP,
    level1_decision VARCHAR(20),       -- APPROVE, REJECT, HOLD
    
    -- Level 2: Thủ kho (CHIEF_PHARMACIST)
    level2_user_id INTEGER REFERENCES users(user_id),
    level2_signed_at TIMESTAMP,
    level2_decision VARCHAR(20),
    level2_on_behalf_of INTEGER REFERENCES users(user_id), -- Delegate tracking
    
    -- Level 3: GĐ (WAREHOUSE_DIRECTOR)
    level3_user_id INTEGER REFERENCES users(user_id),
    level3_signed_at TIMESTAMP,
    level3_decision VARCHAR(20),
    level3_on_behalf_of INTEGER REFERENCES users(user_id), -- Delegate tracking
    
    -- Final state
    final_status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED, CANCELLED
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_approval_chain_status ON approval_chain(final_status);
CREATE INDEX idx_approval_chain_entity ON approval_chain(entity_type, entity_id);

-- ============================================================
-- 2. RECALL ACTIONS (Emergency Recall with 3 signatures)
-- ============================================================
CREATE TABLE recall_actions (
    recall_id SERIAL PRIMARY KEY,
    batch_id INTEGER NOT NULL REFERENCES product_batches(batch_id),
    reason TEXT NOT NULL,               -- Công văn / Lý do thu hồi
    severity VARCHAR(20) NOT NULL DEFAULT 'CRITICAL', -- CRITICAL, WARNING
    
    -- Affected scope (populated at trigger time)
    affected_location_ids INTEGER[] DEFAULT '{}',
    affected_task_ids INTEGER[] DEFAULT '{}',
    affected_qty INTEGER DEFAULT 0,
    
    -- Status tracking
    status VARCHAR(20) DEFAULT 'INITIATED', -- INITIATED, LOCKED, APPROVED, COMPLETED
    initiated_by INTEGER NOT NULL REFERENCES users(user_id),
    approval_id INTEGER REFERENCES approval_chain(approval_id),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- ============================================================
-- 3. INTEGRATION OUTBOX (ERP Stub Webhook - Transactional Outbox Pattern)
-- ============================================================
CREATE TABLE integration_outbox (
    outbox_id SERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,    -- INBOUND_COMPLETED, QC_RELEASED, STOCK_UPDATED, RECALL_INITIATED
    payload JSONB NOT NULL,             -- Full event data
    target_system VARCHAR(50) DEFAULT 'ERP',
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, SENT, FAILED, SKIPPED
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    last_error TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP
);

CREATE INDEX idx_outbox_status ON integration_outbox(status, created_at);

-- ============================================================
-- 4. SCHEMA ENHANCEMENTS
-- ============================================================

-- 4a. [ĐÃ PATCH]: Thay vì dùng tote_color, ta liên kết trực tiếp Inbound Detail với cái Tote vật lý đang chứa nó
ALTER TABLE inbound_details
ADD COLUMN IF NOT EXISTS tote_id INTEGER REFERENCES totes(tote_id) ON DELETE SET NULL;

-- (Giữ nguyên các đoạn 4b, 4c, 4d, 4e...)

-- 4b. Add is_return flag to inbound_details
ALTER TABLE inbound_details
ADD COLUMN IF NOT EXISTS is_return BOOLEAN DEFAULT FALSE;

-- 4c. Add LASA single-pick flag to picking_tasks
ALTER TABLE picking_tasks
ADD COLUMN IF NOT EXISTS is_lasa_single_pick BOOLEAN DEFAULT FALSE;

-- 4d. Add priority to picking_tasks (if not exists)
ALTER TABLE picking_tasks
ADD COLUMN IF NOT EXISTS priority INTEGER DEFAULT 0;

-- 4e. Add has_photo for LASA audit
ALTER TABLE picking_tasks
ADD COLUMN IF NOT EXISTS has_lasa_photo BOOLEAN DEFAULT FALSE;

-- ============================================================
-- 5. SEED ZONE LOCATIONS (Z-REJ, Z-RCL, Z-RET, Z-LAS)
-- ============================================================
INSERT INTO locations (location_code, location_name, zone_type) VALUES
('REJ-001', 'Khu Loại/Hủy 01', 'Rejected'),
('RCL-001', 'Khu Thu hồi 01', 'Recalled'),
('RET-001', 'Khu Trả về 01', 'Returns'),
('LAS-001', 'Khu LASA 01', 'LASA'),
('LAS-002', 'Khu LASA 02', 'LASA'),
('AVL-001', 'Kệ thường 01', 'Released'),
('AVL-002', 'Kệ thường 02', 'Released'),
('CLD-001', 'Tủ lạnh 01', 'Cold')
ON CONFLICT (location_code) DO NOTHING;

-- ============================================================
-- 6. AUDIT TRIGGERS
-- ============================================================
CREATE TRIGGER audit_approval_chain_trigger
AFTER INSERT OR UPDATE OR DELETE ON approval_chain
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_recall_actions_trigger
AFTER INSERT OR UPDATE OR DELETE ON recall_actions
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();

CREATE TRIGGER audit_integration_outbox_trigger
AFTER INSERT OR UPDATE OR DELETE ON integration_outbox
FOR EACH ROW EXECUTE FUNCTION audit_trigger_func();
