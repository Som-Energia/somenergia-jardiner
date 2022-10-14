{{ config(materialized='view') }}

select
    time,
    plant as plant_id,
    request_time as request_time,
    global_horizontal_irradiation_wh_m2 as horizontal_irradiation_wh_m2,
    global_tilted_irradiation_wh_m2 as tilted_irradiation_wh_m2,
    module_temperature_dc as module_temperature_dc,
    photovoltaic_energy_output_wh as energy_output_wh,
    TRUE
from {{ source('plantmonitor','satellite_readings') }}
