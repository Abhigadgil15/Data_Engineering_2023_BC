{{ config(materialized='view') }}

select
    {{ dbt_utils.surrogate_key(['dispatching_base_number', 'pickup_datetime']) }} as tripid, dispatching_base_number,

    cast(PUlocationID as integer) as  pickup_locationid,
    cast(DOlocationID as integer) as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    Affiliated_base_number,
    cast(SR_Flag as integer) as SR_Flag,


from {{ source('staging','fhv_tripdata') }}

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
