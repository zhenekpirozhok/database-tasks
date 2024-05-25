-- Check for orphaned CustomerID in FactSales
SELECT fs.CustomerID 
FROM FactSales fs 
LEFT JOIN DimCustomer dc ON fs.CustomerID = dc.CustomerID 
WHERE dc.CustomerID IS NULL;

-- Check for orphaned ProductID in FactSales
SELECT fs.ProductID 
FROM FactSales fs 
LEFT JOIN DimProduct dp ON fs.ProductID = dp.ProductID 
WHERE dp.ProductID IS NULL;

-- Check for orphaned EmployeeID in FactSales
SELECT fs.EmployeeID 
FROM FactSales fs 
LEFT JOIN DimEmployee de ON fs.EmployeeID = de.EmployeeID 
WHERE de.EmployeeID IS NULL;

-- Check for orphaned CategoryID in FactSales
SELECT fs.CategoryID 
FROM FactSales fs 
LEFT JOIN DimCategory dc ON fs.CategoryID = dc.CategoryID 
WHERE dc.CategoryID IS NULL;

-- Check for orphaned ShipperID in FactSales
SELECT fs.ShipperID 
FROM FactSales fs 
LEFT JOIN DimShipper ds ON fs.ShipperID = ds.ShipperID 
WHERE ds.ShipperID IS NULL;

-- Check for orphaned SupplierID in FactSales
SELECT fs.SupplierID 
FROM FactSales fs 
LEFT JOIN DimSupplier ds ON fs.SupplierID = ds.SupplierID 
WHERE ds.SupplierID IS NULL;

-- Check for orphaned DateID in FactSales
SELECT fs.DateID 
FROM FactSales fs 
LEFT JOIN DimDate dd ON fs.DateID = dd.DateID 
WHERE dd.DateID IS NULL;

-- Compare row counts between staging and dimension tables
SELECT 
    (SELECT COUNT(*) FROM staging_customers) AS staging_count, 
    (SELECT COUNT(*) FROM DimCustomer) AS dim_count;

SELECT 
    (SELECT COUNT(*) FROM staging_products) AS staging_count, 
    (SELECT COUNT(*) FROM DimProduct) AS dim_count;

SELECT 
    (SELECT COUNT(*) FROM staging_employees) AS staging_count, 
    (SELECT COUNT(*) FROM DimEmployee) AS dim_count;

SELECT 
    (SELECT COUNT(*) FROM staging_categories) AS staging_count, 
    (SELECT COUNT(*) FROM DimCategory) AS dim_count;

SELECT 
    (SELECT COUNT(*) FROM staging_shippers) AS staging_count, 
    (SELECT COUNT(*) FROM DimShipper) AS dim_count;

SELECT 
    (SELECT COUNT(*) FROM staging_suppliers) AS staging_count, 
    (SELECT COUNT(*) FROM DimSupplier) AS dim_count;

-- Compare sales totals between staging and fact tables
SELECT 
    (SELECT SUM(od.quantity * od.unit_price - od.discount) 
     FROM staging_order_details od) AS staging_total, 
    (SELECT SUM(TotalAmount) FROM FactSales) AS fact_total;
