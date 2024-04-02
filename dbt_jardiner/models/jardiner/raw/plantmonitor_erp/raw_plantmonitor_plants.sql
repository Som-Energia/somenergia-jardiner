{{ config(materialized='view') }}

select
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_codename,
  plant.description as plant_description,
  plant.device_uuid as plant_uuid
from {{ source('plantmonitor_jardiner','plant') }} as plant
where plant.description != 'SomRenovables'
