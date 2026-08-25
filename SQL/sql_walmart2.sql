SELECT COUNT(*) AS TotalProducts
FROM products;

SELECT COUNT(*) AS TotalStores
FROM stores;

ALTER TABLE suppliers
ADD COLUMN Rating DECIMAL(3,2);

DESCRIBE suppliers;

SELECT COUNT(*) AS TotalSuppliers
FROM suppliers;

SELECT COUNT(*) AS TotalWarehouses
FROM warehouse;

SELECT COUNT(*) AS TotalOrders
FROM orders;

SELECT COUNT(*) AS TotalInventory
FROM inventory;

SELECT COUNT(*) AS TotalShipments
FROM shipments;

SELECT MIN(ShipmentID) AS FirstShipment,
       MAX(ShipmentID) AS LastShipment
FROM shipments;

SELECT COUNT(DISTINCT ShipmentID) AS UniqueShipments
FROM shipments;

SELECT ShipmentID, COUNT(*) AS DuplicateCount
FROM shipments
GROUP BY ShipmentID
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;

SELECT
    COUNT(*) AS TotalShipments,
    COUNT(DISTINCT ShipmentID) AS UniqueShipments,
    MIN(ShipmentID) AS FirstShipment,
    MAX(ShipmentID) AS LastShipment
FROM shipments;

SELECT CONCAT('SHP', LPAD(n, 6, '0')) AS MissingShipmentID
FROM (
    SELECT ones.n + tens.n * 10 + hundreds.n * 100 +
           thousands.n * 1000 + tenthousands.n * 10000 AS n
    FROM
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) ones
    CROSS JOIN
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) tens
    CROSS JOIN
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) hundreds
    CROSS JOIN
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) thousands
    CROSS JOIN
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) tenthousands
    WHERE n BETWEEN 1 AND 100000
) numbers
WHERE NOT EXISTS (
    SELECT 1
    FROM shipments s
    WHERE s.ShipmentID = CONCAT('SHP', LPAD(numbers.n, 6, '0'))
);

WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 100000
)
SELECT CONCAT('SHP', LPAD(numbers.n, 6, '0')) AS MissingShipmentID
FROM numbers
LEFT JOIN shipments s
    ON s.ShipmentID = CONCAT('SHP', LPAD(numbers.n, 6, '0'))
WHERE s.ShipmentID IS NULL
LIMIT 100;

SELECT
    COUNT(*) AS TotalRows,
    SUM(ProductID IS NULL) AS MissingProductID,
    SUM(Category IS NULL) AS MissingCategory,
    SUM(UnitCost IS NULL) AS MissingUnitCost,
    SUM(UnitPrice IS NULL) AS MissingUnitPrice
FROM products;

SELECT
    ProductID,
    COUNT(*) AS DuplicateCount
FROM products
GROUP BY ProductID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS InvalidProducts
FROM products
WHERE UnitCost < 0
   OR UnitPrice < 0
   OR UnitPrice < UnitCost;
   
SELECT
    COUNT(*) AS TotalRows,
    SUM(StoreID IS NULL) AS MissingStoreID,
    SUM(Region IS NULL) AS MissingRegion
FROM stores;

SELECT
    StoreID,
    COUNT(*) AS DuplicateCount
FROM stores
GROUP BY StoreID
HAVING COUNT(*) > 1;

SELECT
    Region,
    COUNT(*) AS StoreCount
FROM stores
GROUP BY Region
ORDER BY StoreCount DESC;

SELECT
    COUNT(*) AS TotalRows,
    SUM(SupplierID IS NULL) AS MissingSupplierID,
    SUM(LeadTime IS NULL) AS MissingLeadTime,
    SUM(Rating IS NULL) AS MissingRating
FROM suppliers;

SELECT
    SupplierID,
    COUNT(*) AS DuplicateCount
FROM suppliers
GROUP BY SupplierID
HAVING COUNT(*) > 1;

SELECT
    MIN(LeadTime) AS MinimumLeadTime,
    MAX(LeadTime) AS MaximumLeadTime,
    AVG(LeadTime) AS AverageLeadTime,
    SUM(LeadTime < 0) AS NegativeLeadTime
FROM suppliers;

SELECT
    COUNT(*) AS TotalRows,
    SUM(WarehouseID IS NULL) AS MissingWarehouseID,
    SUM(Location IS NULL) AS MissingLocation,
    SUM(Capacity IS NULL) AS MissingCapacity
FROM warehouse;

DESCRIBE warehouse;

SELECT
    COUNT(*) AS TotalRows,
    SUM(WarehouseID IS NULL) AS MissingWarehouseID,
    SUM(WarehouseName IS NULL) AS MissingWarehouseName,
    SUM(City IS NULL) AS MissingCity,
    SUM(Region IS NULL) AS MissingRegion,
    SUM(Capacity IS NULL) AS MissingCapacity
FROM warehouse;

SELECT
    WarehouseID,
    COUNT(*) AS DuplicateCount
FROM warehouse
GROUP BY WarehouseID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS InvalidCapacity
FROM warehouse
WHERE Capacity <= 0;

SELECT
    COUNT(*) AS TotalRows,
    SUM(OrderID IS NULL) AS MissingOrderID,
    SUM(OrderDate IS NULL) AS MissingOrderDate,
    SUM(StoreID IS NULL) AS MissingStoreID,
    SUM(ProductID IS NULL) AS MissingProductID,
    SUM(SupplierID IS NULL) AS MissingSupplierID,
    SUM(Qty IS NULL) AS MissingQty,
    SUM(Sales IS NULL) AS MissingSales,
    SUM(ShipDays IS NULL) AS MissingShipDays,
    SUM(Status IS NULL) AS MissingStatus
FROM orders;

SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS InvalidOrders
FROM orders
WHERE Qty <= 0
   OR Sales < 0
   OR ShipDays < 0;
   
SELECT
    MIN(OrderDate) AS EarliestOrderDate,
    MAX(OrderDate) AS LatestOrderDate
FROM orders;

SELECT
    Status,
    COUNT(*) AS OrderCount
FROM orders
GROUP BY Status
ORDER BY OrderCount DESC;

SELECT
    COUNT(*) AS TotalRows,
    SUM(InventoryID IS NULL) AS MissingInventoryID,
    SUM(InventoryDate IS NULL) AS MissingInventoryDate,
    SUM(ProductID IS NULL) AS MissingProductID,
    SUM(StoreID IS NULL) AS MissingStoreID,
    SUM(WarehouseID IS NULL) AS MissingWarehouseID,
    SUM(OpeningStock IS NULL) AS MissingOpeningStock,
    SUM(ReceivedQty IS NULL) AS MissingReceivedQty,
    SUM(SoldQty IS NULL) AS MissingSoldQty,
    SUM(ClosingStock IS NULL) AS MissingClosingStock,
    SUM(ReorderLevel IS NULL) AS MissingReorderLevel,
    SUM(StockStatus IS NULL) AS MissingStockStatus,
    SUM(InventoryValue IS NULL) AS MissingInventoryValue
FROM inventory;

SELECT
    InventoryID,
    COUNT(*) AS DuplicateCount
FROM inventory
GROUP BY InventoryID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS InvalidInventory
FROM inventory
WHERE OpeningStock < 0
   OR ReceivedQty < 0
   OR SoldQty < 0
   OR ClosingStock < 0
   OR ReorderLevel < 0
   OR InventoryValue < 0;
   
SELECT
    COUNT(*) AS InconsistentRecords
FROM inventory
WHERE ClosingStock <> (OpeningStock + ReceivedQty - SoldQty);

SELECT
    StockStatus,
    COUNT(*) AS RecordCount
FROM inventory
GROUP BY StockStatus
ORDER BY RecordCount DESC;

SELECT
    COUNT(*) AS TotalRows,
    SUM(ShipmentID IS NULL) AS MissingShipmentID,
    SUM(OrderID IS NULL) AS MissingOrderID,
    SUM(ProductID IS NULL) AS MissingProductID,
    SUM(SupplierID IS NULL) AS MissingSupplierID,
    SUM(WarehouseID IS NULL) AS MissingWarehouseID,
    SUM(StoreID IS NULL) AS MissingStoreID,
    SUM(ShipmentDate IS NULL) AS MissingShipmentDate,
    SUM(ExpectedDelivery IS NULL) AS MissingExpectedDelivery,
    SUM(ActualDelivery IS NULL) AS MissingActualDelivery,
    SUM(Quantity IS NULL) AS MissingQuantity,
    SUM(Carrier IS NULL) AS MissingCarrier,
    SUM(ShippingCost IS NULL) AS MissingShippingCost,
    SUM(TransitDays IS NULL) AS MissingTransitDays,
    SUM(DelayDays IS NULL) AS MissingDelayDays,
    SUM(Status IS NULL) AS MissingStatus
FROM shipments;

SELECT
    ShipmentID,
    COUNT(*) AS DuplicateCount
FROM shipments
GROUP BY ShipmentID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS InvalidShipments
FROM shipments
WHERE Quantity <= 0
   OR ShippingCost < 0
   OR TransitDays < 0
   OR DelayDays < 0;
   
SELECT
    MIN(ShipmentDate) AS EarliestShipmentDate,
    MAX(ShipmentDate) AS LatestShipmentDate
FROM shipments;

SELECT
    Status,
    COUNT(*) AS ShipmentCount
FROM shipments
GROUP BY Status
ORDER BY ShipmentCount DESC;
