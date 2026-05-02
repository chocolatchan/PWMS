# Orchestrator for PWMS Development Environment

.PHONY: db-up db-down migrate test-fefo reset-db seed fe-dev fe-build be-run dev

# 1. Khởi động DB container (chạy ngầm)
db-up:
	docker-compose up -d

# 2. Tắt container và XÓA TOÀN BỘ VOLUMES (Clean sạch rác)
db-down:
	docker-compose down -v

# 3. Chạy migration cho Database
migrate:
	cargo sqlx database setup --source database/migrations

# 4. Chạy bài test 1 tỷ concurrency (FEFO allocation)
test-fefo:
	cargo test test_1_billion_concurrency -- --nocapture

# 5. Reset toàn bộ môi trường (Down -> Up -> Chờ -> Migrate)
reset-db: db-down db-up
	@echo "Waiting for PostgreSQL to start..."
	sleep 3
	$(MAKE) migrate

# 6. Nạp dữ liệu mẫu (Seeding)
seed:
	cargo test --test seed_data -- --nocapture

# 7. Chạy Frontend trong chế độ phát triển (Flutter)
fe-dev:
	cd frontend && fvm flutter run -d linux

# 8. Build Frontend cho Production
fe-build:
	cd frontend && fvm flutter build linux

# 9. Chạy toàn bộ hệ thống Dev (Backend + Frontend)
# Lưu ý: Cần mở 2 terminal hoặc chạy song song
dev:
	@echo "Starting Backend and Frontend..."
	$(MAKE) -j 2 be-run fe-dev

be-run:
	cd backend && cargo run --bin backend
