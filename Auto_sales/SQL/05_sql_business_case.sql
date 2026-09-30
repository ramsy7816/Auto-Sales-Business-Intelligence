use auto_sales_analysis;

-- 1. what is the overall sales perfomance?
SELECT
    SUM(sales) AS total_sales,
    COUNT(DISTINCT ordernumber) AS total_orders,
    COUNT(customername) AS total_customers,
    SUM(quantityordered) AS total_units_sold,
    ROUND(
        SUM(sales) / COUNT(DISTINCT ordernumber),
        2
    ) AS average_order_value
FROM sales;

-- 2. what is the annual sales perfomance?
SELECT
    year,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT ordernumber) AS total_orders,
        SUM(quantityordered) AS units_sold
FROM auto_sales
GROUP BY year
ORDER BY year;
    
-- 3. what is the year-over-year growth?
WITH yearly_sales AS (
    SELECT
        year,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY year
),

yearly_comparison AS (
    SELECT
        year,
        total_sales,

        LAG(total_sales) OVER (
            ORDER BY year
        ) AS previous_year_sales

    FROM yearly_sales
)

SELECT
    year,
    total_sales,
    previous_year_sales,

    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS yoy_growth_percentage

FROM yearly_comparison
ORDER BY year;

/* product perfomance
4. which product line generate the most revenue?*/
select productline,
sum(sales) as total_sales,
sum(quantityordered) as units_sold,
count(distinct ordernumber) as total_orders,
round(avg(priceeach),2) as average_price
from sales
group by productline
order by total_sales desc
limit 5;

-- 5. what percentage of revenue does each product line contribute?
select productline, sum(sales) as total_sales,
round(
sum(sales) * 100 / 
(select sum(sales) from sales),2
) as revenue_percentage
from sales
group by productline;

-- 6. which product lines have the highest average discount?
select productline, sum(sales) as total_sales, round(avg(percent_discount),2) as average_percentage_discount
from sales
group by productline
order by average_percentage_discount desc;

/* Customer Analysis
7. who are the top ten customers?*/
select customername, 
sum(sales) as total_sales,
round(avg(sales),2) as average_sales,
sum(quantityordered) as units_purchased,
count(distinct ordernumber) as total_orders
from sales
group by customername
order by total_sales desc
limit 10;

-- 8. which customers have the highest orders?
select customername, count(distinct ordernumber) as total_orders
from sales
group by customername
order by total_orders desc
limit 10;

-- 9. rank customers by revenue
with customer_sales as(
select customername, sum(sales) as total_sales
from sales
group by customername
)
select customername, total_sales,
rank() over(order by total_sales desc) as customer_rank
from customer_sales;

/* geographic analysis
10. which countries generate the most revenue*/
select country,
count(distinct ordernumber) as total_orders,
count(distinct customername) as customers,
sum(quantityordered) as units_sold,
sum(sales) as total_sales
from sales
group by country
order by total_sales desc
limit 10;

-- 11. which cities generate the most revenue?
select city, country, 
count(distinct ordernumber) as total_orders,
count(distinct customername) as customers,
sum(quantityordered) as units_sold,
sum(sales) as total_sales
from sales
group by city, country
order by total_sales desc;

/* deal size analysis
12. how does deal size affect sales?*/
select dealsize, 
count(distinct ordernumber) as total_orders,
count(distinct customername) as customers,
sum(quantityordered) as units_sold,
sum(sales) as total_sales,
round(sum(sales)/ count(distinct ordernumber),2) as average_order_value
from sales
group by dealsize
order by total_sales desc;

/* order status
13. what is the sales distribution by order status?*/
select status,
count(distinct ordernumber) as total_orders,
sum(sales) as total_sales,
round(sum(sales) * 100 / (select sum(sales) from sales),2) as revenue_percentage
from sales
group by status
order by total_sales desc;

/* monthly perfomance
14. which months perfom best?*/
select  year(orderdate) as Year,
month(orderdate) as Month,
monthname(orderdate) as month_name,
sum(sales) as total_sales
from sales
group by year(orderdate),
month(orderdate),
monthname(orderdate)
order by total_sales desc;

-- 15. what is the monthly sales growth?
with monthly_sales as (
select year(orderdate) as year, month(orderdate) as month, sum(sales) as total_sales
from sales
group by year(orderdate), month(orderdate)
),
monthly_comparison as(
select year, month, total_sales,
lag(total_sales) over(order by year, month) as previous_monthly_sales
from monthly_sales
)
select year, month, total_sales, previous_monthly_sales,
round((total_sales - previous_monthly_sales)/nullif(previous_monthly_sales, 0) * 100, 2) as monthly_growth_percentage
from monthly_comparison
order by year, month;

-- 16. top product in each country
with product_sales as(
select country, productline, count(distinct ordernumber) as total_orders, sum(sales) as total_sales
from sales
group by country, productline
),
monthly_rank as (
select country, productline, total_orders, total_sales,
row_number() over(partition by country
order by total_sales desc)as product_rank
from product_sales
)
select country, productline, total_orders, total_sales, product_rank
from monthly_rank
where product_rank = 1
order by country;

-- how much revenue comes from the top_ten customers?
with revenue_concentration as(
select customername, sum(sales) as total_sales
from sales
group by customername
),
total_revenue as(
select customername, total_sales,
rank() over(order by total_sales) as top_customers
from revenue_concentration
)
select sum(total_sales) as top_ten_customer_sales
from total_revenue
where top_customers <= 10;