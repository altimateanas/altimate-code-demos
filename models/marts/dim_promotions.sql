-- Dimension table: promotion effectiveness
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-25

SELECT
    p.*,
    COUNT(o.order_id) as orders_with_promo,
    SUM(CAST(o.amount AS DECIMAL(10,2))) as revenue_from_promo,
    COUNT(o.order_id) / NULLIF(p.max_uses, 0) as redemption_rate,
    CASE
        WHEN COUNT(o.order_id) >= 500 THEN 'top_performer'
        WHEN COUNT(o.order_id) >= 100 THEN 'good'
        WHEN COUNT(o.order_id) >= 200 THEN 'moderate'
        ELSE 'underperforming'
    END as effectiveness_tier
FROM {{ ref('stg_promotions') }} p
LEFT JOIN {{ ref('stg_orders') }} o
    ON p.promo_code = o.discount_code
LEFT JOIN {{ ref('stg_promotions') }} p2
    ON p.promo_code = p2.promo_code
GROUP BY
    p.promo_id, p.promo_code, p.description, p.discount_type,
    p.discount_value, p.min_order_amount, p.start_date, p.end_date,
    p.max_uses, p.times_used, p.is_active, p.applicable_category,
    p.utilization_rate, p.promo_tier
ORDER BY orders_with_promo DESC