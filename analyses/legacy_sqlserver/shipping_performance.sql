-- Legacy SQL Server report: Shipping Performance Dashboard
-- Source system: LegacyReporting.dbo
-- Uses: PIVOT, STUFF/FOR XML PATH, SQL Server window functions

;WITH ShippingMetrics AS (
    SELECT
        s.Carrier,
        DATEPART(yyyy, s.ShippedDate) AS ShipYear,
        DATEPART(qq, s.ShippedDate) AS ShipQuarter,
        DATEDIFF(day, s.ShippedDate, s.ActualDelivery) AS DeliveryDays,
        IIF(s.ActualDelivery <= s.EstimatedDelivery, 1, 0) AS OnTime,
        CAST(s.ShippingCost AS MONEY) AS Cost,
        s.ShippingStatus
    FROM dbo.Shipping s WITH (NOLOCK)
    WHERE s.ShippedDate >= DATEADD(year, -2, GETDATE())
        AND s.ActualDelivery IS NOT NULL
),
CarrierSummary AS (
    SELECT
        Carrier,
        ShipYear,
        ShipQuarter,
        COUNT(*) AS TotalShipments,
        AVG(DeliveryDays) AS AvgDeliveryDays,
        SUM(OnTime) AS OnTimeCount,
        CAST(SUM(OnTime) AS FLOAT) / COUNT(*) * 100 AS OnTimeRate,
        SUM(Cost) AS TotalCost,
        AVG(Cost) AS AvgCost,
        STDEV(DeliveryDays) AS DeliveryStdDev
    FROM ShippingMetrics
    GROUP BY Carrier, ShipYear, ShipQuarter
)

SELECT
    cs.*,
    RANK() OVER (
        PARTITION BY cs.ShipYear, cs.ShipQuarter
        ORDER BY cs.OnTimeRate DESC
    ) AS CarrierRank,
    STUFF(
        (SELECT ', ' + UPPER(sm.ShippingStatus)
         FROM ShippingMetrics sm
         WHERE sm.Carrier = cs.Carrier
         GROUP BY sm.ShippingStatus
         FOR XML PATH('')), 1, 2, ''
    ) AS StatusList
FROM CarrierSummary cs
ORDER BY cs.ShipYear DESC, cs.ShipQuarter DESC, cs.OnTimeRate DESC
