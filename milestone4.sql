
-- -- milestone 4 task 1

-- -- The Operations team would like to know which countries we currently operate in and which country now has the most stores. Perform a query on the database to get the information, it should return the following information:

-- -- +----------+-----------------+
-- -- | country  | total_no_stores |
-- -- +----------+-----------------+
-- -- | GB       |             265 |
-- -- | DE       |             141 |
-- -- | US       |              34 |
-- -- +----------+-----------------+

-- SELECT
--   country_code AS country,
--   COUNT(store_code) AS total_no_stores
-- FROM dim_store_details
-- GROUP BY country_code
-- ORDER BY total_no_stores DESC, country_code;

-- -- #######################################

-- -- milestone 4 task 2

-- -- The business stakeholders would like to know which locations currently have the most stores.

-- -- They would like to close some stores before opening more in other locations.

-- -- Find out which locations have the most stores currently. The query should return the following:

-- -- +-------------------+-----------------+
-- -- |     locality      | total_no_stores |
-- -- +-------------------+-----------------+
-- -- | Chapletown        |              14 |
-- -- | Belper            |              13 |
-- -- | Bushley           |              12 |
-- -- | Exeter            |              11 |
-- -- | High Wycombe      |              10 |
-- -- | Arbroath          |              10 |
-- -- | Rutherglen        |              10 |
-- -- +-------------------+-----------------+

-- SELECT
--   locality,
--   COUNT(store_code) AS total_no_stores
-- FROM dim_store_details
-- GROUP BY locality
-- ORDER BY total_no_stores DESC, locality
-- LIMIT 7; -- Limit the result to the top 7 locations

-- -- #######################################

-- -- milestone 4 task 3

-- -- Query the database to find out which months have produced the most sales. The query should return the following information:

-- -- +-------------+-------+
-- -- | total_sales | month |
-- -- +-------------+-------+
-- -- |   673295.68 |     8 |
-- -- |   668041.45 |     1 |
-- -- |   657335.84 |    10 |
-- -- |   650321.43 |     5 |
-- -- |   645741.70 |     7 |
-- -- |   645463.00 |     3 |
-- -- +-------------+-------+


-- ALTER TABLE orders_table
-- ALTER COLUMN product_code TYPE VARCHAR(255);
ALTER TABLE dim_date_times
ALTER COLUMN month TYPE VARCHAR(2),
ALTER COLUMN year TYPE VARCHAR(4),
ALTER COLUMN day TYPE VARCHAR(2),
ALTER COLUMN time_period TYPE VARCHAR(10)

SELECT
   CAST(SUM(orders_table.product_quantity * dim_products.product_price) AS numeric) AS total_sales,
   dim_date_times.month As dt_month
FROM orders_table

JOIN dim_products ON orders_table.product_code = dim_products.product_code
JOIN dim_date_times  ON orders_table.date_uuid = dim_date_times.date_uuid

GROUP BY dt_month
ORDER BY total_sales DESC

-- -- #######################################

-- -- milestone 4 task 4

-- The company is looking to increase its online sales.

-- They want to know how many sales are happening online vs offline.

-- Calculate how many products were sold and the amount of sales made for online and offline purchases.

-- You should get the following information:

-- +------------------+-------------------------+----------+
-- | numbers_of_sales | product_quantity_count  | location |
-- +------------------+-------------------------+----------+
-- |            26957 |                  107739 | Web      |
-- |            93166 |                  374047 | Offline  |
-- +------------------+-------------------------+----------+



SELECT
  COUNT(*) AS numbers_of_sales,
  SUM(product_quantity) AS product_quantity_count,
  CASE WHEN store_code LIKE 'WEB-%' THEN 'Web' ELSE 'Offline' END AS location
FROM orders_table
GROUP BY location
ORDER BY location;


-- -- #######################################

-- -- milestone 4 task 5

-- The sales team wants to know which of the different store types is generated the most revenue so they know where to focus.

-- Find out the total and percentage of sales coming from each of the different store types.

-- The query should return:

-- +-------------+-------------+---------------------+
-- | store_type  | total_sales | percentage_total(%) |
-- +-------------+-------------+---------------------+
-- | Local       |  3440896.52 |               44.87 |
-- | Web portal  |  1726547.05 |               22.44 |
-- | Super Store |  1224293.65 |               15.63 |
-- | Mall Kiosk  |   698791.61 |                8.96 |
-- | Outlet      |   631804.81 |                8.10 |
-- +-------------+-------------+---------------------+

WITH StoreTypeSales AS (
  SELECT
    dim_store_details.store_type,
    SUM(product_quantity * product_price) AS total_sales
  FROM dim_store_details, orders_table
  JOIN dim_products ON orders_table.product_code = dim_products.product_code
  GROUP BY store_type
)

SELECT
  store_type,
  total_sales,
  ROUND((total_sales / SUM(total_sales) OVER ())::numeric * 100, 2) AS percentage_total
FROM StoreTypeSales
ORDER BY total_sales DESC;


-- -- #######################################

--  milestone 4 task 6
-- The company stakeholders want assurances that the company has been doing well recently.

-- Find which months in which years have had the most sales historically.

-- The query should return the following information:

-- +-------------+------+-------+
-- | total_sales | year | month |
-- +-------------+------+-------+
-- |    27936.77 | 1994 |     3 |
-- |    27356.14 | 2019 |     1 |
-- |    27091.67 | 2009 |     8 |
-- |    26679.98 | 1997 |    11 |
-- |    26310.97 | 2018 |    12 |
-- |    26277.72 | 2019 |     8 |
-- |    26236.67 | 2017 |     9 |
-- |    25798.12 | 2010 |     5 |
-- |    25648.29 | 1996 |     8 |
-- |    25614.54 | 2000 |     1 |
-- +-------------+------+-------+

WITH MonthlySales AS (
  SELECT
    SUM(product_quantity * product_price) AS total_sales,
    dt.year AS year,
    dt.month AS month,
    RANK() OVER (PARTITION BY dt.year ORDER BY SUM(product_quantity * product_price) DESC) AS sales_rank
  FROM orders_table o
  JOIN dim_products p ON o.product_code = p.product_code
  JOIN dim_date_times dt ON o.date_uuid = dt.date_uuid
  GROUP BY year, month
)

SELECT
  total_sales,
  year,
  month
FROM MonthlySales
WHERE sales_rank = 1
ORDER BY year, month;


-- -- #######################################

--  milestone 4 task 7

-- The operations team would like to know the overall staff numbers in each location around the world. Perform a query to determine the staff numbers in each of the countries the company sells in.

-- The query should return the values:

-- +---------------------+--------------+
-- | total_staff_numbers | country_code |
-- +---------------------+--------------+
-- |               13307 | GB           |
-- |                6123 | DE           |
-- |                1384 | US           |
-- +---------------------+--------------+

SELECT
  SUM(staff_numbers) AS total_staff_numbers,
  country_code
FROM dim_store_details
GROUP BY country_code
ORDER BY total_staff_numbers DESC;

-- -- #######################################

--  milestone 4 task 8

-- The sales team is looking to expand their territory in Germany. Determine which type of store is generating the most sales in Germany.

-- The query will return:

-- +--------------+-------------+--------------+
-- | total_sales  | store_type  | country_code |
-- +--------------+-------------+--------------+
-- |   198373.57  | Outlet      | DE           |
-- |   247634.20  | Mall Kiosk  | DE           |
-- |   384625.03  | Super Store | DE           |
-- |  1109909.59  | Local       | DE           |
-- +--------------+-------------+--------------+

WITH GermanStoreSales AS (
  SELECT
    SUM(o.product_quantity * p.product_price) AS total_sales,
    s.store_type,
    s.country_code
  FROM orders_table o
  JOIN dim_products p ON o.product_code = p.product_code
  JOIN dim_date_times dt ON o.date_uuid = dt.date_uuid
  JOIN dim_store_details s ON o.store_code = s.store_code
  WHERE s.country_code = 'DE'
  GROUP BY s.store_type, s.country_code
)

SELECT
  total_sales,
  store_type,
  country_code
FROM GermanStoreSales
ORDER BY total_sales DESC;

-- -- #######################################

--  milestone 4 task 9

-- Sales would like the get an accurate metric for how quickly the company is making sales.

-- Determine the average time taken between each sale grouped by year, the query should return the following information:

--  +------+-------------------------------------------------------+
--  | year |                           actual_time_taken           |
--  +------+-------------------------------------------------------+
--  | 2013 | "hours": 2, "minutes": 17, "seconds": 12, "millise... |
--  | 1993 | "hours": 2, "minutes": 15, "seconds": 35, "millise... |
--  | 2002 | "hours": 2, "minutes": 13, "seconds": 50, "millise... | 
--  | 2022 | "hours": 2, "minutes": 13, "seconds": 6,  "millise... |
--  | 2008 | "hours": 2, "minutes": 13, "seconds": 2,  "millise... |
--  +------+-------------------------------------------------------+
 

WITH SaleTimeGaps AS (
  SELECT
    EXTRACT(YEAR FROM dd.date_payment_confirmed) AS year,
    LEAD(dd.date_payment_confirmed) OVER (PARTITION BY EXTRACT(YEAR FROM dd.date_payment_confirmed) ORDER BY dd.date_payment_confirmed) AS next_payment_date,
    dd.date_payment_confirmed
  FROM orders_table o
  JOIN dim_card_details dd ON o.card_number::bigint = dd.card_number::bigint
)

SELECT
  year,
  AVG(EXTRACT(EPOCH FROM AGE(next_payment_date, date_payment_confirmed)) / 3600) AS actual_time_taken
FROM SaleTimeGaps
WHERE next_payment_date IS NOT NULL
GROUP BY year
ORDER BY year;
