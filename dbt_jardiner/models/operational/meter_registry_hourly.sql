{{ config(materialized='view') }}


with meter_registry_hourly_raw as (
  select
    date_trunc('hour', time_start_hour) AS time_start_hour,
    meter,
    plant_id,
    plant_name,
    plant_code,
    avg(export_energy_wh) as export_energy_wh,
    avg(import_energy_wh) as import_energy_wh
  from {{ ref('meter_registry') }} as meter_registry
  --WHERE time >= '' and time <  max(time)
  group by date_trunc('hour', time_start_hour), plant_id, plant_name, plant_code, meter
)

select
  *,
  CASE
    WHEN export_energy_wh > 0 THEN 1
    WHEN export_energy_wh = 0 THEN 0
    ELSE NULL
  END as has_energy
FROM meter_registry_hourly_raw