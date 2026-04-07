-- Intermediate: product-level order aggregation

SELECT
    product_id,
    COUNT(*) AS total_orders,
    SUM(CAST(amount AS DECIMAL(10, 2))) AS total_revenue
FROM {{ ref('stg_orders') }}
GROUP BY product_id