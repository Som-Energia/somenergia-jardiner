{{ config(materialized='view') }}

select
    time,
    sg.plant_id,
    plant_name,
    request_time,
    horizontal_irradiation_wh_m2,
    tilted_irradiation_wh_m2,
    module_temperature_dc,
    energy_output_kwh
from {{ ref('satellite_readings_raw') }} sg
left join {{ref('som_plants_raw')}} p on p.plant_id = sg.plant_id

-- SolarGis PVOUT (aquí photovoltaic_energy_output_wh) retorna l'energia en kwh però plantmonitor per error ho registra com a wh sense fer cap transformació.
-- Entenem que al redash s'està corregint a mà abans de mostrar el valor.
-- Aquí canviem el nom perquè s'ajusti a la realitat del valor.
