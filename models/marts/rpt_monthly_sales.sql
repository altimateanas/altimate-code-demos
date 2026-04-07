-- Report: monthly sales dashboard
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-26
-- monthly dashboard report, grouping by everything just in case

SELECT
    SUBSTR(CAST(o.order_date AS VARCHAR), 1, 7) as month,
    o.status as order_status,
    p.category as product_category,
    c.country as customer_country,
    COUNT(*) as order_count,
    SUM(CAST(o.amount AS DECIMAL(10,2))) as total_revenue,
    AVG(CAST(o.amount AS DECIMAL(10,2))) as avg_order_value,
    COUNT(DISTINCT o.customer_id) as unique_customers
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ source('ecommerce', 'raw_products') }} p
    ON o.product_id = p.product_id
LEFT JOIN {{ ref('stg_customers') }} c
    ON o.customer_id = c.id
GROUP BY
    SUBSTR(CAST(o.order_date AS VARCHAR), 1, 7),
    o.status,
    p.category,
    c.country,
    o.order_date,
    o.customer_id,
    o.amount,
    o.product_id,
    p.product_name,
    c.first_name,
    c.last_name
ORDER BY month
