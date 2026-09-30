select ordernumber, customername, sales,
case
when sales >= 5000 then 'High Value'
when sales <= 2000 then 'Medium Value'
else 'Low Value'
end as sales_category
from sales
order by sales desc;

SELECT
    CASE
        WHEN sales >= 5000 THEN 'High Value'
        WHEN sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_category,
    
    COUNT(*) AS transaction_lines,
    SUM(sales) AS total_sales
FROM sales
GROUP BY sales_category
ORDER BY total_sales DESC;

select count(*) as total_lines,
sum(case
when dealsize = 'Small' then sales
else 0
end) as small_sales,
sum(case
when dealsize = 'Medium' then sales
else 0
end) as medium_sales,
sum(case
when dealsize = 'Large' then sales
else 0
end) as large_sales
from sales;

select dealsize,
sum(sales) as total_sales,
round(sum(sales) * 100 / (select sum(sales) from sales),2)

select year(orderdate) as year,
month(orderdate) as month,
sum(sales) as total_sales,
avg(sales) as average_sales
from sales
group by year(orderdate),month(orderdate)
order by year, month; 

select
year(orderdate) as year,
month(orderdate) as month,
monthname(orderdate) as month_name,
sum(sales) as total_sales
from sales
group by year(orderdate), month(orderdate), monthname(orderdate)
order by year, month;

SELECT
    ROUND(
        SUM(sales) / COUNT(DISTINCT ordernumber),
        2
    ) AS average_order_value
FROM sales;

select customername, count(distinct ordernumber) as number_of_orders,
sum(sales) as total_sales,
sum(quantityordered) as total_quantity
from sales
group by customername
order by total_sales desc
limit 10;

select customername, 
count(distinct ordernumber) as number_of_orders,
sum(sales) as total_sales
from sales
group by customername
having count(distinct ordernumber) >=5
order by number_of_orders desc;

select productline,
count(distinct ordernumber) as number_of_orders,
sum(sales) as total_sales,
sum(quantityordered) as quantity_sold,
avg(priceeach) AS average_selling_price,
avg(percent_discount) AS average_discount
from sales
group by productline
order by total_sales desc;
