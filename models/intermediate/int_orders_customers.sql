-- Intermediate: orders joined with customer details

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status AS order_status,
    o.amount AS order_amount,
    o.product_id,
    o.discount_code,
    o.event_date,
    c.first_name,
    c.last_name,
    c.email,
    c.country
FROM {{ ref('stg_orders') }} AS o
LEFT JOIN {{ ref('stg_customers') }} AS c
    ON o.customer_id = c.id