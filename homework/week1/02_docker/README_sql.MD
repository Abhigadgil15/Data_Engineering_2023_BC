SELECT count(1) FROM database_name
### Returns count of rows appended into the database

SELECT max(tpep_pickup_datetime), min(tpep_pickup_datetime), max(total_amount) FROM yellow_taxi_data;
### Returns a table with maximum,minimum and maximum of columns requested respectively