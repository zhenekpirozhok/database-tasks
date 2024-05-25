-- Extract and load data into staging tables
-- Assuming these are correctly named in your database schema
INSERT INTO staging_orders SELECT * FROM staging.orders;
INSERT INTO staging_order_details SELECT * FROM staging.order_details;
INSERT INTO staging_products SELECT * FROM staging.products;
INSERT INTO staging_customers SELECT * FROM staging.customers;
INSERT INTO staging_employees SELECT * FROM staging.employees;
INSERT INTO staging_categories SELECT * FROM staging.categories;
INSERT INTO staging_shippers SELECT * FROM staging.shippers;
INSERT INTO staging_suppliers SELECT * FROM staging.suppliers;

-- Transform and load data into dimension tables
INSERT INTO DimCustomer (
    CustomerID, CompanyName, ContactName, ContactTitle, Address, City, 
    Region, PostalCode, Country, Phone)
SELECT 
    customer_id, company_name, contact_name, contact_title, address, city, 
    region, postal_code, country, phone
FROM 
    staging_customers;

INSERT INTO DimProduct (
    ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)
SELECT 
    product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock
FROM 
    staging_products;

INSERT INTO DimSupplier (
    SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone)
SELECT 
    supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone
FROM 
    staging_suppliers;
	
INSERT INTO DimEmployee (
    EmployeeID, LastName, FirstName, Title, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension)
SELECT 
    employee_id, last_name, first_name, title, birth_date, hire_date, address, city, region, postal_code, country, home_phone, extension
FROM 
    staging_employees;
	
INSERT INTO DimCategory (CategoryID, CategoryName, Description)
SELECT category_id, category_name, description
FROM staging_categories;

INSERT INTO DimShipper (ShipperID, CompanyName, Phone)
SELECT shipper_id, company_name, phone
FROM staging_shippers;

-- Generate and load data into DimDate
INSERT INTO DimDate (Date, Day, Month, Year, Quarter, WeekOfYear)
SELECT DISTINCT 
    order_date AS Date,
    EXTRACT(DAY FROM order_date) AS Day,
    EXTRACT(MONTH FROM order_date) AS Month,
    EXTRACT(YEAR FROM order_date) AS Year,
    EXTRACT(QUARTER FROM order_date) AS Quarter,
    EXTRACT(WEEK FROM order_date) AS WeekOfYear
FROM staging_orders;

-- Load data into FactSales
INSERT INTO FactSales (DateID, CustomerID, ProductID, EmployeeID, CategoryID, ShipperID, SupplierID, QuantitySold, UnitPrice, Discount, TaxAmount) 
SELECT
    d.DateID,   
    c.Customer_ID,  
    p.Product_ID,  
    e.Employee_ID,  
    cat.Category_ID,  
    s.Shipper_ID,  
    sup.Supplier_ID, 
    od.Quantity, 
    od.Unit_Price, 
    od.Discount,    
(od.Quantity * od.Unit_Price - od.Discount) * 0.1 AS TaxAmount     
FROM staging_order_details od 
JOIN staging_orders o ON od.Order_ID = o.Order_ID 
JOIN staging_customers c ON o.Customer_ID = c.Customer_ID 
JOIN staging_products p ON od.Product_ID = p.Product_ID  
LEFT JOIN staging_employees e ON o.Employee_ID = e.Employee_ID 
 LEFT JOIN staging_categories cat ON p.Category_ID = cat.Category_ID 
 LEFT JOIN staging_shippers s ON o.Ship_Via = s.Shipper_ID  
LEFT JOIN staging_suppliers sup ON p.Supplier_ID = sup.Supplier_ID LEFT JOIN DimDate d ON o.Order_Date = d.Date;
