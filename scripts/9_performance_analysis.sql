/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Analyze the yearly performance of products by comparing each 
-- product's sales to both its average sales performance and the previous year's sales
with cte_yearly_product_sales as (
select 
year(order_date) as order_year,
p.product_name,
sum(sales_amount) as current_total_sales
from gold.fact_sales f
left join gold.dim_products p
on p.product_key = f.product_key
where order_date is not null
group by year(order_date), p.product_name
)

select 
order_year, 
product_name,
current_total_sales,
avg(current_total_sales) over(partition by product_name) as average_sales,
current_total_sales - avg(current_total_sales) over(partition by product_name) as diff_avg,
case when current_total_sales - avg(current_total_sales) over(partition by product_name) > 0 then 'Above Average'
	 when current_total_sales - avg(current_total_sales) over(partition by product_name) < 0 then 'Below Average'
	 else 'Average'
end as average_change,
lag(current_total_sales) over(partition by product_name order by order_year) as previous_year_sales,
current_total_sales - lag(current_total_sales) over(partition by product_name order by order_year) as diff_previous_year,
case when current_total_sales - lag(current_total_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
	 when current_total_sales - lag(current_total_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
	 else 'No change'
end as previous_year_change
from cte_yearly_product_sales
order by product_name, order_year
