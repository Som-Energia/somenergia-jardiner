{{ config(materialized='view') }}

SELECT
    plant.id as plant_id,
    plant.name as plant_name,
    plant.codename as plant_codename,
    plantparameters.peak_power_w as peak_power_w
FROM {{source('plantmonitordb','plant')}} as plant
LEFT JOIN {{source ('plantmonitordb', 'plantparameters')}} as plantparameters
    on plant.id = plantparameters.plant
where description != 'SomRenovables'
