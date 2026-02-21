/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF(), DATEADD()
===============================================================================
*/

-- Find the first and last date of the order
-- Find how many years of sales are available
select min(order_date) as first_order,
max(order_date) as last_order,
DATEDIFF(year, min(order_date), max(order_date)) as years_of_sales
from gold.fact_sales

-- Find the youngest and the oldest customer
select 
min(birth_date) as oldest_customer,
DATEDIFF(year, min(birth_date), GETDATE()) 
	- case when dateadd(year, DATEDIFF(year, min(birth_date), GETDATE()), min(birth_date)) > GETDATE() then 1
			else 0
	  end as oldest_customer_age,
max(birth_date) as youngest_customer,
DATEDIFF(year, max(birth_date), GETDATE()) 
	- case when dateadd(year, DATEDIFF(year, max(birth_date), GETDATE()), max(birth_date)) > GETDATE() then 1 
		else 0
	 end as youngest_customer_age
from gold.dim_customers

