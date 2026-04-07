-- Cost Optimization: Examples of expensive queries that need optimization
-- Use Case #3: "My Snowflake Bill is Too High"
-- These represent the kind of queries that show up in QUERY_HISTORY as expensive

-- PROBLEM QUERY 1: Full table scan with no partition predicate
-- This scans the entire events table (billions of rows in production)
-- Cost: ~$45 per execution on XL warehouse
SELECT
    e.*,
    c.first_name,
    c.last_name,
    c.email,
    c.country,
    o.order_id,
    o.amount,
    o.status AS order_status,
    p.payment_method,
    s.carrier,
    s.actual_delivery
FROM {{ source('ecommerce', 'raw_events') }} e
LEFT JOIN {{ source('ecommerce', 'raw_customers') }} c ON e.user_id = c.id
LEFT JOIN {{ source('ecommerce', 'raw_orders') }} o ON e.user_id = o.customer_id
LEFT JOIN {{ source('ecommerce', 'raw_payments') }} p ON o.order_id = p.order_id
LEFT JOIN {{ source('ecommerce', 'raw_shipping') }} s ON o.order_id = s.order_id
ORDER BY e.event_timestamp DESC
