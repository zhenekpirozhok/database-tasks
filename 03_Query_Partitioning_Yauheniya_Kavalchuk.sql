-- All from April, 2024
SELECT * 
FROM sales_data
WHERE sale_date >= '2024-04-01' AND sale_date < '2024-05-01';

SELECT 
    EXTRACT(month from sale_date) AS month,
    SUM(sale_amount) AS total_sale_amount
FROM sales_data
GROUP BY month
ORDER BY month;

SELECT 
    salesperson_id,
    SUM(sale_amount) AS total_sale_amount
FROM sales_data
WHERE region_id = 5
GROUP BY salesperson_id
ORDER BY total_sale_amount DESC
LIMIT 3;
