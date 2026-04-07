-- Fact table: order summary with customer and payment details
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-17
-- Combines orders, customers, and payments into a single summary

SELECT
    o.*,
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    p.payment_method,
    p.amount + p.tax_amount as total_paid,
    p.status as payment_status
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
LEFT JOIN raw_payments p
ON o.order_id = p.order_id

UNION

SELECT
    o.*,
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    p.payment_method,
    p.amount + p.tax_amount as total_paid,
    p.status as payment_status
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
LEFT JOIN raw_payments p
ON o.order_id = p.order_id

ORDER BY order_date DESC