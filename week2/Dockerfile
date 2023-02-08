FROM prefecthq/prefect:2.7.7-python3.9

COPY docker-requirements.txt .

RUN pip install -r docker-requirements.txt --trusted-host pypi.python.org --no-cache-dir

COPY 01_flow /opt/prefect/flows/01_flow
COPY 02_gcp /opt/prefect/flows/02_gcp

