-- Fact table: refund analysis

SELECT
    r.*,
    o.order_date,
    o.customer_id,
    CAST(r.refund_amount AS DECIMAL(10,2)) / CAST(o.amount AS DECIMAL(10,2)) as refund_ratio
FROM (
    SELECT * FROM {{ ref('stg_refunds') }}
) r
LEFT JOIN raw_orders o
    ON r.order_id = o.order_id
WHERE o.amount > 0
ORDER BY r.refund_date DESC
