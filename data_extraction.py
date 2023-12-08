import psycopg2
import boto3

class DataExtractor:
    @staticmethod
    def extract_from_postgresql(host, user, password, database, query):
        connection = psycopg2.connect(host=host, user=user, password=password, database=database)
        with connection.cursor() as cursor:
            cursor.execute(query)
            data = cursor.fetchall()
        connection.close()
        return data

    @staticmethod
    def extract_from_s3(bucket_name, object_key):
        s3 = boto3.client('s3')
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        data = response['Body'].read().decode('utf-8')
        return data
