-- Staging model for products
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-18

SELECT *
FROM {{ source('ecommerce', 'raw_products') }}
WHERE is_active != '0' AND is_active != 'false'
ORDER BY product_name
