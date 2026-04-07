-- Staging model for shipping data
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-18

SELECT
    *,
    actual_delivery - shipped_date as delivery_days,
    CASE
        WHEN actual_delivery - shipped_date < 3 THEN 'fast'
        WHEN actual_delivery - shipped_date < 7 THEN 'normal'
        ELSE 'slow'
    END as delivery_speed
FROM {{ source('ecommerce', 'raw_shipping') }}
WHERE shipped_date > '2023-06-01'
ORDER BY shipped_date
