/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


-- Segment products into cost ranges and count how many products fall into each segment
with cte_product_segmentation as (
select
product_key,
product_name,
product_cost, 
case when product_cost < 100 then 'Below 100'
	 when product_cost between 100 and 500 then '100-500'
	 when product_cost between 501 and 1000 then '501-1000'
	 else 'Above 1000'
end as cost_range
from gold.dim_products
)
select cost_range, 
count(*) as total_products 
from cte_product_segmentation
group by cost_range
order by total_products


-- Group customers into three segments based on their spending behaviour
-- VIP: atleast 12 months of history and spending more than 5000
-- Regular: atleast 12 months of history but spending 5000 or less
-- New: lifespan less than 12 months
-- And find the total number of customers by each group
with cte_customer_spending as (
select c.customer_key, 
sum(f.sales_amount) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
datediff(month, min(order_date), max(order_date)) as lifespan
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key
)
, cte_customer_segmentation as (
select
customer_key,
total_spending,
lifespan,
case when lifespan >= 12 and total_spending > 5000 then 'VIP'
	 when lifespan >=12 and total_spending <= 5000 then 'Regular'
	 else 'New'
end as customer_segment
from cte_customer_spending
)
select customer_segment, 
count(customer_key) as total_customers 
from cte_customer_segmentation
group by customer_segment
order by customer_segment desc
