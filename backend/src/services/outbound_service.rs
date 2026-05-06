use sqlx::PgPool;

pub struct OutboundService;

impl OutboundService {
    /// SOP V4.0 Phase 4.1 — SO Screening with Toxic/LASA splitting
    pub async fn screen_order(pool: &PgPool, order_id: i32) -> Result<Vec<i32>, sqlx::Error> {
        let mut tx = pool.begin().await?;

        // 1. Select all lines for this order
        let lines = sqlx::query!(
            r#"
            SELECT line_id, product_id, is_toxic_line as "is_toxic_line!", is_lasa_line as "is_lasa_line!" 
            FROM sales_order_lines WHERE order_id = $1
            "#,
            order_id
        )
        .fetch_all(&mut *tx)
        .await?;

        let mut created_task_ids = Vec::new();

        // 2. Create Toxic Picking Task — Only routes to CHIEF_PHARMACIST
        let has_toxic = lines.iter().any(|l| l.is_toxic_line);
        if has_toxic {
            let task_id = sqlx::query_scalar!(
                "INSERT INTO picking_tasks (order_id, zone_type, status, priority) VALUES ($1, 'TOX', 'PENDING', 10) RETURNING task_id",
                order_id
            )
            .fetch_one(&mut *tx)
            .await?;
            created_task_ids.push(task_id);
        }

        // 3. Create LASA Picking Tasks — Force Single-Pick (one task per LASA line)
        let lasa_lines: Vec<_> = lines.iter().filter(|l| l.is_lasa_line && !l.is_toxic_line).collect();
        for _lasa_line in &lasa_lines {
            let task_id = sqlx::query_scalar!(
                "INSERT INTO picking_tasks (order_id, zone_type, status, is_lasa_single_pick, priority) VALUES ($1, 'LAS', 'PENDING', TRUE, 5) RETURNING task_id",
                order_id
            )
            .fetch_one(&mut *tx)
            .await?;
            created_task_ids.push(task_id);
        }

        // 4. Create Normal Picking Tasks for remaining lines
        let has_normal = lines.iter().any(|l| !l.is_toxic_line && !l.is_lasa_line);
        if has_normal {
            let task_id = sqlx::query_scalar!(
                "INSERT INTO picking_tasks (order_id, zone_type, status, priority) VALUES ($1, 'AVL', 'PENDING', 0) RETURNING task_id",
                order_id
            )
            .fetch_one(&mut *tx)
            .await?;
            created_task_ids.push(task_id);
        }

        // 5. Update order status to SCREENED
        sqlx::query!(
            "UPDATE sales_orders SET status = 'SCREENED' WHERE order_id = $1",
            order_id
        )
        .execute(&mut *tx)
        .await?;

        tx.commit().await?;

        Ok(created_task_ids)
    }
}
