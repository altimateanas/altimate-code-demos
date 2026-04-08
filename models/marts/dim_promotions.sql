-- Dimension table: promotion effectiveness

SELECT
    p.*,
    COUNT(o.order_id) as times_redeemed
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
ORDER BY times_redeemed DESC
