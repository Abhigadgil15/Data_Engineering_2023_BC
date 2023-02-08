SELECT count(1) FROM database_name
### Returns count of rows appended into the database

SELECT max(tpep_pickup_datetime), min(tpep_pickup_datetime), max(total_amount) FROM yellow_taxi_data;
### Returns a table with maximum,minimum and maximum of columns requested respectively

SELECT
	CAST(lpep_pickup_datetime AS DATE) as "day",
	COUNT(1)
FROM
	green_taxi_trips t
GROUP BY
	CAST(lpep_dropoff_datetime as DATE)
ORDER BY "day" ASC;

### To use the dates only on the basis of day and its count based on the selection.Order by basically sorts it in ascending order

SELECT
	CAST(lpep_pickup_datetime AS DATE) as "day",
	CAST(lpep_dropoff_datetime AS DATE) as "day",
	COUNT(1)
FROM
	green_taxi_trips t
GROUP BY
	CAST(lpep_pickup_datetime as DATE),
	CAST(lpep_dropoff_datetime as DATE)

### For passengers starting and leaving on same date refer to the table made

SELECT
	passenger_count,
	COUNT(1)
FROM
	green_taxi_trips 
WHERE 
	lpep_pickup_datetime > '2018-12-31' AND lpep_dropoff_datetime < '2019-01-02'
GROUP BY
	passenger_count

### To get count of passengers between two time zones

SELECT 
    "PULocationID",
    "DOLocationID",
    tip_amount
FROM green_taxi_trips
WHERE tip_amount = (SELECT MAX(tip_amount) FROM green_taxi_trips WHERE "PULocationID"=7);

### The above nested query is used for multiple conditions. In this case we had to know the location with max tip amount who started there taxi from Astoria i.e with id 7 