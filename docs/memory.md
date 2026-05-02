# Project Memory: WMS Pharma (Audit & Database Strategy)

## Cạm bẫy (Pitfalls)

*   **Transaction Deadlock**: Khi sử dụng Trigger để tự động cập nhật `inventory_balances`, nếu nhiều người cùng thực hiện xuất hàng một lúc, hệ thống rất dễ bị deadlock do tranh chấp row-level lock.
    *   **Giải pháp**: Luôn sắp xếp việc cập nhật theo một thứ tự nhất định (ví dụ: theo ID sản phẩm hoặc ID vị trí tăng dần) trong transaction để tránh vòng lặp khóa.
*   **Timezone Mess**: Đảm bảo tất cả các cột datetime đều là `TIMESTAMP WITH TIME ZONE`. Đừng để đến lúc xuất báo cáo GSP mới phát hiện hàng "hết hạn sớm" hoặc nhập kho "ở tương lai" vì lệch múi giờ giữa Server, DB và Client.
*   **Recursive Triggers**: Cẩn thận khi viết trigger mà bên trong lại gọi lệnh update chính bảng đó, dễ dẫn đến vòng lặp vô hạn.
*   **Schema Evolution**: Khi cấu trúc bảng thay đổi, dữ liệu JSONB cũ trong Audit Log có thể không còn khớp với struct hiện tại. Cần có chiến lược versioning cho dữ liệu Audit.

## Tư duy mở rộng (Self-debug)

Sau khi chạy hết các file Migration, hãy thực hiện **"Bài test 1 tỷ"** để kiểm tra độ tin cậy của hệ thống phòng thủ DB:

1.  Tạo 1 nhân viên mới.
2.  Gán Preset "Inbound".
3.  Thử dùng ID nhân viên đó để phê duyệt QC (Hành động này **phải** bị Trigger SoD chặn lại).
4.  Kiểm tra `audit_logs` xem có ghi lại lần thử thất bại đó không (hoặc kiểm tra log transaction).
5.  Thử sửa trực tiếp số lượng tồn kho bằng lệnh SQL:
    `UPDATE inventory_balances SET available_qty = 999 WHERE balance_id = 1;`
    Sau đó kiểm tra `audit_logs` xem có ghi lại `old_data` và `new_data` chính xác không.

Nếu mọi thứ trơn tru, nghĩa là "hệ thống phòng thủ" DB đã sẵn sàng để bắt đầu viết code Axum (Rust).

### Công cụ quản lý Migration?
Ông định dùng công cụ nào để quản lý Migration? 
*   **sqlx-cli**: Tích hợp sâu với Rust, kiểm tra type-safe query ngay lúc compile. Rất tiện nếu ông muốn mọi thứ nằm trong hệ sinh thái Rust.
*   **dbmate**: Một tool độc lập, mạnh mẽ, không phụ thuộc vào ngôn ngữ lập trình. Tiện nếu sau này ông muốn mở rộng hoặc dùng tool khác ngoài Rust để bảo trì DB.

# Thực thi (Implementation Step-by-Step)

Bước 4.1: Khởi tạo Project & Dependencies cốt lõi

Cấu trúc thư mục (Nên chia thành các module rõ ràng):

```
src/
├── main.rs          // Entry point, setup tracing, boot server
├── config.rs        // Load .env (dùng crate `dotenvy` và `config`)
├── error.rs         // Custom AppError (dùng `thiserror`)
├── state.rs         // AppState chứa DbPool và Redis client
├── http/            // Lớp Transport (Axum)
│   ├── middleware/  // JWT Auth, Permission Guard
│   └── handlers/    // inbounds, outbounds, qc
└── services/        // Lớp Nghiệp vụ (Core)
    ├── inventory.rs // FEFO, Transaction
    └── auth.rs      // Login, Token gen
```
Các crates bắt buộc: axum, sqlx (với feature postgres, uuid, chrono), tokio, thiserror, serde, tracing, jsonwebtoken.

Bước 4.2: Xây dựng Hệ thống Báo lỗi (Error Handling)

Đừng bao giờ dùng `unwrap()` hay trả thẳng lỗi DB ra ngoài (lộ cấu trúc DB).Tạo enum AppError bằng thiserror.Implement trait IntoResponse của Axum cho AppError.Quy tắc: Lỗi `sqlx::Error::Database` $\rightarrow$ Log nội bộ (ERROR) + Trả về client HTTP 500. Lỗi nghiệp vụ (hết hàng, sai quyền) $\rightarrow$ Trả về HTTP 400/403 kèm JSON thông báo chuẩn.

Bước 4.3: Middleware & Cơ chế "Bơm" Audit Context (Cực kỳ quan trọng)

Đây là cách ông kết nối Axum với cái Trigger Audit ở dưới DB.Auth Extractor: Viết một Axum Extractor để decode JWT. Nhét cái user_id và mảng preset_ids vào Extension của request.Service Transaction Layer (Pseudo-code Rust):Bất kỳ hàm nào trong folder services/ có thao tác Ghi (Write), bắt buộc phải nhận vào một `&mut sqlx::Transaction.Rust` // Ví dụ trong một Service function
```rust
pub async fn execute_outbound(pool: &PgPool, user_id: i32, task_data: OutboundReq) -> Result<(), AppError> {
    // 1. Mở Transaction
    let mut tx = pool.begin().await?;

    // 2. Bơm Audit Context cho Trigger của PostgreSQL
    sqlx::query("SELECT set_config('app.current_user_id', $1, true)")
        .bind(user_id.to_string())
        .execute(&mut *tx).await?;

    // 3. Thực thi Business Logic (FEFO, trừ tồn)
    // logic_tru_ton_kho(&mut tx, task_data).await?;

    // 4. Commit
    tx.commit().await?;
    Ok(())
}
```
Bước 4.4: Lõi Nghiệp vụ (The FEFO Engine)Để giải quyết bài toán "Hai ông Staff cùng xuất một lô hàng" mà không bị âm tồn kho, ông phải implement Row-Level Locking bằng SKIP LOCKED.Query mẫu trong Rust (`sqlx::query_as!`):
```sql
SELECT balance_id, available_qty
FROM inventory_balances
WHERE product_id = $1 AND status = 'Released' AND available_qty > 0
ORDER BY expiration_date ASC
FOR UPDATE SKIP LOCKED -- Khóa dòng này lại, ai đến sau tự động bỏ qua sang lô tiếp theo
```
Dùng vòng lặp trong Rust: Lấy từng dòng ra $\rightarrow$ trừ số lượng $\rightarrow$ ghi vào inventory_transactions $\rightarrow$ cập nhật inventory_balances $\rightarrow$ Nếu đủ số lượng tổng thì break.Bước 4.5: WebSocket (Push Cảnh báo)Dùng module `axum::extract::ws::WebSocketUpgrade`.Khởi tạo một `tokio::sync::broadcast::channel` trong AppState.Mọi client (Tauri PC) khi connect sẽ subscribe vào channel này.Khi có một Cronjob chạy ngầm phát hiện cảm biến vượt ngưỡng, job đó gọi sender.send(AlertMsg). Tất cả các Staff/QA đang mở app sẽ nhận được banner đỏ tức thì.

---

4. Thực thi (Step-by-Step Implementation)Ông hãy tạo file backend/tests/seed_data.rs với logic "rải thảm" như sau:Bước 1: Setup Master Data (Hạ tầng)Tạo 500 vị trí kho (Locations) chia đều cho các khu: Released, Quarantine, Cold Storage, Rejected..  Tạo 100 sản phẩm mẫu (Products), trong đó 20% có điều kiện bảo quản Cold Chain..  Bước 2: Script sinh dữ liệu (Pseudo-code Rust)Rustasync fn seed_inventory(pool: &PgPool) -> Result<(), AppError> {
    // 1. Tạo 1000 lô hàng (Batches) cho 100 sản phẩm
    for i in 0..1000 {
        let expiration = Utc::now() + Duration::days(i % 365 + 100); // Đảm bảo không bị hết hạn
        sqlx::query!(
            "INSERT INTO product_batches (product_id, batch_number, expiration_date) VALUES ($1, $2, $3)",
            (i % 100) + 1, format!("BATCH-{:04}", i), expiration
        ).execute(pool).await?;
    }

    // 2. Rải hàng vào các vị trí Released
    // Đảm bảo mỗi vị trí có vài loại thuốc để test tính Contention (tranh chấp)
    sqlx::query!(
        "INSERT INTO inventory_balances (product_id, batch_id, location_id, available_qty, status)
         SELECT product_id, batch_id, (SELECT location_id FROM locations WHERE zone_type = 'Released' LIMIT 1 OFFSET (batch_id % 50)), 
         1000, 'Released' FROM product_batches"
    ).execute(pool).await?;
    
    Ok(())
}
Bước 3: Makefile IntegrationThêm lệnh này vào Makefile để dọn dẹp và nạp đạn nhanh:Makefileseed:
	cargo test --test seed_data -- --nocapture
5. Cạm bẫy (Pitfalls)Bẫy Foreign Key: Đừng cố INSERT inventory_balances trước khi locations và batches xong. Thứ tự là: Permissions -> Users -> Products -> Locations -> Batches -> Balances..  Bẫy Unique Constraint: Nếu chạy script seed 2 lần mà không xóa dữ liệu cũ, nó sẽ văng lỗi Duplicate key.Best Practice: Luôn chạy make reset-db (lệnh chúng ta đã viết ở bước trước) trước khi seed..  6. Tư duy mở rộng (Self-debug)Sau khi seed xong, hãy chạy câu lệnh này để kiểm tra "độ phủ" của dữ liệu:SQLSELECT zone_type, count(*), sum(available_qty) 
FROM inventory_balances b 
JOIN locations l ON b.location_id = l.location_id 
GROUP BY zone_type;
Nếu thấy khu vực Cold Storage có hàng nhưng zone_type lại báo là Normal, nghĩa là logic seeder của ông đang bị "hớ" ở khâu mapping điều kiện bảo quản..  Ông muốn tôi viết một bản SQL Seed file thuần túy để ông ném thẳng vào Docker lúc khởi tạo (/docker-entrypoint-initdb.d/), hay muốn triển khai bằng Rust Seeder để có tính toán ngày tháng linh hoạt?.  Gợi ý: Với một dự án dài hơi, Rust Seeder là lựa chọn của Senior vì nó cho phép ông giả lập cả các trường hợp "hàng sắp hết hạn trong 30 ngày" để test hệ thống cảnh báo WebSocket.
