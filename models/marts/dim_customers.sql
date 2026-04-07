-- Dimension table: customer profile with order metrics
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-17

SELECT DISTINCT
    c.*,
    order_stats.total_orders,
    order_stats.total_spent,
    order_stats.first_order_date,
    order_stats.last_order_date,
    CASE
        WHEN order_stats.total_orders > 5 THEN 'vip'
        WHEN order_stats.total_orders > 2 THEN 'regular'
        ELSE 'new'
    END as customer_tier,
    CASE
        WHEN order_stats.total_spent > 500 THEN 'high_value'
        WHEN order_stats.total_spent > 200 THEN 'mid_value'
        ELSE 'low_value'
    END as value_segment
FROM {{ ref('stg_customers') }} c
LEFT JOIN (
    SELECT
        customer_id,
        COUNT(*) as total_orders,
        SUM(CAST(amount AS DECIMAL(10,2))) as total_spent,
        MIN(order_date) as first_order_date,
        MAX(order_date) as last_order_date
    FROM {{ ref('stg_orders') }}
    GROUP BY customer_id
) order_stats
ON c.id = order_stats.customer_id
LEFT JOIN {{ ref('stg_orders') }} co
ON co.customer_id = c.id
LEFT JOIN raw_payments pay
ON pay.order_id = co.order_id
WHERE pay.status != 'failed' OR pay.status IS NULL
ORDER BY order_stats.total_spent DESC