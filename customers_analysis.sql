-- ========================================================
-- Project: Brazilian E-Commerce (Olist) Data Analysis
-- Table: customers
-- ========================================================

-- 1. Database & Table Setup
CREATE DATABASE IF NOT EXISTS olist_db;
USE olist_db;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 2. Data Ingestion (Fast Load)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3. Data Verification
SELECT COUNT(*) AS total_customers FROM customers;
SELECT * FROM customers LIMIT 5;
DESCRIBE customers;

-- 4. Filtering Analysis (State = 'SP')
SELECT customer_state 
FROM customers 
WHERE customer_state = 'SP' 
LIMIT 10;

SELECT COUNT(*) AS sp_customers_count
FROM customers 
WHERE customer_state = 'SP';

-- 5. Unique States Exploration
SELECT DISTINCT customer_state 
FROM customers 
LIMIT 20;

SELECT COUNT(DISTINCT customer_state) AS total_unique_states 
FROM customers;

-- 6. State-wise Distribution (Highest to Lowest)
SELECT customer_state, COUNT(*) AS customer_count
FROM customers 
GROUP BY customer_state 
ORDER BY COUNT(*) DESC;

-- 7. City Pattern Matching using LIKE
SELECT COUNT(*) AS rio_customers_count
FROM customers 
WHERE customer_city LIKE '%RIO%';






