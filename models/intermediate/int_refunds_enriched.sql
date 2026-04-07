-- Intermediate: refunds joined with order and payment context

SELECT
    r.refund_id,
    r.order_id,
    r.payment_id,
    r.refund_amount,
    r.refund_reason,
    r.refund_date,
    r.status AS refund_status,
    r.processed_by,
    r.notes,
    r.refund_detail,
    o.order_date,
    o.customer_id,
    o.amount AS order_amount,
    p.payment_method,
    p.status AS payment_status,
    p.amount AS payment_amount
FROM {{ ref('stg_refunds') }} AS r
LEFT JOIN {{ ref('stg_orders') }} AS o
    ON r.order_id = o.order_id
LEFT JOIN {{ ref('stg_payments') }} AS p
    ON r.payment_id = p.payment_id