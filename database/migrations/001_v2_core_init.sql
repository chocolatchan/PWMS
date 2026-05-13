-- =============================================================
-- PWMS V2 CORE INITIALIZATION (FRESH START)
-- =============================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. ENUMS
CREATE TYPE inbound_status AS ENUM ('ARRIVED', 'IN_QUARANTINE', 'QC_IN_PROGRESS', 'COMPLETED');
CREATE TYPE batch_status AS ENUM ('RECEIVED', 'QC_PENDING', 'QC_DONE');
CREATE TYPE temp_zone AS ENUM ('AMBIENT', 'CHILLED', 'COLD');
CREATE TYPE qc_decision AS ENUM ('APPROVED', 'REJECTED');
CREATE TYPE location_zone_type AS ENUM ('QUARANTINE', 'ACCEPTED_INV', 'REJECTED_INV', 'PACKING', 'OUTBOUND_LANE');
CREATE TYPE inventory_status AS ENUM ('QUARANTINE', 'AVAILABLE', 'RESERVED', 'REJECTED');
CREATE TYPE container_status AS ENUM ('PICKING', 'AT_INV_GATE', 'IN_TRANSIT', 'AT_PACKING', 'PACKED');
CREATE TYPE task_status AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'FAILED');
CREATE TYPE trip_type AS ENUM ('INTERNAL', 'OUTBOUND', 'EXTERNAL');

-- 3. CORE TABLES
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR UNIQUE NOT NULL,
    role VARCHAR NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR NOT NULL,
    is_lasa BOOLEAN NOT NULL DEFAULT FALSE,
    lasa_group VARCHAR,
    temp_zone temp_zone NOT NULL
);

CREATE TABLE locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    zone_code VARCHAR NOT NULL,
    zone_type location_zone_type NOT NULL,
    is_full BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_name VARCHAR NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. INBOUND & QC
CREATE TABLE inbound_shipments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    po_number VARCHAR NOT NULL,
    vehicle_seal_number VARCHAR NULL,
    arrival_temperature DECIMAL NULL,
    data_logger_id VARCHAR NULL,
    status inbound_status NOT NULL DEFAULT 'ARRIVED'
);

CREATE TABLE inbound_batches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inbound_shipment_id UUID NOT NULL REFERENCES inbound_shipments(id),
    current_status batch_status NOT NULL DEFAULT 'RECEIVED'
);

CREATE TABLE qc_inspections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inbound_batch_id UUID NOT NULL REFERENCES inbound_batches(id),
    qa_staff_id UUID NOT NULL REFERENCES users(id),
    min_temp DECIMAL NULL,
    max_temp DECIMAL NULL,
    deviation_report_id VARCHAR NULL,
    decision qc_decision NOT NULL
);

-- 5. INVENTORY
CREATE TABLE inventory_balances (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id),
    location_id UUID NOT NULL REFERENCES locations(id),
    inbound_batch_id UUID NOT NULL REFERENCES inbound_batches(id),
    batch_number VARCHAR NOT NULL,
    expiry_date DATE NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    status inventory_status NOT NULL DEFAULT 'QUARANTINE'
);

-- 6. OUTBOUND & FULFILLMENT
CREATE TABLE outbound_shipments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id),
    vehicle_seal_number VARCHAR NULL,
    dispatch_temperature DECIMAL NULL
);

CREATE TABLE containers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) NOT NULL,
    current_status container_status NOT NULL DEFAULT 'PICKING',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pick_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    container_id UUID NOT NULL REFERENCES containers(id),
    product_id UUID REFERENCES products(id),
    batch_number VARCHAR NOT NULL,
    required_qty INT NOT NULL CHECK (required_qty > 0),
    picked_qty INT DEFAULT 0 CHECK (picked_qty >= 0 AND picked_qty <= required_qty),
    picker_id UUID REFERENCES users(id),
    status task_status DEFAULT 'PENDING'
);

CREATE TABLE runner_trips (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    runner_id UUID REFERENCES users(id) NOT NULL,
    trip_type trip_type NOT NULL,
    status task_status DEFAULT 'IN_PROGRESS',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ
);

CREATE TABLE trip_containers (
    trip_id UUID REFERENCES runner_trips(id) ON DELETE CASCADE,
    container_id UUID REFERENCES containers(id) ON DELETE CASCADE,
    PRIMARY KEY (trip_id, container_id)
);

CREATE TABLE pack_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    container_id UUID NOT NULL REFERENCES containers(id),
    packer_id UUID REFERENCES users(id),
    status task_status DEFAULT 'PENDING',
    packed_at TIMESTAMPTZ
);

-- 7. AUDIT & CQRS
CREATE TABLE outbox_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type VARCHAR NOT NULL,
    payload JSONB NOT NULL,
    processed BOOLEAN NOT NULL DEFAULT FALSE
);

-- 8. SEED DATA (INITIAL SETUP)
INSERT INTO users (username, role) VALUES 
('admin01', 'ADMIN'),
('qa01', 'QA'),
('picker01', 'PICKER'),
('packer01', 'PACKER'),
('runner01', 'RUNNER');

INSERT INTO products (id, name, is_lasa, temp_zone) VALUES 
('11111111-1111-1111-1111-111111111111', 'Paracetamol 500mg', false, 'AMBIENT'),
('22222222-2222-2222-2222-222222222222', 'Insulin Glargine', false, 'COLD'),
('33333333-3333-3333-3333-333333333333', 'Amoxicillin 250mg', true, 'AMBIENT');

INSERT INTO locations (id, zone_code, zone_type) VALUES 
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'QRN-A1', 'QUARANTINE'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'ACC-B1', 'ACCEPTED_INV'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'REJ-C1', 'REJECTED_INV'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'PCK-D1', 'PACKING'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'OUT-E1', 'OUTBOUND_LANE');
