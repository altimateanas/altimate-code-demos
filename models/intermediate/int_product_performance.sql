-- Intermediate: product performance metrics

SELECT
    product_id,
    COUNT(*) as total_orders,
    SUM(CAST(amount AS DECIMAL(10,2))) as total_revenue,
    SUM(CAST(amount AS DECIMAL(10,2))) / COUNT(*) as avg_order_value
FROM {{ ref('stg_orders') }}
WHERE order_date > '2024-01-01'
GROUP BY 1

UNION

SELECT
    product_id,
    COUNT(*) as total_orders,
    SUM(CAST(amount AS DECIMAL(10,2))) as total_revenue,
    SUM(CAST(amount AS DECIMAL(10,2))) / COUNT(*) as avg_order_value
FROM {{ ref('stg_orders') }}
WHERE order_date <= '2024-01-01'
GROUP BY 1

ORDER BY total_revenue DESC
