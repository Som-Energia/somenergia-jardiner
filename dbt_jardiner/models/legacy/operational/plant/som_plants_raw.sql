{{ config(materialized='view') }}

SELECT
    plant.id as plant_id,
    plant.name as plant_name,
    plant.codename as plant_codename
FROM {{source('plantmonitor_legacy','plant')}}
where description != 'SomRenovables'
