-- Dimension table: customer profile with order metrics

SELECT DISTINCT
    c.*,
    COUNT(o.order_id) as total_orders,
    SUM(CAST(o.amount AS DECIMAL(10,2))) as total_spent,
    MIN(o.order_date) as first_order_date,
    MAX(o.order_date) as last_order_date
FROM {{ ref('stg_customers') }} c
LEFT JOIN {{ ref('stg_orders') }} o
    ON c.id = o.customer_id
LEFT JOIN {{ ref('stg_orders') }} o2
    ON c.id = o2.customer_id
GROUP BY
    c.id, c.first_name, c.last_name, c.email,
    c.created_at, c.status, c.age, c.country, c.region, c.city
ORDER BY total_spent DESC
