ALTER TABLE DimEmployee ADD COLUMN IF NOT EXISTS StartDate DATE;
ALTER TABLE DimEmployee ADD COLUMN IF NOT EXISTS EndDate DATE;
ALTER TABLE DimEmployee ADD COLUMN IF NOT EXISTS RecordID SERIAL;

-- Remove a primary key constraint from a column
ALTER TABLE DimEmployee
DROP CONSTRAINT dimemployee_pkey CASCADE;

-- Add a primary key constraint to an existing column
ALTER TABLE DimEmployee
ADD CONSTRAINT dimemployee_pk PRIMARY KEY (EmployeeID, RecordID);


CREATE OR REPLACE FUNCTION update_dimemployees()
RETURNS TRIGGER AS
$$
BEGIN
    -- Trigger logic for handling INSERT, UPDATE, and DELETE operations
    -- Example logic:
    IF TG_OP = 'INSERT' THEN
        -- Handle INSERT operation
        INSERT INTO DimEmployee (
            EmployeeID, LastName, FirstName, Title, BirthDate, HireDate, Address, 
            City, Region, PostalCode, Country, HomePhone, Extension, StartDate, EndDate
        ) VALUES (
            NEW.employee_id, NEW.last_name, NEW.first_name, NEW.title, NEW.birth_date, NEW.hire_date, 
            NEW.address, NEW.city, NEW.region, NEW.postal_code, NEW.country, 
            NEW.home_phone, NEW.extension, CURRENT_DATE, NULL
        );
    ELSIF TG_OP = 'UPDATE' THEN
        -- Handle UPDATE operation
        UPDATE DimEmployee
        SET EndDate = CURRENT_DATE
        WHERE EmployeeID = OLD.employee_id AND EndDate IS NULL;

        INSERT INTO DimEmployee (
            EmployeeID, LastName, FirstName, Title, BirthDate, HireDate, Address, 
            City, Region, PostalCode, Country, HomePhone, Extension, StartDate, EndDate
        ) VALUES (
            OLD.employee_id, NEW.last_name, NEW.first_name, NEW.title, NEW.birth_date, NEW.hire_date, 
            NEW.address, NEW.city, NEW.region, NEW.postal_code, NEW.country, 
            NEW.home_phone, NEW.extension, CURRENT_DATE, NULL
        );
    ELSIF TG_OP = 'DELETE' THEN
        -- Handle DELETE operation
        UPDATE DimEmployee
        SET EndDate = CURRENT_DATE
        WHERE EmployeeID = OLD.employee_id AND EndDate IS NULL;
    END IF;

    RETURN NULL;
END;
$$
LANGUAGE plpgsql;


-- Update the trigger to include INSERT, UPDATE, and DELETE operations
CREATE OR REPLACE TRIGGER manage_scd
AFTER INSERT OR UPDATE OR DELETE ON staging_employees
FOR EACH ROW
EXECUTE FUNCTION update_dimemployees();


select * from staging_employees;
select * from dimEmployee;

-- Test changes to staging table
INSERT INTO staging_employees (
    employee_id, last_name, first_name, title, title_of_courtesy, birth_date, hire_date, 
    address, city, region, postal_code, country, home_phone, extension, notes, reports_to, photo_path
) VALUES (
    10, 'Smith', 'John', 'Regional Manager', 'Mr.', '1980-01-01', '2020-01-10',
    '123 Elm St', 'Anytown', 'NT', '12345', 'USA', '555-555-1234', '5678', 
    'John is a very experienced manager.', 100, 'images/john.jpg'
);

UPDATE staging_employees
SET first_name = 'Will'
WHERE employee_id = 10;

DELETE FROM staging_employees
WHERE employee_id = 10;
