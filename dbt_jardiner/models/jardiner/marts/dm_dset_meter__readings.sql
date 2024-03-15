{{ config(materialized='table') }}

select
  start_ts,
  plant_uuid as uuid_planta,
  plant_name as nom_planta,
  meter_exported_energy as energia_activa_exportada,
  meter_imported_energy as energia_activa_importada,
  meter_reactive_energy_q1 as energia_reactiva_q1,
  meter_reactive_energy_q2 as energia_reactiva_q2,
  meter_reactive_energy_q3 as energia_reactiva_q3,
  meter_reactive_energy_q4 as energia_reactiva_q4,
  meter_instant_exported_energy as energia_activa_exportada_instantania
from {{ ref("int_dset_meter__readings_wide") }}
