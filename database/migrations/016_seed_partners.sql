-- Migration 016: Seed Partners (Suppliers)
INSERT INTO partners (partner_type, name, tax_code, address, phone, email) VALUES 
('supplier', 'Công ty Dược phẩm Mega Lifesciences', '0101234567', '364 Cộng Hòa, Tân Bình, TP.HCM', '0281234567', 'contact@mega.com'),
('supplier', 'Zuellig Pharma Vietnam', '0301234567', 'Khu Công Nghiệp Tân Tạo, Bình Tân, TP.HCM', '0287654321', 'info@zuelligpharma.com'),
('supplier', 'DKSH Vietnam Co., Ltd', '0302234567', '23 Lê Duẩn, Quận 1, TP.HCM', '0283822222', 'service@dksh.com')
ON CONFLICT DO NOTHING;
