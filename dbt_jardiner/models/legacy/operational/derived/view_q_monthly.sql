{{ config(materialized='view') }}

select
  plant.id as plant_id,
  meter.id as meter_id,
  date_trunc(
    'month', reg.time at time zone 'Europe/Madrid'
  ) at time zone 'Europe/Madrid' as time, --noqa: RF04
  sum(reg.import_energy_wh) as import_energy_wh,
  sum(reg.export_energy_wh) as export_energy_wh,
  sum(reg.r1_varh - reg.r4_varh) as qimportada,
  sum(reg.r2_varh - reg.r3_varh) as qexportada
from {{ source('plantmonitor_legacy','meterregistry') }} as reg
  left join {{ source('plantmonitor_legacy','meter') }} as meter on meter.id = reg.meter
  left join {{ source('plantmonitor_legacy','plant') }} as plant on plant.id = meter.plant
group by
  date_trunc('month', reg.time at time zone 'Europe/Madrid'),
  plant.id,
  reg.meter,
  meter.id
