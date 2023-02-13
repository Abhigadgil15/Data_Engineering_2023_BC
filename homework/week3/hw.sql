CREATE OR REPLACE EXTERNAL TABLE `dbc-de-376018.week_3.external_fhv_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://prefect-de-zoomcamp15/fhv_tripdata/2019/fhv_tripdata_2019-*.parquet']
);

SELECT count(*) FROM dbc-de-376018.week_3.external_fhv_tripdata;

SELECT DISTINCT(Affiliated_base_number)
FROM dbc-de-376018.week_3.external_fhv_tripdata;

SELECT DISTINCT(Affiliated_base_number)
FROM dbc-de-376018.week_3.fhv_2019;

SELECT COUNT(*)
FROM dbc-de-376018.week_3.external_fhv_tripdata
WHERE PUlocationID  IS NULL AND DOlocationID IS NULL;

CREATE OR REPLACE TABLE dbc-de-376018.week_3.external_fhv_partitioned_clustered_tripdata
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM dbc-de-376018.week_3.external_fhv_tripdata;

CREATE OR REPLACE TABLE dbc-de-376018.week_3.fhv_partitioned_clustered_tripdata
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM dbc-de-376018.week_3.fhv_2019;

SELECT DISTINCT(Affiliated_base_number)
FROM dbc-de-376018.week_3.external_fhv_partitioned_clustered_tripdata
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';

SELECT DISTINCT(Affiliated_base_number)
FROM dbc-de-376018.week_3.fhv_partitioned_clustered_tripdata
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';
