{{ config(materialized='view') }}

select
  plant_id,
  date_trunc('day', time_start_hour) as day,
  sum(energy_kwh) as energy_kwh
from {{ ref('forecasts_hourly') }}
group by date_trunc('day', time_start_hour), plant_id
