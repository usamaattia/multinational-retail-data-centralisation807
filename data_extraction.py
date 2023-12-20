import pandas as pd
import tabula

class DataExtractor:
    @staticmethod
    def read_rds_table(db_connector, table_name):
        engine = db_connector.init_db_engine()
        df = pd.read_sql_table(table_name, engine)
        return df
    
    def retrieve_pdf_data(link):
        dfs = tabula.read_pdf(link,  pages="all")
        pdf_data = pd.concat(dfs)
        return pdf_data


