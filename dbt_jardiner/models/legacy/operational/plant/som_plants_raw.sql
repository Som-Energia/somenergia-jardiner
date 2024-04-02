{{ config(materialized='view') }}

select
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_codename
from {{ source('plantmonitor_legacy','plant') }} as plant
where plant.description != 'SomRenovables'
