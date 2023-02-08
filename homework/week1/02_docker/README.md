RUN 
docker build -t green_taxi .

### test:pandas is image name and '.' is the parameter name

RUN 
docker run -it test:pandas
### Run the docker file 

### To login using pgcli run
pgcli -h localhost -p 5433 -u root -d ny_taxi


### Converted the parquet file into csv file
### To create smaller data frame of 100 rows use the below code

head -n 100 yellow_tripdata_2021-01.csv > yellow_head.csv

### To count number of lines use 
wc -l yellow_tripdata_2021-01.csv

### Follow the jupyter notebook that is to upload data to the postgres


# (optional) can start database using :-
pg_ctl -D /var/lib/postgresql/data -l logfile start

'''//not yet done//
### To run the pgadmin we need to create a docker network which consists fo 2 below images:-
### 1) the docker image we use for initialising the database 
### 2) The second image will conist of docker image with pg-admin login credentials
### To create a network refer to .yaml file
'''//

### OR 


### Create a docker compose file and run
docker-compose up -d
### this will also enable a terminal to stop the docker compose 

### To stop the compose file run
docker-compose down


#### DATA INGESTION(TO AUTOMATE THE PIPELINE)
### Step 1: Convert the jupyter notebook into normal python script
jupyter nbconvert --to script upload-data.ipynb