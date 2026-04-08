-- Legacy SQL Server report: Customer Segmentation Analysis
-- Source system: LegacyReporting.dbo
-- Uses SQL Server-specific syntax: IIF, STRING_AGG, CROSS APPLY, OFFSET FETCH

DECLARE @CutoffDate DATE = DATEADD(month, -6, GETDATE())
DECLARE @VIPThreshold MONEY = 500.00

SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS FullName,
    c.Email,
    c.Country,
    DATEDIFF(day, c.CreatedAt, GETDATE()) AS DaysAsCustomer,
    order_summary.TotalOrders,
    order_summary.TotalSpent,
    order_summary.AvgOrderValue,
    order_summary.LastOrderDate,
    IIF(order_summary.TotalSpent >= @VIPThreshold, 'VIP', 'Standard') AS CustomerTier,
    IIF(order_summary.LastOrderDate >= @CutoffDate, 'Active', 'At Risk') AS EngagementStatus,
    ISNULL(refund_summary.RefundCount, 0) AS RefundCount,
    ISNULL(refund_summary.TotalRefunded, 0) AS TotalRefunded,
    CONVERT(VARCHAR(10), c.CreatedAt, 120) AS JoinDate
FROM dbo.Customers c WITH (NOLOCK)
CROSS APPLY (
    SELECT
        COUNT(*) AS TotalOrders,
        SUM(CAST(o.Amount AS MONEY)) AS TotalSpent,
        AVG(CAST(o.Amount AS MONEY)) AS AvgOrderValue,
        MAX(o.OrderDate) AS LastOrderDate
    FROM dbo.Orders o WITH (NOLOCK)
    WHERE o.CustomerID = c.CustomerID
        AND o.Status IN ('completed', 'returned')
) order_summary
OUTER APPLY (
    SELECT
        COUNT(*) AS RefundCount,
        SUM(CAST(r.RefundAmount AS MONEY)) AS TotalRefunded
    FROM dbo.Refunds r WITH (NOLOCK)
    WHERE r.OrderID IN (
        SELECT OrderID FROM dbo.Orders WHERE CustomerID = c.CustomerID
    )
    AND r.Status = 'approved'
) refund_summary
WHERE order_summary.TotalOrders > 0
ORDER BY order_summary.TotalSpent DESC
OFFSET 0 ROWS FETCH NEXT 500 ROWS ONLY
