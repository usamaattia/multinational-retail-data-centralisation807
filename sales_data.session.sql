
-- --    # milestone 3 task 1
-- Change the data types to correspond to those seen in the table below.

-- +------------------+--------------------+--------------------+
-- |   orders_table   | current data type  | required data type |
-- +------------------+--------------------+--------------------+
-- | date_uuid        | TEXT               | UUID               |
-- | user_uuid        | TEXT               | UUID               |
-- | card_number      | TEXT               | VARCHAR(?)         |
-- | store_code       | TEXT               | VARCHAR(?)         |
-- | product_code     | TEXT               | VARCHAR(?)         |
-- | product_quantity | BIGINT             | SMALLINT           |
-- +------------------+--------------------+--------------------+


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

ALTER TABLE orders_table
ALTER COLUMN date_uuid TYPE UUID USING (uuid_generate_v4());
ALTER TABLE orders_table
ALTER COLUMN user_uuid TYPE UUID USING (uuid_generate_v4());

-- Alter 'card_number', 'store_code', and 'product_code' columns to VARCHAR with appropriate length
ALTER TABLE orders_table
ALTER COLUMN card_number TYPE VARCHAR(20);
ALTER TABLE orders_table
ALTER COLUMN store_code TYPE VARCHAR(12);
ALTER TABLE orders_table
ALTER COLUMN product_code TYPE VARCHAR(11);

-- Alter 'product_quantity' column to SMALLINT
ALTER TABLE orders_table
ALTER COLUMN product_quantity TYPE SMALLINT;


-- ##################################
The column required to be changed in the users table are as follows:

-- +----------------+--------------------+--------------------+
-- | dim_user_table | current data type  | required data type |
-- +----------------+--------------------+--------------------+
-- | first_name     | TEXT               | VARCHAR(255)       |
-- | last_name      | TEXT               | VARCHAR(255)       |
-- | date_of_birth  | TEXT               | DATE               |
-- | country_code   | TEXT               | VARCHAR(?)         |
-- | user_uuid      | TEXT               | UUID               |
-- | join_date      | TEXT               | DATE               |
-- +----------------+--------------------+--------------------+

    -- # milestone 3 task 2

ALTER TABLE dim_users
ALTER COLUMN first_name TYPE VARCHAR(255);

ALTER TABLE dim_users
ALTER COLUMN last_name TYPE VARCHAR(255);


ALTER TABLE dim_users
ALTER COLUMN date_of_birth TYPE DATE USING date_of_birth::date;

ALTER TABLE dim_users
ALTER COLUMN country_code TYPE VARCHAR(255); 

ALTER TABLE dim_users
ALTER COLUMN user_uuid TYPE UUID USING (uuid_generate_v4());

ALTER TABLE dim_users
ALTER COLUMN join_date TYPE DATE USING join_date::date;





-- ##################################

    -- # milestone 3 task 3

--     There are two latitude columns in the store details table. Using SQL, merge one of the columns into the other so you have one latitude column.

-- Then set the data types for each column as shown below:

-- +---------------------+-------------------+------------------------+
-- | store_details_table | current data type |   required data type   |
-- +---------------------+-------------------+------------------------+
-- | longitude           | TEXT              | FLOAT                  |
-- | locality            | TEXT              | VARCHAR(255)           |
-- | store_code          | TEXT              | VARCHAR(?)             |
-- | staff_numbers       | TEXT              | SMALLINT               |
-- | opening_date        | TEXT              | DATE                   |
-- | store_type          | TEXT              | VARCHAR(255) NULLABLE  |
-- | latitude            | TEXT              | FLOAT                  |
-- | country_code        | TEXT              | VARCHAR(?)             |
-- | continent           | TEXT              | VARCHAR(255)           |
-- +---------------------+-------------------+------------------------+
-- There is a row that represents the business's website change the location column values where they're null to N/A.


-- UPDATE dim_store_details
-- SET latitude = COALESCE(latitude, lat);
-- -- lat column is deleted becuase it is mostly null

ALTER TABLE dim_store_details
ALTER COLUMN longitude TYPE FLOAT;

ALTER TABLE dim_store_details
ALTER COLUMN locality TYPE VARCHAR(255);

ALTER TABLE dim_store_details
ALTER COLUMN store_code TYPE VARCHAR(11); 

ALTER TABLE dim_store_details
ALTER COLUMN staff_numbers TYPE SMALLINT;

ALTER TABLE dim_store_details
ALTER COLUMN opening_date TYPE DATE USING opening_date::date;

ALTER TABLE dim_store_details
ALTER COLUMN store_type TYPE VARCHAR(255);

ALTER TABLE dim_store_details
ALTER COLUMN latitude TYPE FLOAT;

ALTER TABLE dim_store_details
ALTER COLUMN country_code TYPE VARCHAR(255);

ALTER TABLE dim_store_details
ALTER COLUMN continent TYPE VARCHAR(255);

UPDATE dim_store_details
SET locality = 'N/A'
WHERE locality IS NULL;



-- ##################################

    -- # milestone 3 task 4

--     You will need to do some work on the products table before casting the data types correctly.

-- The product_price column has a £ character which you need to remove using SQL.

-- The team that handles the deliveries would like a new human-readable column added for the weight so they can quickly make decisions on delivery weights.

-- Add a new column weight_class which will contain human-readable values based on the weight range of the product.

-- +--------------------------+-------------------+
-- | weight_class VARCHAR(?)  | weight range(kg)  |
-- +--------------------------+-------------------+
-- | Light                    | < 2               |
-- | Mid_Sized                | >= 2 - < 40       |
-- | Heavy                    | >= 40 - < 140     |
-- | Truck_Required           | => 140            |
-- +----------------------------+-----------------+

UPDATE dim_products
SET product_price = REPLACE(product_price, '£', '')::DECIMAL;

-- Add a new column 'weight_class'
ALTER TABLE dim_products
ADD COLUMN weight_class VARCHAR(50);

-- Update 'weight_class' based on the weight range
UPDATE dim_products
SET weight_class = 'Light'
WHERE weight < 2;

UPDATE dim_products
SET weight_class = 'Mid_Sized'
WHERE weight >= 2 AND weight < 40;

UPDATE dim_products
SET weight_class = 'Heavy'
WHERE weight >= 40 AND weight < 140;

UPDATE dim_products
SET weight_class = 'Truck_Required'
WHERE weight >= 140;


-- ##################################

    -- # milestone 3 task 5
--     After all the columns are created and cleaned, change the data types of the products table.

-- You will want to rename the removed column to still_available before changing its data type.

-- Make the changes to the columns to cast them to the following data types:

-- +-----------------+--------------------+--------------------+
-- |  dim_products   | current data type  | required data type |
-- +-----------------+--------------------+--------------------+
-- | product_price   | TEXT               | FLOAT              |
-- | weight          | TEXT               | FLOAT              |
-- | EAN             | TEXT               | VARCHAR(?)         |
-- | product_code    | TEXT               | VARCHAR(?)         |
-- | date_added      | TEXT               | DATE               |
-- | uuid            | TEXT               | UUID               |
-- | still_available | TEXT               | BOOL               |
-- | weight_class    | TEXT               | VARCHAR(?)         |
-- +-----------------+--------------------+--------------------+



-- Rename 'removed' column to 'still_available'
ALTER TABLE dim_products
RENAME COLUMN removed TO still_available;

-- Change data types of columns
ALTER TABLE dim_products
ALTER COLUMN product_price TYPE FLOAT USING NULLIF(product_price, '')::FLOAT;

**
ALTER TABLE dim_products
ALTER COLUMN weight TYPE FLOAT USING NULLIF(NULLIF(weight, ''), '')::FLOAT;
**
ALTER TABLE dim_products
ALTER COLUMN EAN TYPE VARCHAR(255); 

ALTER TABLE dim_products
ALTER COLUMN product_code TYPE VARCHAR(255); 

ALTER TABLE dim_products
ALTER COLUMN date_added TYPE DATE USING date_added::date;

ALTER TABLE dim_products
ALTER COLUMN uuid TYPE UUID USING (uuid_generate_v4()); 

ALTER TABLE dim_products
ALTER still_available TYPE boolean
USING CASE still_available WHEN 'Still_avaliable' THEN TRUE ELSE FALSE END;

ALTER TABLE dim_products
ALTER COLUMN weight_class TYPE VARCHAR(50); 


-- ##################################

    -- # milestone 3 task 6

--     Now update the date table with the correct types:

-- +-----------------+-------------------+--------------------+
-- | dim_date_times  | current data type | required data type |
-- +-----------------+-------------------+--------------------+
-- | month           | TEXT              | VARCHAR(?)         |
-- | year            | TEXT              | VARCHAR(?)         |
-- | day             | TEXT              | VARCHAR(?)         |
-- | time_period     | TEXT              | VARCHAR(?)         |
-- | date_uuid       | TEXT              | UUID               |
-- +-----------------+-------------------+--------------------+



ALTER TABLE dim_date_times
ALTER COLUMN month TYPE VARCHAR(2); 

ALTER TABLE dim_date_times
ALTER COLUMN year TYPE VARCHAR(4); 

ALTER TABLE dim_date_times
ALTER COLUMN day TYPE VARCHAR(2); 

ALTER TABLE dim_date_times
ALTER COLUMN time_period TYPE VARCHAR(255); 

ALTER TABLE dim_date_times
ALTER COLUMN date_uuid TYPE UUID USING (uuid_generate_v4()); 


-- ##################################

    -- # milestone 3 task 7

--     Now we need to update the last table for the card details.

-- Make the associated changes after finding out what the lengths of each variable should be:

-- +------------------------+-------------------+--------------------+
-- |    dim_card_details    | current data type | required data type |
-- +------------------------+-------------------+--------------------+
-- | card_number            | TEXT              | VARCHAR(?)         |
-- | expiry_date            | TEXT              | VARCHAR(?)         |
-- | date_payment_confirmed | TEXT              | DATE               |
-- +------------------------+-------------------+--------------------+


SELECT
  MAX(LENGTH(card_number)) AS max_card_number_length,
  MAX(LENGTH(expiry_date)) AS max_expiry_date_length
FROM dim_card_details;

-- Change data types of columns
ALTER TABLE dim_card_details
ALTER COLUMN card_number TYPE VARCHAR(22); 

ALTER TABLE dim_card_details
ALTER COLUMN expiry_date TYPE VARCHAR(10);

ALTER TABLE dim_card_details
ALTER COLUMN date_payment_confirmed TYPE DATE USING date_payment_confirmed::date;



-- ##################################

    -- # milestone 3 task 8

--     Now that the tables have the appropriate data types we can begin adding the primary keys to each of the tables prefixed with dim.

-- Each table will serve the orders_table which will be the single source of truth for our orders.

-- Check the column header of the orders_table you will see all but one of the columns exist in one of our tables prefixed with dim.

-- We need to update the columns in the dim tables with a primary key that matches the same column in the orders_table.

-- Using SQL, update the respective columns as primary key columns.


Update dim_users_table
ALTER TABLE dim_users
ADD PRIMARY KEY (user_uuid);

-- Update dim_store_details
ALTER TABLE dim_store_details
ADD PRIMARY KEY (store_code);

-- Update dim_products
ALTER TABLE dim_products
ADD PRIMARY KEY (product_code);

-- Update dim_date_times
ALTER TABLE dim_date_times
ALTER COLUMN date_uuid TYPE UUID USING (uuid_generate_v4()); 

ALTER TABLE dim_date_times
ADD PRIMARY KEY (date_uuid);

-- Update dim_card_details
ALTER TABLE dim_card_details
ADD PRIMARY KEY (card_number);



-- ##################################

    -- # milestone 3 task 9

--     With the primary keys created in the tables prefixed with dim we can now create the foreign keys in the orders_table to reference the primary keys in the other tables.

-- Use SQL to create those foreign key constraints that reference the primary keys of the other table.

-- This makes the star-based database schema complete.

ALTER TABLE orders_table
ALTER COLUMN user_uuid TYPE UUID USING (uuid_generate_v4());
ALTER TABLE orders_table
ALTER COLUMN date_uuid TYPE UUID USING (uuid_generate_v4()); 

ALTER TABLE orders_table
ADD CONSTRAINT fk_user_uuid
    FOREIGN KEY (user_uuid)
    REFERENCES dim_users(user_uuid);

ALTER TABLE orders_table
ADD FOREIGN KEY (store_code)
    REFERENCES dim_store_details(store_code);

ALTER TABLE orders_table
ADD CONSTRAINT fk_product_code
    FOREIGN KEY (product_code)
    REFERENCES dim_products(product_code);

 

ALTER TABLE orders_table
ADD CONSTRAINT fk_date_uuid
    FOREIGN KEY (date_uuid)
    REFERENCES dim_date_times(date_uuid);

ALTER TABLE orders_table
ADD CONSTRAINT fk_card_number
    FOREIGN KEY (card_number)
    REFERENCES dim_card_details(card_number);
