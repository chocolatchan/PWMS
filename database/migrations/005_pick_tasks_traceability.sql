-- Migration 005: Add inventory_balance_id to pick_tasks for strict inventory tracking
ALTER TABLE pick_tasks 
ADD COLUMN inventory_balance_id UUID REFERENCES inventory_balances(id);

-- Add index for performance
CREATE INDEX idx_pick_tasks_inv_balance_id ON pick_tasks(inventory_balance_id);
