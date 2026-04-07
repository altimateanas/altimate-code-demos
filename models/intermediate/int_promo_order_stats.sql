-- Intermediate: promotion-level order aggregation

SELECT
    discount_code,
    COUNT(*) AS orders_with_promo,
    SUM(CAST(amount AS DECIMAL(10, 2))) AS revenue_from_promo
FROM {{ ref('stg_orders') }}
WHERE discount_code IS NOT NULL
GROUP BY discount_code