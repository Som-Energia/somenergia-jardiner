{{ config(materialized='view') }}

select
  sg.start_hour,
  plant_id,
  p.plant_name,
  sg.request_time,
  sg.horizontal_irradiation_wh_m2,
  sg.tilted_irradiation_wh_m2,
  sg.module_temperature_dc,
  sg.energy_output_kwh
from {{ ref("solargis_satellite_readings__temp_and_pv_energy_legacy") }} as sg
  left join
    {{ ref('gestio_actius_plant_parameters__raw_legacy') }} as p using (plant_id)

-- SolarGis PVOUT (aquí photovoltaic_energy_output_wh) retorna l'energia en kwh però plantmonitor per error ho registra com a wh sense fer cap transformació.
-- Entenem que al redash s'està corregint a mà abans de mostrar el valor.
-- Aquí canviem el nom perquè s'ajusti a la realitat del valor.
