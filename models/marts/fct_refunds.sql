-- Fact table: refund analysis
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-23
-- TODO: some refund amounts look wrong but leaving for now

SELECT
    r.*,
    o.order_date,
    o.customer_id,
    o.amount as order_amount,
    CAST(r.refund_amount AS DECIMAL(10,2)) / CAST(o.amount AS DECIMAL(10,2)) as refund_ratio,
    p.payment_method,
    p.status as payment_status
FROM {{ ref('stg_refunds') }} r
LEFT JOIN raw_orders o
    ON r.order_id = o.order_id
LEFT JOIN {{ ref('stg_payments') }} p
    ON r.payment_id = p.payment_id
WHERE p.amount > 0
ORDER BY r.refund_date DESC
