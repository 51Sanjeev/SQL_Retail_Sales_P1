CREATE DATABASE Retail_Sales_P1;
use Retail_Sales_P1;
DROP TABLE IF EXISTS Retail_Sales_tb;
create table Retail_Sales_tb
	(
		transactions_id	INT PRIMARY KEY,
        sale_date DATE,
        sale_time TIME,
        customer_id	INT,
        gender VARCHAR(15),	
        age	INT,
        category VARCHAR(20),	
        quantiy	INT,
        price_per_unit FLOAT,
        cogs FLOAT,	
        total_sale FLOAT
	);

LOAD DATA LOCAL INFILE 'E:/MYSQL/Retail_Sales_P1/SQL - Retail Sales Analysis_utf.csv'
INTO TABLE Retail_Sales_tb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @transactions_id,
    @sale_date,
    @sale_time,
    @customer_id,
    @gender,
    @age,
    @category,
    @quantiy,
    @price_per_unit,
    @cogs,
    @total_sale
)
SET
transactions_id = NULLIF(@transactions_id,''),
sale_date = NULLIF(@sale_date,''),
sale_time = NULLIF(@sale_time,''),
customer_id = NULLIF(@customer_id,''),
gender = NULLIF(@gender,''),
age = NULLIF(@age,''),
category = NULLIF(@category,''),
quantiy = NULLIF(@quantiy,''),
price_per_unit = NULLIF(@price_per_unit,''),
cogs = NULLIF(@cogs,''),
total_sale = NULLIF(@total_sale,'');

-- data cleaning 
SELECT * FROM Retail_Sales_tb
where transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantiy IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

update Retail_Sales_tb set age = 18 where age is null and transactions_id>0;
DELETE FROM Retail_Sales_tb  WHERE
    (sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantiy IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL) and transactions_id >0;
    
-- data exploration
-- total sales we have
SELECT COUNT(*) FROM Retail_Sales_tb;  

-- total unique or distinct customers we have
SELECT COUNT(DISTINCT customer_id) FROM Retail_Sales_tb;   

-- Total categories
SELECT DISTINCT category FROM Retail_Sales_tb;  

-- Data Analysis 
-- My Analysis & Findings
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

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM Retail_Sales_tb where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT category,sum(quantiy) FROM Retail_Sales_tb where category = 'Clothing' and quantiy > 10 group by category ; -- sale_date BETWEEN '2022-11-01' AND '2022-11-30';
SELECT *
FROM Retail_Sales_tb
WHERE category = 'Clothing'
  AND quantiy > 2
  AND DATE_FORMAT(Sale_date,'%Y-%m') = '2022-11';
  
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT Category,sum(total_sale) as Total_sales FROM Retail_Sales_tb GROUP BY Category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category,AVG(age) FROM Retail_sales_tb where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM Retail_Sales_tb where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender,category,count(transactions_id) FROM Retail_Sales_tb GROUP BY gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT Year_,Month_,Total_sale FROM
(
        SELECT 
			YEAR(sale_date) as Year_,
			MONTH(sale_date) as Month_,
			AVG(total_sale) as total_sale,
			RANK() OVER(partition by Year(sale_date) order by AVG(total_sale) DESC) as rank_
		FROM Retail_Sales_tb 
		GROUP BY Year_,Month_ 
		-- ORDER BY Year_,3 DESC
) as tb1 WHERE rank_ =1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT * FROM(
    SELECT 
		customer_id,
		sum(total_sale) as tot
	FROM Retail_Sales_tb 
	GROUP BY customer_id 
	ORDER BY tot DESC ) as tb2 LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,count(distinct customer_id) as unique_cutomer_cnt FROM Retail_Sales_tb GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) 
SELECT 
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evneing'
        END as shift,
	Count(transactions_id)
FROM Retail_Sales_tb
Group by shift;

-- END 




