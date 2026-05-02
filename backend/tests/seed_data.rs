use backend::{config::Config, create_app};
use sqlx::{PgPool, Row};
use chrono::{Utc, Duration};
use bcrypt::{hash, DEFAULT_COST};

#[sqlx::test(migrations = "../database/migrations")]
async fn seed_full_warehouse_data(pool: PgPool) {
    println!("--- SEEDING SYSTEM INFRASTRUCTURE ---");

    // 1. Seed Employee & User
    let hashed_pw = hash("secret", DEFAULT_COST).unwrap();
    let emp_id: i32 = sqlx::query("INSERT INTO employees (employee_code, full_name) VALUES ('ADMIN-01', 'System Admin') RETURNING employee_id")
        .fetch_one(&pool).await.unwrap().get(0);
    let user_id: i32 = sqlx::query("INSERT INTO users (employee_id, username, password_hash) VALUES ($1, 'admin', $2) RETURNING user_id")
        .bind(emp_id).bind(&hashed_pw).fetch_one(&pool).await.unwrap().get(0);
    let admin_preset_id: i32 = sqlx::query("SELECT preset_id FROM presets WHERE preset_name = 'Admin'").fetch_one(&pool).await.unwrap().get(0);
    sqlx::query("INSERT INTO user_presets (user_id, preset_id) VALUES ($1, $2)").bind(user_id).bind(admin_preset_id).execute(&pool).await.unwrap();

    // 2. Seed 500 Locations
    println!("Seeding 500 locations...");
    for i in 0..500 {
        let zone = match i % 4 {
            0 => "Released",
            1 => "Quarantine",
            2 => "Cold",
            _ => "Rejected",
        };
        sqlx::query("INSERT INTO locations (location_code, zone_type) VALUES ($1, $2)")
            .bind(format!("LOC-{:04}", i))
            .bind(zone)
            .execute(&pool).await.unwrap();
    }

    // 3. Seed 100 Products
    println!("Seeding 100 products...");
    for i in 0..100 {
        let storage = if i % 5 == 0 { "Cold 2-8C" } else { "Normal" };
        sqlx::query("INSERT INTO products (product_code, trade_name, base_unit, storage_condition) VALUES ($1, $2, 'Box', $3)")
            .bind(format!("PROD-{:03}", i))
            .bind(format!("Product Brand {}", i))
            .bind(storage)
            .execute(&pool).await.unwrap();
    }

    // 4. Seed 1000 Batches (10 per product)
    println!("Seeding 1000 batches...");
    for i in 0..1000 {
        let product_id = (i % 100) + 1;
        let expiration = Utc::now() + Duration::days((i % 365 + 100) as i64);
        sqlx::query("INSERT INTO product_batches (product_id, batch_number, manufacture_date, expiration_date) VALUES ($1, $2, CURRENT_DATE - INTERVAL '1 month', $3)")
            .bind(product_id)
            .bind(format!("BATCH-{:04}", i))
            .bind(expiration.naive_utc().date())
            .execute(&pool).await.unwrap();
    }

    // 5. Seed Inventory Balances (Distributed)
    println!("Railing stock into Released zones...");
    // We pick Released locations
    let released_locs: Vec<i32> = sqlx::query("SELECT location_id FROM locations WHERE zone_type = 'Released'")
        .fetch_all(&pool).await.unwrap()
        .into_iter().map(|r| r.get(0)).collect();

    let batches: Vec<(i32, i32, chrono::NaiveDate)> = sqlx::query("SELECT batch_id, product_id, expiration_date FROM product_batches")
        .fetch_all(&pool).await.unwrap()
        .into_iter().map(|r| (r.get(0), r.get(1), r.get(2))).collect();

    for (batch_id, product_id, expiration_date) in batches {
        // Distribute each batch into a random released location (modulo)
        let loc_id = released_locs[batch_id as usize % released_locs.len()];
        
        sqlx::query("INSERT INTO inventory_balances (product_id, batch_id, location_id, available_qty, status, expiration_date) VALUES ($1, $2, $3, $4, 'Released', $5)")
            .bind(product_id)
            .bind(batch_id)
            .bind(loc_id)
            .bind(1000)
            .bind(expiration_date)
            .execute(&pool).await.unwrap();
    }

    println!("--- SEEDING COMPLETED SUCCESSFULLY ---");
    
    // Quick Verification
    let total_qty: i64 = sqlx::query("SELECT SUM(available_qty) FROM inventory_balances").fetch_one(&pool).await.unwrap().get(0);
    println!("Total units in warehouse: {}", total_qty);
}
