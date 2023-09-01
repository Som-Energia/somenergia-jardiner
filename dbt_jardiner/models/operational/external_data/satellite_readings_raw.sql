{{ config(materialized='view') }}

select
    time,
    plant as plant_id,
    request_time as request_time,
    global_horizontal_irradiation_wh_m2 as horizontal_irradiation_wh_m2,
    global_tilted_irradiation_wh_m2 as tilted_irradiation_wh_m2,
    module_temperature_dc as module_temperature_dc,
    photovoltaic_energy_output_wh as energy_output_kwh
from {{ source('plantmonitordb','satellite_readings') }} sg

-- SolarGis PVOUT (aquí photovoltaic_energy_output_wh) retorna l'energia en kwh però plantmonitor per error ho registra com a wh sense fer cap transformació.
-- Entenem que al redash s'està corregint a mà abans de mostrar el valor.
-- Aquí canviem el nom perquè s'ajusti a la realitat del valor.