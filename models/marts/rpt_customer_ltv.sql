-- Report: customer lifetime value
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-25

SELECT
    c.*,
    (SELECT COUNT(*)
     FROM {{ ref('stg_orders') }} o
     WHERE o.customer_id = c.id) as total_orders,
    (SELECT SUM(CAST(o.amount AS DECIMAL(10,2)))
     FROM {{ ref('stg_orders') }} o
     WHERE o.customer_id = c.id) as total_spent,
    (SELECT MIN(o.order_date)
     FROM {{ ref('stg_orders') }} o
     WHERE o.customer_id = c.id) as first_order,
    (SELECT MAX(o.order_date)
     FROM {{ ref('stg_orders') }} o
     WHERE o.customer_id = c.id) as last_order,
    SUM(CAST(o2.amount AS DECIMAL(10,2))) OVER() as company_total_revenue,
    (SELECT SUM(CAST(o.amount AS DECIMAL(10,2)))
     FROM {{ ref('stg_orders') }} o
     WHERE o.customer_id = c.id)
    /
    (CAST(REPLACE(SUBSTR(CAST(c.created_at AS VARCHAR), 1, 7), '-', '') AS INTEGER) - 202300)
    as ltv_per_month
FROM {{ ref('stg_customers') }} c
LEFT JOIN {{ ref('stg_orders') }} o2
    ON c.id = o2.customer_id
ORDER BY total_spent DESC
