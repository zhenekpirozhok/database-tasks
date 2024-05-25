-- Step 1.

-- Create a fact table
CREATE TABLE FactSupplierPurchases (
    PurchaseID SERIAL PRIMARY KEY,
    SupplierID INT,
    TotalPurchaseAmount DECIMAL,
    PurchaseDate DATE,
    NumberOfProducts INT,
    FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID)
);

-- Populate the FactSupplierPurchases table with data aggregated from the staging tables

INSERT INTO FactSupplierPurchases (SupplierID, TotalPurchaseAmount, PurchaseDate, NumberOfProducts)
SELECT 
    p.Supplier_ID, 
    SUM(od.Unit_Price * od.Quantity) AS TotalPurchaseAmount, 
    CURRENT_DATE AS PurchaseDate, 
    COUNT(DISTINCT od.Product_ID) AS NumberOfProducts
FROM staging_order_details od
JOIN staging_products p ON od.Product_ID = p.Product_ID
GROUP BY p.Supplier_ID;

-- Supplier Performance Report (not enough data to execute)

SELECT
    s.CompanyName,
    AVG(fsp.DeliveryLeadTime) AS AverageLeadTime,
    SUM(fsp.OrderAccuracy) / COUNT(fsp.PurchaseID) AS AverageOrderAccuracy,
    COUNT(fsp.PurchaseID) AS TotalOrders
FROM FactSupplierPurchases fsp
JOIN DimSupplier s ON fsp.SupplierID = s.SupplierID
GROUP BY s.CompanyName
ORDER BY AverageLeadTime, AverageOrderAccuracy DESC;

-- Supplier Spending Analysis

SELECT
    s.CompanyName,
    SUM(fsp.TotalPurchaseAmount) AS TotalSpend,
    EXTRACT(YEAR FROM fsp.PurchaseDate) AS Year,
    EXTRACT(MONTH FROM fsp.PurchaseDate) AS Month
FROM FactSupplierPurchases fsp
JOIN DimSupplier s ON fsp.SupplierID = s.SupplierID
GROUP BY s.CompanyName, Year, Month
ORDER BY TotalSpend DESC;

-- Product Cost Breakdown by Supplier

SELECT
    s.CompanyName,
    p.Product_Name,
    AVG(od.Unit_Price) AS AverageUnitPrice,
    SUM(od.Quantity) AS TotalQuantityPurchased,
    SUM(od.Unit_Price * od.Quantity) AS TotalSpend
FROM staging_order_details od
JOIN staging_products p ON od.Product_ID = p.Product_ID
JOIN DimSupplier s ON p.Supplier_ID = s.SupplierID
GROUP BY s.CompanyName, p.Product_Name
ORDER BY s.CompanyName, TotalSpend DESC;

-- Supplier Reliability Score Report (not enough data)

SELECT
    s.CompanyName,
    (COUNT(fsp.PurchaseID) FILTER (WHERE fsp.OnTimeDelivery = TRUE) / COUNT(fsp.PurchaseID)::FLOAT) * 100 AS ReliabilityScore
FROM FactSupplierPurchases fsp
JOIN DimSupplier s ON fsp.SupplierID = s.SupplierID
GROUP BY s.CompanyName
ORDER BY ReliabilityScore DESC;

-- Top Five Products by Total Purchases per Supplier

SELECT
    s.CompanyName,
    p.Product_Name AS productname,
    SUM(od.Unit_Price * od.Quantity) AS TotalSpend
FROM staging_order_details od
JOIN staging_products p ON od.Product_ID = p.Product_ID
JOIN DimSupplier s ON p.Supplier_ID = s.SupplierID
GROUP BY s.CompanyName, p.Product_Name
ORDER BY s.CompanyName, TotalSpend DESC
LIMIT 5;

