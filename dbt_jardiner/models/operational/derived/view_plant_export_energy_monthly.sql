{{ config(materialized='view') }}

select
    date_trunc('month', (time - interval '1 hour') at time zone 'Europe/Madrid') as time,
    meter.plant as plant_id,
    meter as meter_id,
    sum(export_energy_wh) as export_energy_wh,
    sum(import_energy_wh) as import_energy_wh
from {{ source('plantmonitordb','meterregistry') }} as mr
left join {{ source('plantmonitordb','meter') }} on meter.id = mr.meter
left join {{ source('plantmonitordb','plant') }} as plant on plant.id = meter.plant
group by time, plant_id, meter_id
