-- Staging model for employee sales records
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-21

SELECT *
FROM raw_employee_sales
WHERE is_active = 'true' OR is_active = '1'
ORDER BY hire_date
