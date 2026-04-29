-- GSP/GDP extensions
CREATE TABLE dispatch_records (
    dispatch_id SERIAL PRIMARY KEY,
    task_id INTEGER, -- Link to warehouse_tasks later
    vehicle_plate VARCHAR(20),
    driver_name VARCHAR(100),
    truck_temp_before DECIMAL(5,2),
    seal_number VARCHAR(50),
    gate_pass_signed BOOLEAN DEFAULT FALSE,
    dispatch_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE return_receipts (
    return_id SERIAL PRIMARY KEY,
    original_invoice VARCHAR(50),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'PENDING_QA', -- PENDING_QA, RE_LABELED, REJECTED
    returned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE calibration_logs (
    log_id SERIAL PRIMARY KEY,
    device_id VARCHAR(50),
    prev_value DECIMAL(10,2),
    new_value DECIMAL(10,2),
    calibrated_by INTEGER REFERENCES users(user_id),
    certificate_url TEXT,
    next_due_date DATE,
    calibrated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add new roles to seed
INSERT INTO roles (role_name) VALUES 
('Returns Handler'), 
('Dispatch Specialist'), 
('Technical Admin'), 
('Compliance Auditor');
