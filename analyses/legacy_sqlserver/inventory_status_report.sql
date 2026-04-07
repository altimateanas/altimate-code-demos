-- Legacy SQL Server report: Inventory Status with Supplier Details
-- Source system: LegacyReporting.dbo
-- Uses: PIVOT, computed columns, SQL Server date functions, sp_executesql pattern

SELECT
    p.ProductName,
    p.Category,
    s.SupplierName,
    inv.WarehouseLocation,
    inv.QuantityOnHand,
    inv.QuantityReserved,
    inv.QuantityOnHand - inv.QuantityReserved AS AvailableQty,
    inv.ReorderPoint,
    IIF(inv.QuantityOnHand - inv.QuantityReserved < inv.ReorderPoint, 'REORDER', 'OK') AS StockStatus,
    CAST(inv.UnitCost AS MONEY) * inv.QuantityOnHand AS InventoryValue,
    DATEDIFF(day, inv.SnapshotDate, GETDATE()) AS DaysSinceSnapshot,
    FORMAT(CAST(inv.UnitCost AS MONEY), 'C', 'en-US') AS FormattedCost
FROM dbo.Inventory inv WITH (NOLOCK)
INNER JOIN dbo.Products p WITH (NOLOCK)
    ON inv.ProductID = p.ProductID
LEFT JOIN dbo.Suppliers s WITH (NOLOCK)
    ON inv.SupplierID = s.SupplierID
WHERE inv.SnapshotDate = (
    SELECT TOP 1 SnapshotDate
    FROM dbo.Inventory
    WHERE ProductID = inv.ProductID
    ORDER BY SnapshotDate DESC
)
AND p.IsActive = 1
ORDER BY
    CASE WHEN inv.QuantityOnHand - inv.QuantityReserved < inv.ReorderPoint
         THEN 0 ELSE 1 END,
    p.Category,
    p.ProductName
