-- Staging model for refunds
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-18
-- filtering out rejected ones since we don't need them

SELECT
    *,
    refund_reason || ' - ' || notes as refund_detail
FROM {{ source('ecommerce', 'raw_refunds') }}
WHERE status != 'rejected'
ORDER BY refund_date
