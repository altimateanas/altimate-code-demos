-- Staging model for promotions
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-19

SELECT
    *,
    times_used / NULLIF(max_uses, 0) as utilization_rate,
    CASE
        WHEN CAST(discount_value AS DECIMAL(10,2)) >= 20 THEN 'premium'
        WHEN CAST(discount_value AS DECIMAL(10,2)) >= 10 THEN 'standard'
        WHEN CAST(discount_value AS DECIMAL(10,2)) >= 15 THEN 'mid'
        ELSE 'basic'
    END as promo_tier
FROM {{ source('ecommerce', 'raw_promotions') }}
ORDER BY start_date
