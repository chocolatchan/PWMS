# Orchestrator for PWMS Development Environment

.PHONY: db-up db-down migrate test-fefo reset-db seed fe-dev fe-build be-run dev fe-gen fe-clean fe-fix be-watch open-port lan-info

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
	@IP=$$(grep API_IP .env | cut -d '=' -f2) && \
	if [ "$$IP" = "0.0.0.0" ] || [ -z "$$IP" ]; then IP=$$(ip route get 1.1.1.1 | grep -oP 'src \K\S+'); fi && \
	if [ ! -z "$(API_IP)" ]; then IP=$(API_IP); fi && \
	echo "Connecting to API at: $$IP" && \
	cd frontend && fvm flutter run --dart-define=API_IP=$$IP

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

# 12. Mở cổng Firewall cho LAN
open-port:
	@if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active firewalld >/dev/null 2>&1; then \
		echo "Detected firewalld. Opening port 3000..." && \
		sudo firewall-cmd --add-port=3000/tcp --zone=public --permanent >/dev/null 2>&1 && \
		sudo firewall-cmd --reload >/dev/null 2>&1 && \
		echo "Port 3000 opened in firewalld."; \
	else \
		SUBNET=$$(ip route get 1.1.1.1 | awk '{print $$7}' | cut -d '.' -f1-3).0/24 && \
		echo "Checking iptables for port 3000 ($$SUBNET)..." && \
		if ! sudo iptables -C INPUT -p tcp -s $$SUBNET --dport 3000 -j ACCEPT 2>/dev/null; then \
			echo "Opening port 3000 for $$SUBNET in iptables..."; \
			sudo iptables -I INPUT 1 -p tcp -s $$SUBNET --dport 3000 -j ACCEPT; \
		else \
			echo "Port 3000 is already open in iptables."; \
		fi \
	fi

# 13. Chạy Backend
be-run: open-port
	@IP=$$(ip route get 1.1.1.1 | grep -oP 'src \K\S+') && \
	echo "Backend is public on LAN: $$IP:3000" && \
	cd backend && cargo run --bin backend

# 14. Chạy Backend với Auto-reload (Cần cargo-watch)
be-watch: open-port
	@IP=$$(ip route get 1.1.1.1 | grep -oP 'src \K\S+') && \
	echo "Backend is public on LAN: $$IP:3000" && \
	cd backend && cargo watch -x run

# 15. Chạy toàn bộ hệ thống Dev (Backend + Frontend)
dev: open-port
	@echo "Starting Backend and Frontend..."
	$(MAKE) -j 2 be-run fe-dev

# 16. Hiển thị hướng dẫn kết nối LAN cho thiết bị khác (Windows, PDA, v.v.)
lan-info:
	@IP=$$(ip route get 1.1.1.1 | grep -oP 'src \K\S+') && \
	echo "====================================================" && \
	echo "📱 HƯỚNG DẪN KẾT NỐI LAN" && \
	echo "====================================================" && \
	echo "1. Đảm bảo Backend đang chạy (make be-run)" && \
	echo "2. IP máy chủ hiện tại: $$IP" && \
	echo "" && \
	echo "3. Trên máy Windows của bạn, hãy chạy lệnh sau:" && \
	echo "   fvm flutter run -d windows --dart-define=API_IP=$$IP" && \
	echo "" && \
	echo "4. Nếu dùng trình duyệt web trên máy khác:" && \
	echo "   Truy cập http://$$IP:3000/api/health (để test kết nối)" && \
	echo "===================================================="
