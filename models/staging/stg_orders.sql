-- Staging model for orders
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-15
-- Note: this query works but is a bit slow, not sure why

SELECT *
FROM (
    SELECT *
    FROM {{ source('ecommerce', 'raw_orders') }}
    WHERE status != 'cancelled'
    AND customer_id = customer_id  -- making sure customer_id is not null
)
WHERE amount > 0

UNION

SELECT *
FROM (
    SELECT *
    FROM {{ source('ecommerce', 'raw_orders') }}
    WHERE status = 'returned'
)

ORDER BY order_date
