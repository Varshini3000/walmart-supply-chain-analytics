CREATE DATABASE WALMART_SUPPLY_CHAINDB;
USE WALMART_SUPPLY_CHAINDB;

CREATE TABLE Products(
ProductID INT PRIMARY KEY,
Category VARCHAR(50),
UnitCost DECIMAL(10,2),
UnitPrice DECIMAL(10,2)
);

CREATE TABLE Stores(
StoreID INT PRIMARY KEY,
Region VARCHAR(50)
);

CREATE TABLE Suppliers(
SupplierID INT PRIMARY KEY,
LeadTime INT,
CONSTRAINT chk_supplier_leadtime
CHECK (LeadTime >= 0)
);

CREATE TABLE Warehouse(
WarehouseID VARCHAR(10) PRIMARY KEY,
WarehouseName VARCHAR(100),
City VARCHAR(50),
Region VARCHAR(50),
Capacity INT,
CONSTRAINT chk_warehouse_capacity
CHECK (Capacity >= 0)
);

CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
OrderDate DATE,
StoreID INT,
ProductID INT,
SupplierID INT,
Qty INT,
Sales DECIMAL(12,2),
ShipDays INT,
Status VARCHAR(30),

CONSTRAINT fk_orders_store
FOREIGN KEY (StoreID)
REFERENCES Stores(StoreID),

CONSTRAINT fk_orders_product
FOREIGN KEY (ProductID)
REFERENCES Products(ProductID),

CONSTRAINT fk_orders_supplier
FOREIGN KEY (SupplierID)
REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Inventory(
InventoryID VARCHAR(20) PRIMARY KEY,
InventoryDate DATE,
ProductID INT,
StoreID INT,
WarehouseID VARCHAR(10),
OpeningStock INT,
ReceivedQty INT,
SoldQty INT,
ClosingStock INT,
ReorderLevel INT,
StockStatus VARCHAR(30),
InventoryValue DECIMAL(14,2),

CONSTRAINT fk_inventory_product
FOREIGN KEY (ProductID)
REFERENCES Products(ProductID),

CONSTRAINT fk_inventory_store
FOREIGN KEY (StoreID)
REFERENCES Stores(StoreID),

CONSTRAINT fk_inventory_warehouse
FOREIGN KEY (WarehouseID)
REFERENCES Warehouses(WarehouseID)
);

USE WALMART_SUPPLY_CHAINDB;
SHOW TABLES;

CREATE TABLE Inventory(
InventoryID VARCHAR(20) PRIMARY KEY,
InventoryDate DATE,
ProductID INT,
StoreID INT,
WarehouseID VARCHAR(10),
OpeningStock INT,
ReceivedQty INT,
SoldQty INT,
ClosingStock INT,
ReorderLevel INT,
StockStatus VARCHAR(30),
InventoryValue DECIMAL(14,2),

FOREIGN KEY (ProductID)
REFERENCES products(ProductID),

FOREIGN KEY (StoreID)
REFERENCES stores(StoreID),

FOREIGN KEY (WarehouseID)
REFERENCES warehouse(WarehouseID)
);

CREATE TABLE Shipments(
ShipmentID VARCHAR(20) PRIMARY KEY,
OrderID INT,
ProductID INT,
SupplierID INT,
WarehouseID VARCHAR(10),
StoreID INT,
ShipmentDate DATE,
ExpectedDelivery DATE,
ActualDelivery DATE,
Quantity INT,
Carrier VARCHAR(50),
ShippingCost DECIMAL(12,2),
TransitDays INT,
DelayDays INT,
Status VARCHAR(30),

FOREIGN KEY (OrderID)
REFERENCES orders(OrderID),

FOREIGN KEY (ProductID)
REFERENCES products(ProductID),

FOREIGN KEY (SupplierID)
REFERENCES suppliers(SupplierID),

FOREIGN KEY (WarehouseID)
REFERENCES warehouse(WarehouseID),

FOREIGN KEY (StoreID)
REFERENCES stores(StoreID)
);