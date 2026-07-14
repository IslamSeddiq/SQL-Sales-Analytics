USE Retail_Sales

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS

-- Data cleaning

--Check nulls
SELECT *
FROM Retail_Sales
WHERE transactions_id IS NULL
	  OR sale_date IS NULL 
	  OR sale_time IS NULL
	  OR gender IS NULL
      OR category IS NULL
      OR quantity IS NULL
      OR cogs IS NULL
      OR total_sale IS NULL

-- Remove nulls
DELETE FROM Retail_Sales
WHERE transactions_id IS NULL
	  OR sale_date IS NULL 
	  OR sale_time IS NULL
	  OR gender IS NULL
      OR category IS NULL
      OR quantity IS NULL
      OR cogs IS NULL
      OR total_sale IS NULL

-- Data Exploration

-- Check the number of transactions
SELECT COUNT(*) Total_transactions
FROM Retail_Sales

-- How many uniuque customers we have
SELECT COUNT(DISTINCT customer_id) Total_customers
FROM Retail_Sales

-- Identify all available product categories
SELECT DISTINCT category
FROM Retail_Sales

-- Identify the quantity range
SELECT DISTINCT quantity
FROM Retail_Sales
ORDER BY quantity

-- Identify all available years
SELECT DISTINCT YEAR(sale_date) Years
FROM Retail_Sales

----> Business Analysis & Answering Questions

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM Retail_Sales
WHERE sale_date = '2022-11-05'

/* Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
   and the quantity sold equals 3 in the month of Nov-2022 */
SELECT category, quantity, sale_date
FROM Retail_Sales
WHERE 
	  category = 'Clothing'
	  AND 
		quantity = 4
	  AND 
		YEAR(sale_date) = 2022
	  AND
		MONTH(sale_date) = 11

-- Q.3 Write a SQL query to calculate the total sales for each category
SELECT category, SUM(total_sale) Total_Sales
FROM Retail_Sales
GROUP BY category
ORDER BY Total_Sales DESC

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age), 2) Avg_Age
FROM Retail_Sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT * 
FROM Retail_Sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender, COUNT(transactions_id) Total_Transactions
FROM Retail_Sales
GROUP BY category, gender
ORDER BY 1, 3 DESC

/* Q.7 Write a SQL query to calculate the average sale for each month.
   Find out best selling month in each year */
SELECT
    Sales_Year,
    DATENAME(MONTH, DATEFROMPARTS(Sales_Year, Sales_Month, 1)) AS Month_Name,
    Avg_Sale
FROM
(
    SELECT
        YEAR(sale_date) AS Sales_Year,
        MONTH(sale_date) AS Sales_Month,
        AVG(total_sale) AS Avg_Sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(Total_Sale) DESC
        ) AS Rank_No
    FROM Retail_Sales
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
) AS MonthlySales
WHERE Rank_No = 1
ORDER BY Sales_Year

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT TOP 5 customer_id, SUM(total_sale) Total_Sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY Total_Sales DESC

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) Total_Customers
FROM Retail_Sales
GROUP BY category

/* Q.10 Write a SQL query to create each shift and number of orders
  (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) */
WITH hourly_sale
AS (
	SELECT *,
		CASE 
			WHEN DATEPART(HOUR, sale_time) <= 12 THEN 'Morning'
			WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END [Shift]
	FROM Retail_Sales
	)s
SELECT [Shift], 
	   COUNT(*) Total_orders
FROM hourly_sale
GROUP BY [shift]

-- End of project