-- Staging table for Orders
CREATE TABLE staging_orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(5),
    employee_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    ship_via INT,
    freight NUMERIC(10, 2),
    ship_name VARCHAR(40),
    ship_address VARCHAR(60),
    ship_city VARCHAR(15),
    ship_region VARCHAR(15),
    ship_postal_code VARCHAR(10),
    ship_country VARCHAR(15)
);

-- Staging table for Order Details
CREATE TABLE staging_order_details (
    order_id INT,
    product_id INT,
    unit_price NUMERIC(10, 2),
    quantity INT,
    discount NUMERIC(3, 2),
    PRIMARY KEY (order_id, product_id)
);

-- Staging table for Products
CREATE TABLE staging_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(40),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR(20),
    unit_price NUMERIC(10, 2),
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued INT
);

-- Staging table for Customers
CREATE TABLE staging_customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    company_name VARCHAR(40),
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24)
);

-- Staging table for Employees
CREATE TABLE staging_employees (
    employee_id INT PRIMARY KEY,
    last_name character varying(20) NOT NULL,
    first_name character varying(10) NOT NULL,
    title character varying(30),
    title_of_courtesy character varying(25),
    birth_date date,
    hire_date date,
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    home_phone character varying(24),
    extension character varying(4),
    photo bytea,
    notes text,
    reports_to smallint,
    photo_path character varying(255)
);

-- Staging table for Categories
CREATE TABLE staging_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(15),
    description TEXT,
    picture BYTEA
);

-- Staging table for Shippers
CREATE TABLE staging_shippers (
    shipper_id INT PRIMARY KEY,
    company_name VARCHAR(40),
    phone VARCHAR(24)
);

-- Staging table for Suppliers
CREATE TABLE staging_suppliers (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(40),
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24),
    homepage TEXT
);
