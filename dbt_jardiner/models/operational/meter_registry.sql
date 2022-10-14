{{ config(materialized='view') }}


SELECT
  time - interval '1 hour' as time_start_hour,
  export_energy_wh,
  import_energy_wh,
  meter,
  meter.connection_protocol,
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_code,
FROM {{source('plantmonitor','meterregistry')}} as mr
left join {{source('plantmonitor','meter')}} on meter.id = mr.meter
left join {{source('plantmonitor','plant')}} as plant on plant.id = meter.plant
order by time desc