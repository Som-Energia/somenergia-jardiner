{{ config(materialized='view') }}

select
  reg.plant,
  date_trunc('day', reg.time at time zone 'Europe/Madrid') as "time",
  count(*) as ht
from {{ ref('view_satellite_irradiation') }} as reg
  inner join
    {{ source('plantmonitor_legacy', 'plant') }} as plant
    on reg.plant = plant.id
where reg.irradiation_wh_m2 > 5
group by
  date_trunc('day', reg.time at time zone 'Europe/Madrid'),
  reg.plant
order by date_trunc('day', reg.time at time zone 'Europe/Madrid')
