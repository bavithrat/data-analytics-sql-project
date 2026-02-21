/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the total sales
select  
sum(sales_amount) as total_sales
from gold.fact_sales

-- Find how many items are sold
select  
sum(quantity) as total_quantity
from gold.fact_sales

-- Find the average selling price
select  
avg(price) as average_selling_price
from gold.fact_sales

-- Find the total number of orders
select  
count(order_number) as total_orders
from gold.fact_sales

select  
count(distinct order_number) as total_distinct_orders
from gold.fact_sales


-- Find the total number of products
select  
count(product_key) as total_products
from gold.dim_products

select  
count(distinct product_key) as total_products
from gold.dim_products


-- Find the total number of customers
select  
count(customer_key) as total_customers
from gold.dim_customers


-- Find the total number of customers who has placed an order
select  
count(distinct c.customer_key) as total_customers
from gold.fact_sales s 
inner join gold.dim_customers c
on c.customer_key = s.customer_key


-- Generate a report that shows all key metrics of the business
select 'Total sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'Total quantity' as measure_name, sum(quantity) as measure_value from gold.fact_sales
union all
select 'Average selling price' as measure_name, avg(price) as measure_value from gold.fact_sales
union all
select 'Total orders' as measure_name, count(distinct order_number) as measure_value from gold.fact_sales
union all
select 'Total products' as measure_name, count(distinct product_key) as measure_value from gold.dim_products
union all
select 'Total customers' as measure_name, count(customer_key) as measure_value from gold.dim_customers
union all
select 'Total customers who placed an order' as measure_name, count(distinct customer_key) as measure_value from gold.fact_sales
