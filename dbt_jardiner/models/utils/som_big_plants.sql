{{ config(materialized='view') }}

select plant.id as plant_id, plant.name as plant_name, pp.* from plant
left join plantparameters as pp on plant.id = pp.plant
where pp.peak_power_w > 300000