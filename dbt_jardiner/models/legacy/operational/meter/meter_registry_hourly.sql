{{ config(materialized='view') }}


with meter_registry_hourly_raw as (
  select
    meter_id,
    meter_name,
    plant_id,
    plant_name,
    plant_code,
    date_trunc('hour', time_start_hour) as time_start_hour,
    round(avg(export_energy_wh), 2) as export_energy_wh,
    round(avg(import_energy_wh), 2) as import_energy_wh
  from {{ ref('meter_registry') }}
  --WHERE time >= '' and time <  max(time)
  group by
    date_trunc('hour', time_start_hour),
    plant_id,
    plant_name,
    plant_code,
    meter_id,
    meter_name
)

select
  *,
  case
    when export_energy_wh > 0 then 1
    when export_energy_wh = 0 then 0
  end as has_energy
from meter_registry_hourly_raw
