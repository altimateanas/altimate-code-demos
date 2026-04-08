-- Staging model for customer support tickets
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-22
-- NOTE: this table has some sensitive data but its fine for analytics

SELECT *
FROM {{ source('ecommerce', 'raw_customer_support') }}
WHERE resolved_at IS NOT NULL
ORDER BY created_at DESC
