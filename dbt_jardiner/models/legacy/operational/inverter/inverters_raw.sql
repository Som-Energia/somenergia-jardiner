{{ config(materialized='view') }}

SELECT
    id as inverter_id,
    name as inverter_name,
    plant as plant_id,
    model as inverter_model,
    round(nominal_power_w/1000.0, 2) as nominal_power_kw
FROM {{source('plantmonitor_legacy','inverter')}}
