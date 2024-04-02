{{ config(materialized='view') }}

select
  plant.id as plant_id,
  plant.name as plant_name,
  meter.id as meter_id,
  meter.name as meter_name,
  date_trunc(
    'month', (meterregistry."time" - interval '1 hour'), 'Europe/Madrid'
  ) as "time",
  sum(meterregistry.export_energy_wh) as export_energy_wh
from
  {{ source('plantmonitor_legacy','meter') }} as meter
  left join
    {{ source('plantmonitor_legacy','plant') }} as plant
    on
      meter.plant = plant.id
  left join
    {{ source('plantmonitor_legacy','meterregistry') }} as meterregistry
    on
      meter.id = meterregistry.meter
group by
  date_trunc(
    'month', (meterregistry."time" - interval '1 hour'), 'Europe/Madrid'
  ),
  plant_id,
  plant_name,
  meter_id,
  meter_name
order by
  date_trunc(
    'month', (meterregistry."time" - interval '1 hour'), 'Europe/Madrid'
  ),
  plant_id,
  plant_name,
  meter_id,
  meter_name
