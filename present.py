import pandas as pd
from database_utils import DatabaseConnector
from data_extraction import DataExtractor
from data_cleaning import DataCleaning

# Extract data
db_connector = DatabaseConnector()
data_extractor = DataExtractor()
data_cleaning = DataCleaning()

engine = db_connector.init_db_engine()

# table_name = db_connector.list_db_tables(engine)  # Assuming the first table is the user data table
# for table in table_name:
#     print(table)  
#     raw_data = data_extractor.read_rds_table(db_connector, table)
#     print(raw_data)
#     print(type(raw_data))
#     # # Clean data
#     # cleaned_data = data_cleaning.clean_user_data(raw_data)
#     # print(type(cleaned_data))
#     # Upload to database
#     db_connector.upload_to_db(raw_data, table)

####################################

# pdf_page = 'https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf'

# pd_pdf = DataExtractor.retrieve_pdf_data(pdf_page)
# print(pd_pdf)
# cleaned_pdf_data = data_cleaning.clean_user_data(pd_pdf)
# db_connector.upload_to_db(cleaned_pdf_data, 'dim_card_details')

##################################
# headers = {'x-api-key': 'yFBQbwXe9J3sd6zWVAMrK6lcxxr0q1lr2PT6DDMX'}
# num_of_stores = 'https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/number_stores'
# store_number = DataExtractor.list_number_of_stores(header=headers, number_stores_endpoint=num_of_stores)
# print(store_number)

# retrieve_store = 'https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/{}'
# store_detail_all = DataExtractor.retrieve_stores_data(store_endpoint=retrieve_store.format(0), header=headers)
# for i in range (1,store_number):
#     store_detail_api = DataExtractor.retrieve_stores_data(store_endpoint=retrieve_store.format(i), header=headers)
#     store_detail_all = pd.concat([store_detail_api, store_detail_all], ignore_index=True)
# db_connector.upload_to_db(store_detail_all, 'dim_store_details')


##################################

# # Step 1: Extract product data from S3
# s3_address = "s3://data-handling-public/products.csv"
# products_data = DataExtractor.extract_from_s3(s3_address)
# products_data = DataCleaning.convert_product_weights(products_data)
# products_data = DataCleaning.clean_products_data(products_data)
# print(products_data)
# db_connector.upload_to_db(products_data, 'dim_products')

##################################

table_name = db_connector.list_db_tables(engine)  # Assuming the first table is the user data table
for table in table_name:
    print(table) 
    raw_data = data_extractor.read_rds_table(db_connector, table)
    print(raw_data)
    print(type(raw_data))
    # # Clean data
    cleaned_data = data_cleaning.clean_orders_data(raw_data)
    print(cleaned_data)
    # Upload to database
    db_connector.upload_to_db(cleaned_data, table)


##################################
    # final task in milestone 2
# s3_json_link = "https://data-handling-public.s3.eu-west-1.amazonaws.com/date_details.json"
# date_details_data = DataExtractor.retrieve_json_data(s3_json_link)
# date_details_data = DataCleaning.clean_date_details(date_details_data)
# print(date_details_data)
# db_connector.upload_to_db(date_details_data, 'dim_date_times')

##################################

    # milestone 3 task 1

'''
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
'''

##################################

    # milestone 3 task 2


'''
ALTER TABLE dim_users
ALTER COLUMN first_name TYPE VARCHAR(255);

ALTER TABLE dim_users
ALTER COLUMN last_name TYPE VARCHAR(255);

ALTER TABLE dim_users
ALTER COLUMN date_of_birth TYPE DATE USING TO_DATE(date_of_birth, 'YYYY-MM-DD'); 

ALTER TABLE dim_users
ALTER COLUMN country_code TYPE VARCHAR(2); 

ALTER TABLE dim_users
ALTER COLUMN user_uuid TYPE UUID USING (uuid_generate_v4());

ALTER TABLE dim_users
ALTER COLUMN join_date TYPE DATE USING TO_DATE(join_date, 'YYYY-MM-DD');

'''
