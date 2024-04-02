{{ config(materialized='view') }}

with inverterregistry_sct as (
  select
    alert.time,
    alert.plant_id,
    alert.plant_name,
    alert.inverter_id,
    alert.inverter_name,
    alert.temperature_c as temperature_c,
    50 < alert.temperature_c as is_alarmed
  from
    {{ ref('alert_inverterregistry_clean_last_hour') }} as alert
)

select
  plant_id,
  plant_name,
  inverter_id,
  inverter_name,
  'inverter' as device_type,
  inverter_name as device_name,
  'alert_inverter_temperature' as alarm_name,
  max(time) as time, --noqa: RF04
  min(temperature_c) as min_temperature_c,
  max(temperature_c) as max_temperature_c,
  every(is_alarmed) as is_alarmed
from inverterregistry_sct
group by plant_id, plant_name, inverter_id, inverter_name
