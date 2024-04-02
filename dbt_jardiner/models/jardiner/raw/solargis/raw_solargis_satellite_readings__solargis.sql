{{ config(materialized='view') }}


select
  plant,
  global_horizontal_irradiation_wh_m2,
  global_tilted_irradiation_wh_m2,
  photovoltaic_energy_output_wh,
  request_time,
  date_trunc('hour', "time") as start_hour,
  module_temperature_dc * 10 as module_temperature_c
from {{ source('solargis', 'satellite_readings') }}
