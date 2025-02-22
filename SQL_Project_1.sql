-- SQL Retail anaysis sales Project

-- Create a database
CREATE DATABASE sql_project_1;

-- Drop table if exists
DROP TABLE IF EXISTS retail_sales_table;

-- Create a table 
CREATE TABLE retail_sales_table 
			( 
			   transactions_id	INT PRIMARY KEY,
			   sale_date DATE,
			   sale_time TIME, 
			   customer_id	INT,
			   gender VARCHAR(10),
			   age	INT,
			   category	VARCHAR(15),
			   quantity INT,
			   price_per_unit FLOAT,
			   cogs	FLOAT,
			   total_sale FLOAT
			);
            
-- See if any data exists
SELECT * FROM retail_sales_table;

-- Select first 10 rows
SELECT * FROM retail_sales_table LIMIT 10;

-- Count the number of rows in the table
SELECT COUNT(*)
FROM retail_sales_table;

-- to remove entries from the table
TRUNCATE TABLE retail_sales_table;

-- Count of distinct customers
SELECT COUNT(distinct(customer_id)) FROM retail_sales_table;

-- DATA CLEANING
-- to find null values
SELECT * FROM retail_sales_table 
WHERE age IS NULL;

-- check null values of all the columns
SELECT * FROM retail_sales_table
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR 
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR 
    total_sale IS NULL
    ;
    
-- remove the null values in the table
DELETE FROM retail_sales_table
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR 
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR 
    total_sale IS NULL
    ;
    
-- DATA EXPLORATION

-- how many sales we have
SELECT 
	COUNT(*) AS total_sales 
FROM retail_sales_table;   

-- how many customers we have
SELECT 
	COUNT(distinct(customer_id)) AS no_of_customers 
FROM retail_sales_table;

-- how many categories we have 
SELECT 
	COUNT(DISTINCT(category)) AS no_of_categories
FROM retail_sales_table;

-- DATA ANALYSIS

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales_table 
WHERE sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT * 
FROM retail_sales_table
WHERE 
	category = "Clothing"
    AND
    quantity >= 4
    AND
    sale_date BETWEEN '2022-11-01' and '2022-11-30'; 
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale).
SELECT SUM(total_sale) AS total_sales
FROM retail_sales_table;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, COUNT(*), SUM(total_sale) 
FROM retail_sales_table
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)
FROM retail_sales_table
WHERE category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales_table
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category,COUNT(transactions_id)
FROM retail_sales_table
group by gender, category
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
	year,
    month,
	sale
FROM
(
	SELECT 
		ROUND(AVG(total_sale),2) as sale, 
		YEAR(sale_date) as year, 
		MONTH(sale_date) as month,
		RANK() OVER (partition by YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) as Rank_col
	FROM retail_sales_table 
	GROUP BY year, month 
	ORDER BY year, sale DESC
) AS Table_1 WHERE Rank_col = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,SUM(total_sale) as total_sales
FROM retail_sales_table
GROUP BY customer_id
ORDER BY total_sales DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(distinct(customer_id))
FROM retail_sales_table
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hour_sale 
AS 
(
	SELECT *,
		CASE
		  WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN  "Morning"
		  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN  "Afternoon"
		  WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN "Evening"
		END AS shift_type
FROM retail_sales_table
)
SELECT shift_type, COUNT(*)
FROM hour_sale WHERE shift_type IS NOT NULL
GROUP BY shift_type;




    

	


	





