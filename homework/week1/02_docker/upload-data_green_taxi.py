import pandas as pd 
import argparse
from sqlalchemy import create_engine
from time import time

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df_iter = pd.read_csv('green_tripdata_2019-01.csv', iterator = True, chunksize = 100000)

    df = next(df_iter)

    ### Convert to datetime since we started again and insert data in chunks
    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime= pd.to_datetime(df.lpep_dropoff_datetime)


    ###use'if_exists' = "append" when data is not empty and add to existing data otherwise use 'replace' to replace existing data 
    df.head(n=0).to_sql(name = table_name,con = engine, if_exists = 'replace')



    df.to_sql(name = table_name,con = engine, if_exists = 'append')


    ###Run a simple loop to load the remaining chunks into the database 
    ### The way iterators in python is that when there will be no next chunk it will throw an exception
    while True:
        t_start = time()
        
        df = next(df_iter)
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime= pd.to_datetime(df.lpep_dropoff_datetime)
        df.to_sql(name = table_name, con = engine, if_exists = 'append')
        
        t_end = time()
        print('inserted another chunk...., took %.3f seconds' % (t_end - t_start))

if __name__== '__main__':   
    parser = argparse.ArgumentParser(description='Ingest csv data to postgres')
    parser.add_argument('--user', help='username for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table_name', help='table_name for postgres')
    # parser.add_argument('url', help='url of the csv file')

    args = parser.parse_args()
    main(args)
