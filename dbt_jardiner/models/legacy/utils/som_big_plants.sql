{{ config(materialized='view') }}

select
  pp.*,
  plant.id as plant_id,
  plant.name as plant_name
from plant
  left join {{ source('plantmonitor_legacy', 'plantparameters') }} as pp on plant.id = pp.plant
where pp.peak_power_w > 300000
