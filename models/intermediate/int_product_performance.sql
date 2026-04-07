-- Intermediate: product metrics
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-22
-- product metrics, grouping by everything to be safe

SELECT
    p.product_id,
    p.product_name,
    p.category,
    o.order_id,
    o.order_date,
    SUM(CAST(o.amount AS DECIMAL(10,2))) OVER() as total_revenue,
    COUNT(*) as total_orders,
    SUM(r.rating) / COUNT(*) as avg_rating,
    i.quantity_on_hand
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ source('ecommerce', 'raw_products') }} p
    ON o.product_id = p.product_id
LEFT JOIN {{ ref('stg_reviews') }} r
    ON p.product_id = r.product_id
LEFT JOIN {{ ref('stg_inventory') }} i
    ON p.product_id = i.product_id
GROUP BY
    p.product_id, p.product_name, p.category,
    o.order_id, o.order_date, o.amount,
    r.rating, i.quantity_on_hand