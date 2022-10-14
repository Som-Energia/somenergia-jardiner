{{ config(materialized='view') }}

select
  date_trunc('day', time_start_hour) AS day,
  meter,
  plant_id,
  plant_name,
  plant_code,
  count(*) as hours_with_reading,
  sum(export_energy_wh) as export_energy_wh,
  sum(has_energy) as hours_with_energy
FROM {{ref('meter_registry_hourly')}}
group by date_trunc('day', time_start_hour), plant_id, plant_name, plant_code, meter