{{ config(materialized='view') }}

select
  plant_id,
  date_trunc('day', start_hour) as day,
  sum(horizontal_irradiation_wh_m2) as horizontal_irradiation_wh_m2,
  sum(tilted_irradiation_wh_m2) as tilted_irradiation_wh_m2,
  round(avg(module_temperature_dc), 2) as module_temperature_dc_mean,
  sum(energy_output_kwh) as energy_output_kwh,
  count(*) as hours_with_reading
from {{ ref('satellite_readings__hourly_legacy') }}
group by date_trunc('day', start_hour), plant_id
