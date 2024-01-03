
-- --    # milestone 3 task 1


-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
SELECT * FROM dim_products;

Rename 'removed' column to 'still_available'
ALTER TABLE dim_products
RENAME COLUMN removed TO still_available;

Change data types of columns
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
