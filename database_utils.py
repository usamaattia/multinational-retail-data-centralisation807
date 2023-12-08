import psycopg2  # Assuming you are using PostgreSQL, adjust the import as needed

class DatabaseConnector:
    def __init__(self, host, user, password, database):
        self.connection = psycopg2.connect(host=host, user=user, password=password, database=database)

    def execute_query(self, query):
        with self.connection.cursor() as cursor:
            cursor.execute(query)
        self.connection.commit()

    def close_connection(self):
        self.connection.close()
