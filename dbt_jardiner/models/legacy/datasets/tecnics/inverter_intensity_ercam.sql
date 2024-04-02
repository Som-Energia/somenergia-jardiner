{{ config(post_hook="grant select on {{ this }} to group ercam") }}

select
  reg."time",
  plant.id as plant_id,
  plant.name as plant_name,
  inverter.name as inverter_name,
  string.name as string_name,
  string.stringbox_name,
  reg.intensity_ma
from {{ source('plantmonitor_legacy', 'stringregistry') }} as reg
  left join
    {{ source('plantmonitor_legacy', 'string') }} as string
    on reg.string = string.id
  left join
    {{ source('plantmonitor_legacy', 'inverter') }} as inverter
    on string.inverter = inverter.id
  left join
    {{ source('plantmonitor_legacy', 'plant') }} as plant
    on inverter.plant = plant.id
where plant.id in (select id from {{ ref('plants_ercam') }})
