-- 014_add_barcode_to_products.sql
ALTER TABLE products ADD COLUMN IF NOT EXISTS barcode VARCHAR UNIQUE;

-- Seed barcodes for existing products (GTIN-14 format with leading zero for EAN-13)
UPDATE products SET barcode = '08930000000001' WHERE name = 'Paracetamol 500mg';
UPDATE products SET barcode = '08930000000002' WHERE name = 'Insulin Glargine';
UPDATE products SET barcode = '08930000000003' WHERE name = 'Amoxicillin 500mg';
