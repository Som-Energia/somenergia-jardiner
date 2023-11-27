{{ config(materialized='view') }}

SELECT
    plant.id as plant_id,
    plant.name as plant_name,
    plant.codename as plant_codename,
    plant.description as plant_description,
    device_uuid as plant_uuid
FROM {{source('plantmonitor_legacy','plant')}}
where plant.description != 'SomRenovables'
