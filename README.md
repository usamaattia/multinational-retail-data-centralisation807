# Multinational Retail Data Centralisation

## Overview
This project centralizes and manages retail data from various sources, including AWS RDS, S3, and an API. The data is processed, cleaned, and stored in a PostgreSQL database using Python scripts.

## Project Structure

### 1. `data_extraction.py`
   - Class `DataExtractor` to extract data from CSV files, an API, and an S3 bucket.
   - Methods for extracting data from different sources.

### 2. `database_utils.py`
   - Class `DatabaseConnector` to connect to and upload data to the PostgreSQL database.
   - Methods for reading database credentials, initializing the database engine, listing tables, and uploading data.

### 3. `data_cleaning.py`
   - Class `DataCleaning` with methods to clean data from different sources.
   - Specific method `clean_user_data` for cleaning user data.

1. Configure database credentials:

* Create a db_creds.yaml file with the necessary credentials.
Execute the scripts:

2. Run python 

the file present.py contains all the excutions so just run:
* python3 present.py

### to connect to your local database (pgAdmin 4) you need to update the credentials in the database_utils.py in the upload_to_db() function

### in the sales_data.session.sql there is the nessasry adjustments for the cloumns types and conversions

### in the file milestone4.sql there is few function that contains business decisions and some useful data extractions. 

