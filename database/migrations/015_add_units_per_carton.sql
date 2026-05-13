-- 015_add_units_per_carton.sql
ALTER TABLE products ADD COLUMN IF NOT EXISTS units_per_carton INT NOT NULL DEFAULT 1;

-- Seed conversion factors for existing products
UPDATE products SET units_per_carton = 48 WHERE name = 'Paracetamol 500mg';
UPDATE products SET units_per_carton = 10 WHERE name = 'Insulin Glargine';
UPDATE products SET units_per_carton = 24 WHERE name = 'Amoxicillin 250mg';
