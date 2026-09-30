
WITH product_sales AS (
    SELECT productline, SUM(sales) AS total_sales
    FROM sales
    GROUP BY productline
)
SELECT *
FROM product_sales
ORDER BY total_sales DESC;

with product_sales as(
select productline, sum(sales) as total_sales
from sales
group by productline
)
select * from product_sales
where total_sales >= 1000000;

with product_sales as(
select productline, sum(sales) as total_sales
from sales
group by productline
)
select productline, total_sales,
rank() over(order by total_sales desc) as sales_rank
from product_sales;

with product_sales as(
select customername, sum(sales) as total_Sales
from sales
group by customername
)
select customername, total_sales,
rank() over(order by total_sales desc) as customer_rank
from product_sales;

with customer_country_sales as(
select country, customername, sum(sales) as total_sales
from sales
group by country, customername
)
 select country, customername, total_sales,
 rank() over(partition by country
 order by total_sales desc) as country_customer_rank
 from customer_country_sales
 order by
    country,
    country_customer_rank;
    
with customer_country_sales as(
select country, customername, sum(sales) as total_sales
from sales
group by country, customername
),
ranked_customers as(
select country, customername, total_sales,
row_number() over(
partition by country
order by total_sales desc) as customer_rank
from customer_country_sales

)
 select country, customername, total_sales
 from ranked_customers
 where customer_rank = 1
 order by country;
 
 WITH monthly_sales AS (
    SELECT
        YEAR(orderdate) AS year,
        MONTH(orderdate) AS month,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY
        YEAR(orderdate),
        MONTH(orderdate)
)

SELECT
    year,
    month,
    total_sales,

    LAG(total_sales) OVER (
        ORDER BY year, month
    ) AS previous_month_sales

FROM monthly_sales

ORDER BY year, month;

WITH monthly_sales AS (
    SELECT
        YEAR(orderdate) AS year,
        MONTH(orderdate) AS month,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY
        YEAR(orderdate),
        MONTH(orderdate)
),

monthly_comparison AS (
    SELECT
        year,
        month,
        total_sales,

        LAG(total_sales) OVER (
            ORDER BY year, month
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    year,
    month,
    total_sales,
    previous_month_sales,

    ROUND(
        (total_sales - previous_month_sales)
        / previous_month_sales * 100,
        2
    ) AS monthly_growth_percentage

FROM monthly_comparison

ORDER BY year, month;

