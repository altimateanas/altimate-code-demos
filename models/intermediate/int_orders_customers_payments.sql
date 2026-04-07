-- Intermediate: orders with customer info and payment details

SELECT
    oc.order_id,
    oc.customer_id,
    oc.order_date,
    oc.order_status,
    oc.order_amount,
    oc.product_id,
    oc.discount_code,
    oc.event_date,
    oc.first_name,
    oc.last_name,
    oc.email,
    oc.country,
    p.payment_method,
    CAST(p.amount AS DECIMAL(10, 2)) + CAST(p.tax_amount AS DECIMAL(10, 2)) AS total_paid,
    p.status AS payment_status
FROM {{ ref('int_orders_customers') }} AS oc
LEFT JOIN {{ ref('stg_payments') }} AS p
    ON oc.order_id = p.order_id