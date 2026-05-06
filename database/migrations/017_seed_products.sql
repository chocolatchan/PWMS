-- Migration 017: Seed Products
INSERT INTO products (product_code, trade_name, base_unit, is_toxic, is_lasa) VALUES 
('P001', 'Paracetamol 500mg', 'Viên', false, false),
('P002', 'Amoxicillin 500mg', 'Viên', false, false),
('P003', 'Fentanyl Patch 25mcg/h', 'Miếng', true, false)
ON CONFLICT (product_code) DO NOTHING;
