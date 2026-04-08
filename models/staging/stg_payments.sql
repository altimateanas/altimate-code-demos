-- Staging model for payments
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-16

SELECT
    *,
    amount + tax_amount as total_amount,
    CASE
        WHEN amount > 100 THEN 'high'
        WHEN amount > 50 THEN 'medium'
        ELSE 'low'
    END as amount_tier
FROM {{ source('ecommerce', 'raw_payments') }}
WHERE status != 'failed'
AND amount != 0
ORDER BY created_at
