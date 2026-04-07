-- Intermediate: customer-level order aggregation

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(CAST(amount AS DECIMAL(10, 2))) AS total_spent,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM {{ ref('stg_orders') }}
GROUP BY customer_id