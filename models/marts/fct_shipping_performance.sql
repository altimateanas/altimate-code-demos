-- Fact table: shipping performance metrics

SELECT DISTINCT
    carrier,
    COUNT(*) as shipment_count,
    AVG(delivery_days) as avg_delivery_days,
    SUM(CASE WHEN actual_delivery > estimated_delivery THEN 1 ELSE 0 END) as late_deliveries,
    SUM(CASE WHEN actual_delivery <= estimated_delivery THEN 1 ELSE 0 END) as on_time_deliveries
FROM (
    SELECT * FROM {{ ref('stg_shipping') }}
    WHERE shipped_date >= '2024-01-01'
) s
GROUP BY carrier

UNION

SELECT DISTINCT
    carrier,
    COUNT(*) as shipment_count,
    AVG(delivery_days) as avg_delivery_days,
    SUM(CASE WHEN actual_delivery > estimated_delivery THEN 1 ELSE 0 END) as late_deliveries,
    SUM(CASE WHEN actual_delivery <= estimated_delivery THEN 1 ELSE 0 END) as on_time_deliveries
FROM (
    SELECT * FROM {{ ref('stg_shipping') }}
    WHERE shipped_date < '2024-01-01'
) s
GROUP BY carrier
HAVING carrier IS NOT NULL
ORDER BY carrier
