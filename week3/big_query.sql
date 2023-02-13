-- Query public available table
SELECT station_id, name FROM
    bigquery-public-data.new_york_citibike.citibike_stations
LIMIT 100;


-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `dbc-de-376018.dezoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://prefect-de-zoomcamp15/yellow_1/yellow_tripdata/2019/yellow_tripdata_2019-*.parquet','gs://prefect-de-zoomcamp15/yellow_1/yellow_tripdata/2020/yellow_tripdata_2020-*.parquet']
);

-- Check yellow trip data
SELECT * FROM dbc-de-376018.dezoomcamp.external_yellow_tripdata limit 10;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE dbc-de-376018.dezoomcamp.yellow_tripdata_non_partitoned AS
SELECT * FROM dbc-de-376018.dezoomcamp.external_yellow_tripdata;

-- -- Alter Table to set tpep_pickup_datetime as timestamp column
-- -- Query 1: Parse the tpep_pickup_datetime column and add a new column with the parsed value
-- CREATE OR REPLACE TABLE dbc-de-376018.dezoomcamp.yellow_tripdata_parsed AS
-- SELECT * EXCEPT (passenger_count,payment_type,RatecodeID,VendorID),
--        PARSE_TIMESTAMP("%Y-%m-%d %H:%M:%S", tpep_pickup_datetime) AS tpep_pickup_datetime_parsed
-- FROM dbc-de-376018.dezoomcamp.external_yellow_tripdata;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE dbc-de-376018.dezoomcamp.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT *  FROM dbc-de-376018.dezoomcamp.external_yellow_tripdata;

-- Impact of partition
-- Scanning 1.6GB of data
SELECT DISTINCT(VendorID)
FROM dbc-de-376018.dezoomcamp.yellow_tripdata_non_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Scanning ~106 MB of DATA
SELECT DISTINCT(VendorID)
FROM dbc-de-376018.dezoomcamp.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM `dezoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE dbc-de-376018.dezoomcamp.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM dbc-de-376018.dezoomcamp.external_yellow_tripdata;

-- Query scans 1.1 GB
SELECT count(*) as trips
FROM dbc-de-376018.dezoomcamp.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Query scans 864.5 MB
SELECT count(*) as trips
FROM dbc-de-376018.dezoomcamp.yellow_tripdata_partitoned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;