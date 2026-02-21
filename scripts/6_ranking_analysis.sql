/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products generate the highest revenue?
select top 5 f.product_key, p.product_name, sum(f.sales_amount) as total_sales from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by f.product_key, p.product_name
order by total_sales desc

-- What are the 5 worst-performing products in terms of sales?
select top 5 f.product_key, p.product_name, sum(f.sales_amount) as total_sales from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by f.product_key, p.product_name
order by total_sales

-- What are the 5 worst-performing products in terms of sales (use window functions)?
select product_key, product_name, total_sales from
(select f.product_key, p.product_name, 
sum(f.sales_amount) as total_sales, 
rank() over(order by sum(f.sales_amount)) as rn_sales
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by f.product_key, p.product_name) t
where t.rn_sales <= 5

-- Find the top 10 customers who have generated the highest revenue 
select top 10 f.customer_key, c.firstname, c.lastname, sum(sales_amount) as total_sales
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by f.customer_key, c.firstname, c.lastname
order by total_sales desc

-- Find the 3 customers with the fewest orders placed
select top 3 f.customer_key, 
c.firstname, c.lastname,
count(distinct f.order_number) as order_count
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by f.customer_key, c.firstname, c.lastname
order by order_count
