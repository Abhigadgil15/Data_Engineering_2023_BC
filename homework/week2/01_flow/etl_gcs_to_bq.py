from prefect import flow,task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials
import pandas as pd
from pathlib import Path

@task()
def extract_from_gcs(color: str,year: int,month: int) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"{color}\{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load('zoom-gcs-2')
    gcs_block.get_directory(from_path=gcs_path, local_path=f'{color}')
    return Path(f"{color}\{gcs_path}")

@task()
def transform(path: Path) -> pd.DataFrame:
    """Data cleaning example"""
    df = pd.read_parquet(path)
    # print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    # df["passenger_count"].fillna(0,inplace = True)
    # print(f"post:missing passenger count: {df['passenger_count'].isna().sum()}")
    return df

@task()
def write_bq(df: pd.DataFrame) -> None:
    """Write DataFrame to big query"""

    gcp_credentials_block = GcpCredentials.load("zoom-gcp-creds")
    df.to_gbq(
        destination_table="de_week2_hw.travels",
        project_id="dbc-de-376018",
        credentials= gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500000,
        if_exists="append"
    )


@flow()
def etl_gcs_to_bq():
    """Main ETL flow to load data into the Big Query"""
    color="yellow"
    year=2019
    month=3

    path =extract_from_gcs(color,year,month)
    df = transform(path)
    write_bq(df)

if __name__ == "__main__":
    etl_gcs_to_bq()