{{ config(materialized='view') }}

select
  meter_id,
  meter_name,
  plant_id,
  plant_name,
  plant_code,
  date_trunc('day', time_start_hour) as day,
  count(*) as hours_with_reading,
  sum(export_energy_wh) as export_energy_wh,
  sum(has_energy) as hours_with_energy
from {{ ref('meter_registry_hourly') }}
group by
  date_trunc('day', time_start_hour),
  plant_id,
  plant_name,
  plant_code,
  meter_id,
  meter_name
