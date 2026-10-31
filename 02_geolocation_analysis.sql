USE olist_db;

-- Table creation for geolocation data
CREATE TABLE geolocation ( 
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10, 8), 
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
);

-- Loading 1M+ rows using bulk infile
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Check total imported rows
SELECT COUNT(*) FROM geolocation;

-- Unique counts check
SELECT 
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_codes,
    COUNT(DISTINCT geolocation_city) AS unique_cities,
    COUNT(DISTINCT geolocation_state) AS unique_state 
FROM geolocation;

-- Top 5 states by density
SELECT 
    geolocation_state,
    COUNT(*) AS total_records,
    COUNT(DISTINCT geolocation_city) AS total_cities
FROM geolocation
GROUP BY geolocation_state
ORDER BY total_records DESC
LIMIT 5;

-- Calculate average lat/lng for each zip code
SELECT 
    geolocation_zip_code_prefix,
    ROUND(AVG(geolocation_lat), 5) AS avg_latitude,
    ROUND(AVG(geolocation_lng), 5) AS avg_longitude,
    geolocation_city,
    geolocation_state
FROM geolocation
GROUP BY geolocation_zip_code_prefix, geolocation_city, geolocation_state
LIMIT 10;

-- Adding indexes to optimize join query (reduced run time from 210s to 10s)
CREATE INDEX idx_geo_zip ON geolocation(geolocation_zip_code_prefix);
CREATE INDEX idx_cust_zip ON customers(customer_zip_code_prefix);

-- Joining customers and geolocation table
SELECT 
    c.customer_id,
    c.customer_city,
    c.customer_state,
    ROUND(AVG(g.geolocation_lat), 5) AS latitude,
    ROUND(AVG(g.geolocation_lng), 5) AS longitude
FROM customers c
JOIN geolocation g 
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY c.customer_id, c.customer_city, c.customer_state
LIMIT 10;












