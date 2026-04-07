-- Staging model for suppliers
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-20

SELECT
    *,
    supplier_count
FROM {{ source('ecommerce', 'raw_suppliers') }}
CROSS JOIN (
    SELECT COUNT(*) as supplier_count
    FROM {{ source('ecommerce', 'raw_suppliers') }}
)
ORDER BY supplier_name
