-- Legacy SQL Server report: Monthly Revenue Summary
-- Source system: LegacyReporting.dbo
-- This query runs on the SQL Server warehouse and needs to be migrated to Snowflake
-- Uses SQL Server-specific syntax (DATEPART, TOP, NOLOCK, += operators)

SELECT TOP 1000
    DATEPART(yyyy, o.OrderDate) AS RevenueYear,
    DATEPART(mm, o.OrderDate) AS RevenueMonth,
    DATENAME(month, o.OrderDate) AS MonthName,
    c.Country,
    p.Category,
    COUNT(*) AS OrderCount,
    SUM(CAST(o.Amount AS MONEY)) AS TotalRevenue,
    AVG(CAST(o.Amount AS MONEY)) AS AvgOrderValue,
    SUM(CASE WHEN o.Status = 'completed' THEN CAST(o.Amount AS MONEY) ELSE 0 END) AS CompletedRevenue,
    SUM(CASE WHEN o.Status = 'returned' THEN 1 ELSE 0 END) AS ReturnCount
FROM dbo.Orders o WITH (NOLOCK)
INNER JOIN dbo.Customers c WITH (NOLOCK)
    ON o.CustomerID = c.CustomerID
INNER JOIN dbo.Products p WITH (NOLOCK)
    ON o.ProductID = p.ProductID
WHERE o.OrderDate >= DATEADD(month, -12, GETDATE())
    AND o.Status <> 'cancelled'
GROUP BY
    DATEPART(yyyy, o.OrderDate),
    DATEPART(mm, o.OrderDate),
    DATENAME(month, o.OrderDate),
    c.Country,
    p.Category
ORDER BY RevenueYear DESC, RevenueMonth DESC
