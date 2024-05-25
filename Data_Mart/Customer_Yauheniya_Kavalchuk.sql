CREATE TABLE FactCustomerSales (
    FactCustomerSalesID SERIAL PRIMARY KEY,
    DateID INT,
    CustomerID VARCHAR(5),
    TotalAmount DECIMAL(10,2),
    TotalQuantity INT,
    NumberOfTransactions INT,
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID)
);

INSERT INTO FactCustomerSales (DateID, CustomerID, TotalAmount, TotalQuantity, NumberOfTransactions)
SELECT
    d.DateID,
    c.CustomerID,
    SUM(od.Quantity * od.Unit_price) AS TotalAmount,
    SUM(od.Quantity) AS TotalQuantity,
    COUNT(DISTINCT o.Order_ID) AS NumberOfTransactions
FROM
    staging_orders AS o
JOIN
    staging_order_details AS od ON o.Order_ID = od.Order_ID
JOIN
    DimDate AS d ON d.Date = o.Order_Date
JOIN
    DimCustomer AS c ON c.CustomerID = o.Customer_ID
GROUP BY
    d.DateID,
    c.CustomerID;

-- Customer Sales Overview

SELECT 
    c.CustomerID, 
    c.CompanyName, 
    SUM(fcs.TotalAmount) AS TotalSpent,
    SUM(fcs.TotalQuantity) AS TotalItemsPurchased,
    SUM(fcs.NumberOfTransactions) AS TransactionCount
FROM 
    FactCustomerSales fcs
JOIN DimCustomer c ON fcs.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalSpent DESC;

-- Top Five Customers by Total Sales

SELECT 
    c.CompanyName,
    SUM(fcs.TotalAmount) AS TotalSpent
FROM 
    FactCustomerSales fcs
JOIN DimCustomer c ON fcs.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY TotalSpent DESC
LIMIT 5;

-- Customers by Region

SELECT 
    c.Region,
    COUNT(*) AS NumberOfCustomers,
    SUM(fcs.TotalAmount) AS TotalSpentInRegion
FROM 
    FactCustomerSales fcs
JOIN DimCustomer c ON fcs.CustomerID = c.CustomerID
WHERE region IS NOT NULL
GROUP BY c.Region
ORDER BY NumberOfCustomers DESC;


-- Customer Segmentation Analysis

SELECT 
    c.CustomerID, 
    c.CompanyName,
    CASE
        WHEN SUM(fcs.TotalAmount) > 10000 THEN 'VIP'
        WHEN SUM(fcs.TotalAmount) BETWEEN 5000 AND 10000 THEN 'Premium'
        ELSE 'Standard'
    END AS CustomerSegment
FROM 
    FactCustomerSales fcs
JOIN DimCustomer c ON fcs.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY SUM(fcs.TotalAmount) DESC;