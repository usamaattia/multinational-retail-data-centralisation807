import pandas as pd
import numpy as np

class DataCleaning:
    @staticmethod
    def clean_user_data(df):
        print(df.info())
        df.dropna(subset=['user_uuid'], inplace=True)  # to drop rwos with missing values
        df.fillna('NA', inplace=True)  # Fill missing values
        df['date_of_birth'] = pd.to_datetime(df['date_of_birth'], errors='coerce')
        df.dropna(subset=['date_of_birth'], inplace=True)
        columns_to_keep = ['first_name', 'last_name', 'date_of_birth', 'company', 'email_address', 'address', 'country', 'country_code', 'phone_number', 'join_date', 'user_uuid']
        df = df[columns_to_keep]
        return df
    
    def clean_card_data(self, card_data):
        print(card_data)
        print(card_data.info())
        
        card_data['card_number'] = pd.to_numeric(card_data['card_number'], downcast='integer', errors="coerce")
        card_data.dropna(subset=['card_number'], inplace=True)
        card_data.dropna(subset=['expiry_date'], inplace=True)
        card_data.dropna(subset=['card_provider'], inplace=True)
        card_data['date_payment_confirmed'] = pd.to_datetime(card_data['date_payment_confirmed'], errors='coerce')
        card_data.dropna(subset=['date_payment_confirmed'], inplace=True)
        print(card_data.info())
        return card_data
        
    def clean_store_data(self, store_data):
        print(store_data)
        print(store_data.info())
        # Change data types
        store_data['longitude'] = pd.to_numeric(store_data['longitude'], errors='coerce')
        store_data['lat'] = pd.to_numeric(store_data['lat'], errors='coerce')
        store_data['staff_numbers'] = pd.to_numeric(store_data['staff_numbers'], errors='coerce')
        store_data['latitude'] = pd.to_numeric(store_data['latitude'], errors='coerce')
        store_data['opening_date'] = pd.to_datetime(store_data['opening_date'], errors='coerce')
        # Handling missing values
        store_data.dropna(subset=['latitude'], inplace=True)
        store_data.dropna(subset=['longitude'], inplace=True)
        store_data.dropna(subset=['locality'], inplace=True)
        # Remove duplicates
        store_data.drop_duplicates(subset=['store_code'], keep='first', inplace=True)
        # del "lat" because it is mostly empty
        store_data = store_data.drop('lat', axis=1)
        return store_data

    def convert_product_weights(products_df):
        # Method to convert and clean product weights
        # Assume 'weight' column contains weights in various units

        def convert_weight(weight):
            # Convert weights to kg
            # Add your conversion logic based on the units in your dataset
            # This is just a placeholder; adjust based on your actual data
            # weight = float(weight.split('kg')[0])
            
            if type(weight) == float:
                pass
            elif 'Z' in weight or 'M' in weight or 'x' in weight or ' ' in weight:
                pass
            elif 'kg' in weight:
                return float(weight.replace('kg', ''))
            elif 'x' in weight and 'g' in weight:
                return float(1200)
            elif 'g.' in weight:
                return float(weight.replace('g.', '')) / 1000
            elif 'g' in weight:
                return float(weight.replace('g', '')) / 1000
            elif 'ml' in weight:
                return float(weight.replace('ml', '')) / 1000
            elif 'oz' in weight:
                return float(weight.replace('oz', '')) * 0.028
            else:
                return float(weight)
        products_df['weight'] = products_df['weight'].apply(convert_weight)
        return products_df

    def clean_products_data(products_df):
        # Method to clean product data
        # Implement cleaning logic based on your specific requirements
        return products_df
    
    def clean_orders_data(self,orders_data):
        # Step 3: Clean orders data
        # Remove specified columns
        orders_data_cleaned = orders_data.drop(columns=['first_name', 'last_name', '1'], errors='ignore')
        return orders_data_cleaned
    
    def clean_date_details(data_pd):
        return data_pd

