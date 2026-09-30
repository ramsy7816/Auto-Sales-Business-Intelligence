use auto_sales_analysis;

SELECT COUNT(*) AS total_rows
FROM sales;

DESCRIBE sales;

SELECT
    MIN(orderdate) AS first_order_date,
    MAX(orderdate) AS last_order_date
FROM sales;

SELECT
    SUM(sales) AS total_sales
FROM sales;

SELECT
    COUNT(DISTINCT ordernumber) AS total_orders
FROM sales;

SELECT
    COUNT(DISTINCT customername) AS total_customers
FROM sales;

SELECT
    SUM(quantityordered) AS total_quantity_sold
FROM sales;

SELECT
    year,
    SUM(sales) AS total_sales
FROM sales
GROUP BY year
ORDER BY year;

SELECT
    productline,
    SUM(sales) AS total_sales
FROM sales
GROUP BY productline
ORDER BY total_sales DESC;

SELECT
    customername,
    SUM(sales) AS total_sales
FROM sales
GROUP BY customername
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    country,
    SUM(sales) AS total_sales
FROM sales
GROUP BY country
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    dealsize,
    COUNT(DISTINCT ordernumber) AS total_orders,
    SUM(sales) AS total_sales,
    AVG(sales) AS average_sales
FROM sales
GROUP BY dealsize
ORDER BY total_sales DESC;

SELECT
    status,
    COUNT(DISTINCT ordernumber) AS total_orders,
    SUM(sales) AS total_sales
FROM sales
GROUP BY status
ORDER BY total_sales DESC;

SELECT
    customername,
    SUM(sales) AS total_sales
FROM sales
GROUP BY customername
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC;

