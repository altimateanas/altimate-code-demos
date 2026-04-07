-- Fact table: daily revenue aggregation
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-23

SELECT
    SUBSTR(CAST(order_date AS VARCHAR), 1, 10) as revenue_date,
    SUBSTR(CAST(order_date AS VARCHAR), 1, 7) as revenue_month,
    SUBSTR(CAST(order_date AS VARCHAR), 1, 4) as revenue_year,
    COUNT(*) as order_count,
    SUM(CAST(amount AS DECIMAL(10,2))) as total_revenue,
    AVG(CAST(amount AS DECIMAL(10,2))) as avg_order_value
FROM {{ ref('stg_orders') }}
WHERE order_date > '2024-01-01'
GROUP BY 1, 2, 3

UNION

SELECT
    SUBSTR(CAST(order_date AS VARCHAR), 1, 10) as revenue_date,
    SUBSTR(CAST(order_date AS VARCHAR), 1, 7) as revenue_month,
    SUBSTR(CAST(order_date AS VARCHAR), 1, 4) as revenue_year,
    COUNT(*) as order_count,
    SUM(CAST(amount AS DECIMAL(10,2))) as total_revenue,
    AVG(CAST(amount AS DECIMAL(10,2))) as avg_order_value
FROM {{ ref('stg_orders') }}
WHERE order_date <= '2024-01-01'
GROUP BY 1, 2, 3

ORDER BY revenue_date
