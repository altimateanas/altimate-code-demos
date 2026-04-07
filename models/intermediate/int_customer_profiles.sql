-- Intermediate: customer profiles joined with order stats

SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.created_at,
    c.country,
    os.total_orders,
    os.total_spent,
    os.first_order_date,
    os.last_order_date
FROM {{ ref('stg_customers') }} AS c
LEFT JOIN {{ ref('int_customer_order_stats') }} AS os
    ON c.id = os.customer_id