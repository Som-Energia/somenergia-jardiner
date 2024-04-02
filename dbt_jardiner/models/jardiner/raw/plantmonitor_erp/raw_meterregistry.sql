{{ config(materialized='view') }}


select
  mr.export_energy_wh,
  mr.import_energy_wh,
  mr.meter as meter_id,
  meter.name as meter_name,
  meter.connection_protocol,
  meter.plant as plant_id,
  mr.time - interval '1 hour' as start_hour
from {{ source('plantmonitor_jardiner','meterregistry') }} as mr
  left join {{ source('plantmonitor_jardiner','meter') }} as meter on meter.id = mr.meter
