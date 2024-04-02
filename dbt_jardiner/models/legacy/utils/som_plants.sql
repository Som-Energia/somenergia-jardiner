{{ config(materialized='view') }}

select
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_codename,
  plantparameters.peak_power_w as peak_power_w
from {{ source('plantmonitor_legacy','plant') }} as plant
  left join
    {{ source ('plantmonitor_legacy', 'plantparameters') }} as plantparameters
    on plant.id = plantparameters.plant
where plant.description != 'SomRenovables'
