-- Staging model for customers
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-15

SELECT *
FROM {{ source('ecommerce', 'raw_customers') }}
WHERE status != 'inactive'
ORDER BY last_name
