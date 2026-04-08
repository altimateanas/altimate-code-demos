-- Cost Optimization: Inefficient join patterns that waste compute
-- Use Case #3: "My Snowflake Bill is Too High"

-- PROBLEM QUERY 2: Cartesian product from bad join + unnecessary DISTINCT
-- This creates a massive intermediate result before DISTINCT reduces it
SELECT DISTINCT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    c.email,
    o.order_id,
    o.amount,
    p.payment_method,
    r.rating,
    r.review_text,
    s.session_start,
    s.page_views,
    inv.quantity_on_hand
FROM {{ source('ecommerce', 'raw_customers') }} c
LEFT JOIN {{ source('ecommerce', 'raw_orders') }} o ON c.id = o.customer_id
LEFT JOIN {{ source('ecommerce', 'raw_payments') }} p ON o.order_id = p.order_id
LEFT JOIN {{ source('ecommerce', 'raw_reviews') }} r ON c.id = r.customer_id
LEFT JOIN {{ source('ecommerce', 'raw_sessions') }} s ON c.id = s.user_id
LEFT JOIN {{ source('ecommerce', 'raw_inventory') }} inv ON o.product_id = inv.product_id
ORDER BY c.id, o.order_date


-- PROBLEM QUERY 3: Correlated subqueries instead of JOINs
-- Each subquery triggers a full table scan per row
SELECT
    c.id,
    c.first_name || ' ' || c.last_name AS name,
    (SELECT COUNT(*) FROM {{ source('ecommerce', 'raw_orders') }} o WHERE o.customer_id = c.id) AS order_count,
    (SELECT SUM(CAST(o.amount AS DECIMAL(10,2))) FROM {{ source('ecommerce', 'raw_orders') }} o WHERE o.customer_id = c.id) AS total_spent,
    (SELECT MAX(o.order_date) FROM {{ source('ecommerce', 'raw_orders') }} o WHERE o.customer_id = c.id) AS last_order,
    (SELECT COUNT(*) FROM {{ source('ecommerce', 'raw_sessions') }} s WHERE s.user_id = c.id) AS session_count,
    (SELECT AVG(r.rating) FROM {{ source('ecommerce', 'raw_reviews') }} r WHERE r.customer_id = c.id) AS avg_review_rating,
    (SELECT SUM(CAST(ref.refund_amount AS DECIMAL(10,2))) FROM {{ source('ecommerce', 'raw_refunds') }} ref
     INNER JOIN {{ source('ecommerce', 'raw_orders') }} o ON ref.order_id = o.order_id
     WHERE o.customer_id = c.id) AS total_refunded
FROM {{ source('ecommerce', 'raw_customers') }} c
ORDER BY total_spent DESC
