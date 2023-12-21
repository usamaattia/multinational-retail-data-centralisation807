import pandas as pd
import tabula
import requests
import boto3
from io import BytesIO

class DataExtractor:

    @staticmethod
    def read_rds_table(db_connector, table_name):
        engine = db_connector.init_db_engine()
        df = pd.read_sql_table(table_name, engine)
        return df
    
    @staticmethod
    def retrieve_pdf_data(link):
        dfs = tabula.read_pdf(link,  pages="all")
        pdf_data = pd.concat(dfs)
        return pdf_data
    
    @staticmethod
    def list_number_of_stores(number_stores_endpoint, header):
        response = requests.get(number_stores_endpoint, headers=header)
        if response.status_code == 200:
            return response.json()['number_stores']
        else:
            print(f"Error retrieving number of stores. Status Code: {response.status_code}")
            return None

    @staticmethod  
    def retrieve_stores_data(store_endpoint, header):
        response = requests.get(store_endpoint, headers=header)
        # print(store_endpoint)
        # print(response.json())
        if response.status_code == 200:
            return pd.DataFrame(response.json(), index = [0])
        else:
            print(f"Error retrieving stores data. Status Code: {response.status_code}")
            return pd.DataFrame()
    
    @staticmethod
    def extract_from_s3(s3_address):

        # s3 = boto3.resource('s3')
        # for bucket in s3.buckets.all():
        #     print(bucket.name)
        
        s3 = boto3.client('s3')

        try:
            # Extracting data from S3
            response = s3.get_object(Bucket=s3_address.split('/')[2], Key='/'.join(s3_address.split('/')[3:]))
            data = pd.read_csv(BytesIO(response['Body'].read()))
            return data
        except Exception as e:
            print(f"Error extracting data from S3: {e}")
            return pd.DataFrame()
    
    


