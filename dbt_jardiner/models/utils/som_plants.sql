{{ config(materialized='view') }}

SELECT
    plant.id as plant_id,
    plant.name as plant_name,
    plant.codename as plant_codename
FROM {{source('plantmonitor','plant')}}
where description != 'SomRenovables'