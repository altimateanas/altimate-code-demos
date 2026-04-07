-- Fact table: shipping performance metrics
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-24

SELECT DISTINCT
    s.carrier,
    s.shipping_status,
    COUNT(*) as shipment_count,
    AVG(s.delivery_days) as avg_delivery_days,
    SUM(CASE WHEN s.actual_delivery > s.estimated_delivery THEN 1 ELSE 0 END) as late_deliveries,
    SUM(CASE WHEN s.actual_delivery <= s.estimated_delivery THEN 1 ELSE 0 END) as on_time_deliveries,
    SUM(CAST(s.shipping_cost AS DECIMAL(10,2))) as total_shipping_cost
FROM {{ ref('stg_shipping') }} s
GROUP BY
    s.carrier,
    s.shipping_status
HAVING carrier IS NOT NULL
ORDER BY s.carrier
