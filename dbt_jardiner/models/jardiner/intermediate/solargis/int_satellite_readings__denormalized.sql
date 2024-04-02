{{ config(materialized='view') }}

select
  sg.start_hour,
  sg.plant_id,
  p.plant_name,
  p.plant_uuid,
  sg.request_time,
  sg.horizontal_irradiation_wh_m2,
  sg.tilted_irradiation_wh_m2,
  sg.module_temperature_dc,
  sg.energy_output_kwh
from {{ ref('raw_solargis_satellite_readings__temp_and_pv_energy') }} as sg
  left join {{ ref('raw_plantmonitor_plants') }} using (plant_id)
  left join
    {{ ref('raw_gestio_actius_plant_parameters') }} as p
    using (plant_uuid)

-- SolarGis PVOUT (aquí photovoltaic_energy_output_wh) retorna l'energia en kwh però plantmonitor per error ho registra com a wh sense fer cap transformació.
-- Entenem que al redash s'està corregint a mà abans de mostrar el valor.
-- Aquí canviem el nom perquè s'ajusti a la realitat del valor.
