{{ config(materialized='view') }}


select
  mr.export_energy_wh,
  mr.import_energy_wh,
  meter.id as meter_id,
  meter.name as meter_name,
  meter.connection_protocol,
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_code,
  mr.time - interval '1 hour' as time_start_hour
from {{ source('plantmonitor_legacy','meterregistry') }} as mr
  left join {{ source('plantmonitor_legacy','meter') }} as meter on meter.id = mr.meter
  left join
    {{ source('plantmonitor_legacy','plant') }} as plant
    on plant.id = meter.plant
