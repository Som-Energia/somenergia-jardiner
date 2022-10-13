{{ config(materialized='view') }}

select
    *,
    date_trunc('hour', time) as time_start_hour
from (
    select
    *,
    row_number() over (partition by date_trunc('day',time) order by request_time desc) as row_number
    from {{source('plantmonitor','satellite_readings')}}
) satellite
where row_number=1