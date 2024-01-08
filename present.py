import pandas as pd
from database_utils import DatabaseConnector
from data_extraction import DataExtractor
from data_cleaning import DataCleaning

# Extract data
db_connector = DatabaseConnector()
data_extractor = DataExtractor()
data_cleaning = DataCleaning()

engine = db_connector.init_db_engine()

table_name = db_connector.list_db_tables(engine)[1]  # Assuming the first table is the user data table

print(table_name)  
raw_data = data_extractor.read_rds_table(db_connector, table_name)
print(raw_data)
print(type(raw_data))
# Clean data
cleaned_data = data_cleaning.clean_user_data(raw_data)
# Upload to database
db_connector.upload_to_db(cleaned_data, 'dim_users')

####################################

pdf_page = 'https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf'

pd_pdf = DataExtractor.retrieve_pdf_data(pdf_page)
print(pd_pdf)
cleaned_pdf_data = data_cleaning.clean_card_data(pd_pdf)
db_connector.upload_to_db(cleaned_pdf_data, 'dim_card_details')

# ##################################
headers = {'x-api-key': 'yFBQbwXe9J3sd6zWVAMrK6lcxxr0q1lr2PT6DDMX'}
num_of_stores = 'https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/number_stores'
store_number = DataExtractor.list_number_of_stores(header=headers, number_stores_endpoint=num_of_stores)
print(store_number)

retrieve_store = 'https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/{}'
store_detail_all = DataExtractor.retrieve_stores_data(store_endpoint=retrieve_store.format(0), header=headers)
for i in range (1,store_number):
    store_detail_api = DataExtractor.retrieve_stores_data(store_endpoint=retrieve_store.format(i), header=headers)
    store_detail_all = pd.concat([store_detail_api, store_detail_all], ignore_index=True)
cleaned_store_data = data_cleaning.clean_store_data(store_detail_all)
db_connector.upload_to_db(cleaned_store_data, 'dim_store_details')


##################################

# Step 1: Extract product data from S3
s3_address = "s3://data-handling-public/products.csv"
products_data = DataExtractor.extract_from_s3(s3_address)
products_data = DataCleaning.convert_product_weights(products_data)
products_data = DataCleaning.clean_products_data(products_data)
print(products_data)
db_connector.upload_to_db(products_data, 'dim_products')

##################################

table_name = db_connector.list_db_tables(engine)[2]  
print(table_name)  
raw_data = data_extractor.read_rds_table(db_connector, table_name)
print(raw_data)
print(type(raw_data))
# Clean data
cleaned_data = data_cleaning.clean_orders_data(raw_data)
# Upload to database
db_connector.upload_to_db(cleaned_data, table_name)


##################################
    # final task in milestone 2
s3_json_link = "https://data-handling-public.s3.eu-west-1.amazonaws.com/date_details.json"
date_details_data = DataExtractor.retrieve_json_data(s3_json_link)
date_details_data = DataCleaning.clean_date_details(date_details_data)
print(date_details_data)
db_connector.upload_to_db(date_details_data, 'dim_date_times')

##################################

 