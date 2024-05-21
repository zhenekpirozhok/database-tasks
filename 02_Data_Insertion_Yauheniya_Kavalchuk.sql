-- Generate 100 rows of sample data and insert into the sales_data_2024_04 partition
DO $$
DECLARE
    v_product_id INT;
    v_region_id INT;
    v_salesperson_id INT;
    v_sale_amount NUMERIC(6, 2);
    v_sale_date DATE;
BEGIN
    FOR i IN 1..1000 LOOP
        -- Generate random values for each column
        v_product_id := trunc(random() * 100 + 1);  -- Random product_id between 1 and 100
        v_region_id := trunc(random() * 10 + 1);    -- Random region_id between 1 and 10
        v_salesperson_id := trunc(random() * 50 + 1); -- Random salesperson_id between 1 and 50
        v_sale_amount := round(CAST(random() as numeric) * 1000, 2);  -- Random sale_amount between 0.00 and 1000.00
        v_sale_date := date '2023-05-01' + trunc(random() * (date '2024-05-01' - date '2023-05-01'))::int; -- Random date

        -- Insert the generated row into the partition
        INSERT INTO sales_data (product_id, region_id, salesperson_id, sale_amount, sale_date)
        VALUES (v_product_id, v_region_id, v_salesperson_id, v_sale_amount, v_sale_date);
    END LOOP;
END $$;

select count(*) from sales_data;