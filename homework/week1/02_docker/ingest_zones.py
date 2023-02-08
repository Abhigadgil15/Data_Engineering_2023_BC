import pandas as pd 
import argparse
from sqlalchemy import create_engine

df = pd.read_csv("taxi+_zone_lookup.csv")
engine = create_engine('postgresql://root:root@localhost:5433/ny_taxi')
engine.connect()
df.to_sql(name = 'zones',con = engine, if_exists = 'append')