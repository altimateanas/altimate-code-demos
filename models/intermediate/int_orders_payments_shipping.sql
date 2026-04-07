-- Intermediate: orders with payments and shipping details

SELECT
    op.order_id,
    op.customer_id,
    op.order_date,
    op.order_status,
    op.order_amount,
    op.product_id,
    op.discount_code,
    op.event_date,
    op.payment_id,
    op.payment_method,
    op.payment_amount,
    op.payment_created_at,
    op.payment_status,
    op.tax_amount,
    op.payment_total_amount,
    op.amount_tier,
    s.shipping_id,
    s.carrier,
    s.tracking_number,
    s.shipped_date,
    s.estimated_delivery,
    s.actual_delivery,
    s.shipping_status,
    s.shipping_cost,
    s.weight_kg,
    s.delivery_days,
    s.delivery_speed
FROM {{ ref('int_orders_payments') }} AS op
LEFT JOIN {{ ref('stg_shipping') }} AS s
    ON op.order_id = s.order_id