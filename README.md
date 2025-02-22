# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Analysis Sales project  
**Level**: Beginner  
**Database**: `sql_project_1`
**Dataset**: `SQL - Retail Sales Analysis_utf .csv`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales_table` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
-- Create a database
CREATE DATABASE sql_project_1;

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
```

### 2. Data Exploration

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql
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
```
### 3. Data Cleaning
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```


### 4. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05':**
```sql
SELECT * 
FROM retail_sales_table 
WHERE sale_date = "2022-11-05";
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022:**
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

**3. Write a SQL query to calculate the total sales (total_sale):**
```sql
SELECT SUM(total_sale) AS total_sales
FROM retail_sales_table;
```

4. **Write a SQL query to calculate the total sales (total_sale) for each category:**
```sql
SELECT category, COUNT(*), SUM(total_sale) 
FROM retail_sales_table
GROUP BY category;
```

**5. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:**
```sql
SELECT ROUND(AVG(age),2)
FROM retail_sales_table
WHERE category = "Beauty";
```

6. **Write a SQL query to find all transactions where the total_sale is greater than 1000:**
```sql
SELECT * 
FROM retail_sales_table
WHERE total_sale > 1000;
```

7. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:**
```sql
SELECT gender, category,COUNT(transactions_id)
FROM retail_sales_table
group by gender, category
ORDER BY category;
```

8. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:**
```sql
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
```

9. **Write a SQL query to find the top 5 customers based on the highest total sales:**
```sql
SELECT 
	customer_id,SUM(total_sale) as total_sales
FROM retail_sales_table
GROUP BY customer_id
ORDER BY total_sales DESC LIMIT 5;
```

10. **Write a SQL query to find the number of unique customers who purchased items from each category:**
```sql
SELECT category, COUNT(distinct(customer_id))
FROM retail_sales_table
GROUP BY category;
```
11. **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17):**
```sql
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
````

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub and download the files. The name of the dataset file is `SQL - Retail Sales Analysis_utf .csv`
2. **Run the Queries**: Use the SQL queries provided in the `SQL_Project_1.sql` file to perform your analysis.
3. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Susitha Arulmozhi

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/susitha-a)

Thank you for your support, and I look forward to connecting with you!
