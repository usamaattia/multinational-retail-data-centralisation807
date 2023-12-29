import yaml
from sqlalchemy import create_engine
from sqlalchemy import inspect
import psycopg2 

  

class DatabaseConnector:
    @staticmethod
    def read_db_creds():
        with open("db_creds.yaml", "r") as file:
            credentials = yaml.safe_load(file)
        return credentials
    
    @staticmethod
    def init_db_engine():
        credentials = DatabaseConnector.read_db_creds()
        db_url = f"postgresql://{credentials['RDS_USER']}:{credentials['RDS_PASSWORD']}@{credentials['RDS_HOST']}:{credentials['RDS_PORT']}/{credentials['RDS_DATABASE']}"
        engine = create_engine(db_url, echo=True)
        return engine
    
    @staticmethod
    def list_db_tables(engine):
        inspector = inspect(engine)
        return inspector.get_table_names()
    
    
    @staticmethod
    def upload_to_db(df, table_name):
        conn_string = 'postgresql+psycopg2://postgres:password@localhost:5433/sales_data'
        engine = create_engine(conn_string) 
        df.to_sql(table_name, engine, if_exists='replace', index=False)
        conn = psycopg2.connect(host='localhost', port=5433, dbname='sales_data', user='postgres', password='password') 
        conn.autocommit = True
        cursor = conn.cursor() 
        
        # sql1 = '''select * from dim_users;'''
        # cursor.execute(sql1) 
        # for i in cursor.fetchall(): 
        #     print(i) 
        
        conn.commit() 
        conn.close() 
        

