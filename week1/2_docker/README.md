### Convert the parquet file to csv after running
pip install pyarrow

### -- START-- ##
### To build the database using docker
RUN 
docker build -t green_taxi .

### To login using pgcli run

pgcli -h localhost -p 5433 -u root -d ny_taxi


###OR run the docker compose file 
RUN
docker-compose up -d

### To stop the compose file run
docker-compose down


#### DATA INGESTION(TO AUTOMATE THE PIPELINE)
### Step 1: Convert the jupyter notebook into normal python script

jupyter nbconvert --to script upload-data.ipynb

### Step 2: Run the python script using the parameters in services.yaml file 

### Step 3 Either run pgcli or pgadmin through docker

