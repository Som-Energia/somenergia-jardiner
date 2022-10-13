{{ config(materialized='view') }}

with combined_meter_satellite as (
  select
    mr.day,
    mr.meter,
    mr.plant_id,
    mr.plant_name,
    mr.plant_code,
    mr.hours_with_reading,
    mr.export_energy_wh_total,
    mr.hours_with_energy,
    global_horizontal_irradiation_wh_m2,
    global_tilted_irradiation_wh_m2,
    module_temperature_dc_mean,
    photovoltaic_energy_output_wh,
    solar_hours_real,
    solar_hours_minimum
  from {{ref('meter_registry_daily')}} as mr
  left join {{ ref('satellite_readings_daily') }} as sr on sr.plant = mr.plant_id and mr.day = sr.day
  left join {{ ref('solar_events_generous') }} as se on se.plant = mr.plant_id and mr.day = se.day
)

select
*,
photovoltaic_energy_output_wh - export_energy_wh_total as energy_difference
--100*(photovoltaic_energy_output_wh/export_energy_wh_total::decimal) as relative_energy_difference
from combined_meter_satellite