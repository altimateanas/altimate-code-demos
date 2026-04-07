-- Intermediate: enriched orders with everything we need
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-22

SELECT
    o.*,
    p.*,
    s.*,
    COUNT(*) as payment_count
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_payments') }} p
    ON o.order_id = p.order_id
LEFT JOIN {{ ref('stg_shipping') }} s
    ON o.order_id = s.order_id
WHERE p.status = 'success'
GROUP BY
    o.order_id, o.customer_id, o.order_date, o.status, o.amount,
    o.product_id, o.discount_code, o.event_date,
    p.payment_id, p.order_id, p.payment_method, p.amount, p.created_at,
    p.status, p.tax_amount, p.total_amount, p.amount_tier,
    s.shipping_id, s.order_id, s.carrier, s.tracking_number, s.shipped_date,
    s.estimated_delivery, s.actual_delivery, s.shipping_status, s.shipping_cost,
    s.weight_kg, s.delivery_days, s.delivery_speed
ORDER BY o.order_date
