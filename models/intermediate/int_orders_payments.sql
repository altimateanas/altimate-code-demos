-- Intermediate: orders joined with successful payments

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status AS order_status,
    o.amount AS order_amount,
    o.product_id,
    o.discount_code,
    o.event_date,
    p.payment_id,
    p.payment_method,
    p.amount AS payment_amount,
    p.created_at AS payment_created_at,
    p.status AS payment_status,
    p.tax_amount,
    p.total_amount AS payment_total_amount,
    p.amount_tier
FROM {{ ref('stg_orders') }} AS o
INNER JOIN {{ ref('stg_payments') }} AS p
    ON o.order_id = p.order_id
WHERE p.status = 'success'