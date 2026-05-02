#!/bin/bash

# Dừng script ngay lập tức nếu có lệnh nào bị lỗi
set -e

echo "=== 1. Thiết lập thông số Database ==="
DB_USER="pharma_admin"
DB_PASS="pharma_secret_123"
DB_NAME="wms_pharma_dev"

echo "=== 2. Khởi tạo Role và Database gốc (Yêu cầu quyền sudo) ==="
# Dùng sudo -u postgres để bypass peer authentication trên Linux
# Dùng || true để không văng lỗi nếu User/DB đã tồn tại từ trước
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS' CREATEDB;" || true
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" || true

echo "=== 3. Cấu hình biến môi trường ==="
# Ghi vào file .env trong thư mục backend để app nhận được
export DATABASE_URL="postgres://$DB_USER:$DB_PASS@localhost:5432/$DB_NAME"
echo "DATABASE_URL=$DATABASE_URL" > backend/.env
echo "Đã tạo file backend/.env thành công."

echo "=== 4. Cấu hình môi trường và kiểm tra sqlx-cli ==="
source "$HOME/.cargo/env"

if ! command -v sqlx &> /dev/null
then
    echo "Chưa có sqlx-cli, đang tiến hành cài đặt..."
    cargo install sqlx-cli --no-default-features --features rustls,postgres
fi

echo "=== 5. Đổ bê tông (Migration) cho Dev DB ==="
# Chuyển vào thư mục backend và trỏ migration tới folder database/migrations
cd backend
sqlx database setup --source ../database/migrations

echo "=== 6. KÍCH NỔ BÀI TEST 1 TỶ ==="
cargo test test_1_billion_concurrency -- --nocapture