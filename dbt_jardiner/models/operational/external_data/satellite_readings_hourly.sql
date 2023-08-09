{{ config(materialized='view') }}

with satellite as
(
    select
    *,
    row_number() over (partition by plant_id, date_trunc('hour',time) order by request_time desc) as row_number
    from {{ref('satellite_readings_denormalized')}}
)

select
    *,
    date_trunc('hour', time) as time_start_hour
from satellite
where row_number=1