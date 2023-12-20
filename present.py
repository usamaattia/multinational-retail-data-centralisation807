import pandas as pd
from database_utils import DatabaseConnector
from data_extraction import DataExtractor
from data_cleaning import DataCleaning

# Extract data
db_connector = DatabaseConnector()
data_extractor = DataExtractor()
data_cleaning = DataCleaning()

engine = db_connector.init_db_engine()

table_name = db_connector.list_db_tables(engine)  # Assuming the first table is the user data table
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

headers = {'x-api-key': 'yFBQbwXe9J3sd6zWVAMrK6lcxxr0q1lr2PT6DDMX'}
num_of_stores = 'https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/number_stores'
store_number = DataExtractor.list_number_of_stores(header=headers, number_stores_endpoint=num_of_stores)
print(store_number)
############

retrieve_store = 'https://aqj7u5id95.execute-api.eu-west-1.amazonaws.com/prod/store_details/{}'
store_detail_all = DataExtractor.retrieve_stores_data(store_endpoint=retrieve_store.format(0), header=headers)
for i in range (1,store_number):
    store_detail_api = DataExtractor.retrieve_stores_data(store_endpoint=retrieve_store.format(i), header=headers)
    store_detail_all = pd.concat([store_detail_api, store_detail_all], ignore_index=True)
db_connector.upload_to_db(store_detail_all, 'dim_store_details')



