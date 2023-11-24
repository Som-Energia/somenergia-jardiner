{{ config(materialized='view') }}

SELECT
    plant.id as plant_id,
    plant.name as plant_name,
    plant.codename as plant_codename,
    device_uuid as plant_uuid
FROM {{source('plantmonitor_legacy','plant')}}
