FROM python:3.9

# RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2


WORKDIR /app
COPY upload-data_green_taxi.py upload-data_green_taxi.py

ENTRYPOINT [ "python", "upload-data_green_taxi.py"]