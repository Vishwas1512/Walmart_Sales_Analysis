CREATE DATABASE WalmartSalesData;
USE WalmartSalesData;
 
CREATE TABLE walmartsalesdata(
    invoice_id VARCHAR(30),
    branch VARCHAR(5),
    city VARCHAR(30),
    customer_type VARCHAR(30),
    gender VARCHAR(10),
    product_line VARCHAR(100),
    unit_price double,
    quantity INT,
    VAT DOUBLE,
    total double,
    Date DATE,
    Time TIME,
    payment_method VARCHAR(30),
    cogs double,
    gross_margin_percentage double,
    gross_income double,
    rating double
);


-- 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made
-- 2. Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest
-- Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

ALTER TABLE walmartsalesdata
ADD Time_of_day varchar(30),
ADD day_name varchar(30),
ADD month_name varchar(30);

UPDATE walmartsalesdata 
SET day_name = DAYNAME(date);
UPDATE walmartsalesdata 
SET month_name = MONTHNAME(date);
-- Show all th data
SELECT * FROM walmartsalesdata;
SET sql_safe_updates = 0;


 
UPDATE walmartsalesdata
SET Time_of_day =
CASE
    WHEN Time >= "00:00:00" AND Time <= "11:59:00"THEN 'Morning'
    WHEN  Time >= "12:00:00" AND Time <= "17:59:00" THEN 'Afternoon'
    ELSE 'Evening'
END;

-- BusinessQuestions To Answer GenericQuestion
-- 1. How many unique cities does the data have?
SELECT DISTINCT city FROM walmartsalesdata;

-- 2. In which city is each branch?
SELECT DISTINCT city, branch FROM walmartsalesdata
GROUP BY city,branch;

-- Product
-- 1. How many unique product lines does the data have?
SELECT DISTINCT product_line FROM walmartsalesdata;

-- 2. What is the most common payment method?
SELECT payment_method FROM walmartsalesdata
GROUP BY payment_method
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 3. What is the most selling product line?
SELECT product_line FROM walmartsalesdata
GROUP BY product_line
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 4. What is the total revenue by month?
SELECT month_name,sum(cogs) AS TOTAL_REVENUE FROM walmartsalesdata
GROUP BY month_name
ORDER BY month_name ASC;

-- 5. What month had the largest COGS?
SELECT month_name AS Largest_cogs FROM walmartsalesdata
ORDER BY cogs DESC
LIMIT 1;

-- 6. What product line had the largest revenue?
SELECT product_line FROM walmartsalesdata
ORDER BY COGS DESC
LIMIT 1;

-- 7. What is the city with the largest revenue?
SELECT city FROM walmartsalesdata
ORDER BY cogs DESC
LIMIT 1;

-- 8. What product line had the largest VAT?
SELECT product_line FROM walmartsalesdata
ORDER BY vat DESC
LIMIT 1;

-- 9. Fetch each product line and add a column to those product line showing "Good","Bad". Good if its greater than average sales
SELECT product_line,
CASE
	WHEN AVG(quantity) < 10 THEN 'Bad'
	ELSE 'Good'
END AS quantity_of_product_line
FROM walmartsalesdata
GROUP BY product_line;

-- 10. Which branch sold more products than average product sold?
select branch, sum(quantity) as total_quantity_sold
from walmartsalesdata
group by branch
having total_quantity_sold > avg(quantity)
limit 1;

-- 11. What is the most common product line by gender?
 
SELECT product_line, gender FROM walmartsalesdata
GROUP BY product_line, gender
ORDER BY count(gender) DESC
LIMIT 1;


-- 12. What is the average rating of each product line?
 
SELECT product_line, AVG(rating) AS average_rating
FROM walmartsalesdata
GROUP BY product_line;


-- Sales
 
-- 1. Number of sales made in each time of the day per weekday?
SELECT day_name AS weekday,  time_of_day, COUNT(*) AS number_of_sales FROM walmartsalesdata
GROUP BY weekday, time_of_day
ORDER BY weekday, time_of_day;

-- 2. Which of the customer types brings the most revenue?
SELECT customer_type, sum(cogs) AS most_revenue FROM walmartsalesdata
GROUP BY customer_type
ORDER BY most_revenue DESC
LIMIT 1;

-- 3. What is the most common customer type?
SELECT customer_type FROM walmartsalesdata
GROUP BY customer_type
ORDER BY count(customer_type) DESC
LIMIT 1;

-- 4. Which customer type buys the most?
SELECT customer_type FROM walmartsalesdata
GROUP BY customer_type
ORDER BY SUM(quantity) DESC
LIMIT 1;

-- 5. What is the gender of most of the customers?
SELECT gender FROM walmartsalesdata
GROUP BY gender
ORDER BY SUM(customer_type) DESC
LIMIT 1;

-- 6. What is the gender distribution per branch?
SELECT branch, gender, count(gender) AS gender_distribution
FROM walmartsalesdata
GROUP BY branch, gender
ORDER BY branch ASC;

-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day FROM walmartsalesdata
GROUP BY time_of_day
ORDER BY count(rating) DESC
LIMIT 1;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, count(rating) FROM walmartsalesdata
GROUP BY branch, time_of_day
ORDER BY count(rating) DESC
LIMIT 3;

-- 9. Which day of the week has the best avg ratings?
SELECT day_name FROM walmartsalesdata
GROUP BY day_name
ORDER BY AVG(rating) DESC
LIMIT 1;
 
-- 10. Which day of the week has the best average ratings per branch?
 
SELECT branch,AVG(rating) AS best_avg_rating
FROM walmartsalesdata
GROUP BY branch
ORDER BY branch ASC;
 
 
  -- #####################   conclusions   ##############################
  -- Time-Based Sales Patterns
  -- Revenue and Profit Insights
  -- It would involve leveraging the findings to drive strategic decisions,optimize resources, and enhance customer satisfaction.
  -- Customer Segmentation and Preferences
  -- #########################################################################



 
