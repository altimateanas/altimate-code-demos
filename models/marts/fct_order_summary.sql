-- Fact table: order summary with customer details

SELECT
    o.*,
    c.first_name,
    c.last_name,
    c.country
FROM (
    SELECT *
    FROM {{ ref('stg_orders') }}
    WHERE order_date >= '2024-01-01'
) o
LEFT JOIN (
    SELECT *
    FROM {{ ref('stg_customers') }}
) c
ON o.customer_id = c.id

UNION

SELECT
    o.*,
    c.first_name,
    c.last_name,
    c.country
FROM (
    SELECT *
    FROM {{ ref('stg_orders') }}
    WHERE order_date < '2024-01-01'
) o
LEFT JOIN (
    SELECT *
    FROM {{ ref('stg_customers') }}
) c
ON o.customer_id = c.id

ORDER BY order_date DESC
