{{ config(materialized='view') }}


select
    date_trunc('hour', "time") as start_hour,
    plant,
    global_horizontal_irradiation_wh_m2,
    global_tilted_irradiation_wh_m2,
    module_temperature_dc*10 as module_temperature_c,
    photovoltaic_energy_output_wh,
    request_time
from {{ source('solargis', 'satellite_readings') }}

