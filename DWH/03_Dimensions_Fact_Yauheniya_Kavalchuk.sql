CREATE TABLE DimDate (
    DateID SERIAL PRIMARY KEY,
    Date DATE NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    WeekOfYear INT NOT NULL
);

CREATE TABLE DimCustomer (
    CustomerID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(100),
    Region VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE DimEmployee (
    EmployeeID SERIAL PRIMARY KEY,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    Title VARCHAR(100),
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(255),
    City VARCHAR(100),
    Region VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100),
    HomePhone VARCHAR(20),
    Extension VARCHAR(10)
);

CREATE TABLE DimCategory (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL,
    Description TEXT
);

CREATE TABLE DimShipper (
    ShipperID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20)
);

CREATE TABLE DimSupplier (
    SupplierID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(100),
    Region VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE DimProduct (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(100),
    UnitPrice NUMERIC(10, 2),
    UnitsInStock INT,
    FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES DimCategory(CategoryID)
);

CREATE TABLE FactSales (
    SalesID SERIAL PRIMARY KEY,
    DateID INT,
    CustomerID VARCHAR(5),
    ProductID INT,
    EmployeeID INT,
    CategoryID INT,
    ShipperID INT,
    SupplierID INT,
    QuantitySold INT,
    UnitPrice NUMERIC(10, 2),
    Discount NUMERIC(10, 2),
    TotalAmount NUMERIC(10, 2) GENERATED ALWAYS AS (QuantitySold * UnitPrice - Discount) STORED,
    TaxAmount NUMERIC(10, 2),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (EmployeeID) REFERENCES DimEmployee(EmployeeID),
    FOREIGN KEY (CategoryID) REFERENCES DimCategory(CategoryID),
    FOREIGN KEY (ShipperID) REFERENCES DimShipper(ShipperID),
    FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID)
);
