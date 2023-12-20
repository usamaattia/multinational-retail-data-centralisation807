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

pdf_page = 'https://data-handling-public.s3.eu-west-1.amazonaws.com/card_details.pdf'

DataExtractor.retrieve_pdf_data(pdf_page)