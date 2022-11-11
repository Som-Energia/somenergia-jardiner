{{ config(materialized='view') }}


SELECT
  time - interval '1 hour' as time,
  export_energy_wh,
  import_energy_wh,
  meter as meter_id,
  meter.name as meter_name,
  meter.connection_protocol
FROM {{source('plantmonitordb','meterregistry')}} as mr
left join {{source('plantmonitordb','meter')}} on meter.id = mr.meter
left join {{source('plantmonitordb','plant')}} as plant on plant.id = meter.plant
order by time desc