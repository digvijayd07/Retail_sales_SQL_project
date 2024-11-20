CREATE TABLE sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sales FLOAT
);

select * from sales;

select * from sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	customer_id is null 
	or 
	gender is null
	or 
	category is null
	or 
	quantity is null 
	or
	cogs is null 
	or 
	total_sales is null;


-- Data Cleaning --
delete from sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	customer_id is null 
	or 
	gender is null
	or 
	category is null
	or 
	quantity is null 
	or
	cogs is null 
	or 
	total_sales is null;

-- Data exploration --
-- how many sales we have?
select count(*) as total_sales from sales

-- How many customers we have?
select count(Distinct customer_id) as total_customers from sales 

-- how many catagories we have?
select distinct category as total_categories from sales

-- Q1. Write a sql query to retrieve all columns for sales made on '2022-11-05'
select * from sales 
where sale_date = '2022-11-05';

-- -- Q2. Write a sql query to retrieve all transactions where the category is 'Clothing' and the
-- 		quantity sold is more than 4 in the month of NOV-2022 --

select * from sales
where category = 'Clothing'
	and 
	TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
	and
	quantity >= 4;

-- Q3. Write a sql query to calculate the total sales for each category.
select category, sum(total_sales) as Total_Sales, count(*) as Total_Orders
from sales
group by category;

-- Q4. Write the sql query to find the average age of customers who purchased items from the beuty category.
select Round(AVG(age), 2) as Average_age from sales
where category = 'Beauty';

-- Q5. Write a sql query to find all transactions where total sales is greater than 1000.
Select * from sales
where total_sales > 1000;

-- Q6. Write a sql query to find total number of transactios (transaction id) made by each gender in each category
SELECT year, month, avg_sales
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sales) AS avg_sales,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sales) DESC) AS rank
    FROM sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE rank = 1;

-- Q8. Write a sql query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sales) as total_sales
from sales
group by customer_id
order by total_sales desc
limit 5;

-- Q9. Write a sql query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as Count_of_unique_customers
from sales
group by category

--Q10. Write a sql query to create each shift and number of orders (ex. Morning <= 12, afternoon Between 12 & 17 , evening > 17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


