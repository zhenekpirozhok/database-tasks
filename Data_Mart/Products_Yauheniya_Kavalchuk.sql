-- Create FactProductSales table and insert data:

CREATE TABLE FactProductSales (
    FactSalesID SERIAL PRIMARY KEY,
    DateID INT,
    ProductID INT,
    QuantitySold INT,
    TotalSales DECIMAL(10,2),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID)
);

INSERT INTO FactProductSales (DateID, ProductID, QuantitySold, TotalSales)
SELECT 
    (SELECT DateID FROM DimDate WHERE Date = s.Order_Date) AS DateID,
    p.Product_ID, 
    sod.Quantity, 
    (sod.Quantity * sod.Unit_Price) AS TotalSales
FROM staging_order_details sod
JOIN staging_orders s ON sod.Order_ID = s.Order_ID
JOIN staging_products p ON sod.Product_ID = p.Product_ID;



-- Top-Selling Products

SELECT 
    p.ProductName,
    SUM(fps.QuantitySold) AS TotalQuantitySold,
    SUM(fps.TotalSales) AS TotalRevenue
FROM 
    FactProductSales fps
JOIN DimProduct p ON fps.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC
LIMIT 5;


-- Products Below Reorder Level (not enough data)

SELECT 
    p.ProductName, 
    p.UnitsInStock, 
    p.ReorderLevel
FROM 
    DimProduct p
WHERE 
    p.UnitsInStock < p.ReorderLevel;

-- Sales Trends by Product Category

SELECT 
    c.CategoryName, 
    EXTRACT(YEAR FROM d.Date) AS Year,
    EXTRACT(MONTH FROM d.Date) AS Month,
    SUM(fps.QuantitySold) AS TotalQuantitySold,
    SUM(fps.TotalSales) AS TotalRevenue
FROM 
    FactProductSales fps
JOIN DimProduct p ON fps.ProductID = p.ProductID
JOIN DimCategory c ON p.CategoryID = c.CategoryID
JOIN DimDate d ON fps.DateID = d.DateID
GROUP BY c.CategoryName, Year, Month, d.Date
ORDER BY Year, Month, TotalRevenue DESC;

-- Inventory Valuation

SELECT 
    p.ProductName,
    p.UnitsInStock,
    p.UnitPrice,
    (p.UnitsInStock * p.UnitPrice) AS InventoryValue
FROM 
    DimProduct p
ORDER BY InventoryValue DESC;

-- Supplier Performance Based on Product Sales

SELECT 
    s.CompanyName,
    COUNT(DISTINCT fps.FactSalesID) AS NumberOfSalesTransactions,
    SUM(fps.QuantitySold) AS TotalProductsSold,
    SUM(fps.TotalSales) AS TotalRevenueGenerated
FROM 
    FactProductSales fps
JOIN DimProduct p ON fps.ProductID = p.ProductID
JOIN DimSupplier s ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName
ORDER BY TotalRevenueGenerated DESC;