{{ config(materialized = 'table') }}

select *
from {{ ref('spine_plant_meter_hourly') }}
where start_hour <= now() - interval '1 hour'
