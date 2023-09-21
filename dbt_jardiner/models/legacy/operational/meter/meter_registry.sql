{{ config(materialized='view') }}


SELECT
  time - interval '1 hour' as time_start_hour,
  export_energy_wh,
  import_energy_wh,
  meter as meter_id,
  meter.name as meter_name,
  meter.connection_protocol,
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_code,
  TRUE
FROM {{source('plantmonitor_legacy','meterregistry')}} as mr
left join {{source('plantmonitor_legacy','meter')}} on meter.id = mr.meter
left join {{source('plantmonitor_legacy','plant')}} as plant on plant.id = meter.plant
