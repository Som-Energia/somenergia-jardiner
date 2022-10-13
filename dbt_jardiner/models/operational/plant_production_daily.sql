{{ config(materialized='view') }}

with combined_meter_satellite as (
  select
    *
  from {{ref('meter_registry_daily')}} as mr
  left join {{ ref('satellite_readings_daily') }} as se on se.plant = mr.plant_id and mr.day = se.day
)

select
*,
photovoltaic_energy_output_wh - export_energy_wh_total as energy_difference,
100*(photovoltaic_energy_output_wh/export_energy_wh_total::decimal) as relative_energy_difference
from combined_meter_satellite