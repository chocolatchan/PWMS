# Orchestrator for PWMS Development Environment

.PHONY: db-up db-down migrate test-fefo reset-db seed fe-dev fe-build be-run dev fe-gen fe-clean fe-fix be-watch

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

# 9. Code Generation (Riverpod, Freezed, etc.)
fe-gen:
	cd frontend && fvm dart run build_runner build --delete-conflicting-outputs

# 10. Deep Clean Frontend
fe-clean:
	cd frontend && fvm flutter clean && fvm flutter pub get

# 11. "The Nuclear Option" - Clean, Get, Gen
fe-fix: fe-clean fe-gen

# 12. Chạy Backend
be-run:
	cd backend && cargo run --bin backend

# 13. Chạy Backend với Auto-reload (Cần cargo-watch)
be-watch:
	cd backend && cargo watch -x run

# 14. Chạy toàn bộ hệ thống Dev (Backend + Frontend)
dev:
	@echo "Starting Backend and Frontend..."
	$(MAKE) -j 2 be-run fe-dev
