-- Intermediate: enriched orders with payment details

SELECT
    o.*,
    p.payment_method,
    p.status as payment_status
FROM (
    SELECT * FROM {{ ref('stg_orders') }}
    WHERE order_date >= '2024-01-01'
) o
LEFT JOIN {{ ref('stg_payments') }} p
    ON o.order_id = p.order_id
WHERE p.status = 'success'

UNION

SELECT
    o.*,
    p.payment_method,
    p.status as payment_status
FROM (
    SELECT * FROM {{ ref('stg_orders') }}
    WHERE order_date < '2024-01-01'
) o
LEFT JOIN {{ ref('stg_payments') }} p
    ON o.order_id = p.order_id
WHERE p.status = 'success'

ORDER BY order_date
