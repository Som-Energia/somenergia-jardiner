{{ config(materialized='table') }}

{# falta afegir
    - l'iMHèCIL
#}

with plants as (
    select distinct plant from {{ ref('devices') }}
)
select
    spine.start_hour,
    plants.plant,
    dset.irradiation as dset_irradiation_wh,
    dset.inverter_energy as dset_inverter_energy_kwh,
    dset.exported_energy as dset_meter_exported_energy_kwh,
    forecast.forecastdate as forecast_date,
    forecast.energy_kwh as forecast_energy_kwh,
    sr.horizontal_irradiation_wh_m2 as satellite_horizontal_irradiation_wh_m2,
    sr.tilted_irradiation_wh_m2 as satellite_tilted_irradiation_wh_m2,
    sr.module_temperature_dc as satellite_module_temperature_dc,
    sr.energy_output_kwh as satellite_energy_output_kwh,
    omie.price as omie_price_eur_kwh
from {{ ref('spine_hourly') }} as spine
left join plants ON TRUE
left join {{ ref('som_plants_raw') }} plant_metadata on plants.plant = plant_metadata.plant_name
left join {{ ref('dset_metrics_wide_hourly') }} dset using(start_hour, plant)
left join {{ ref('forecasts_best') }} forecast using(start_hour, plant)
left join {{ ref('satellite_readings_hourly') }} sr on spine.start_hour = sr.time_start_hour and sr.plant_name = plants.plant
left join {{ ref('omie_raw') }} omie on omie.start_hour = spine.start_hour
order by start_hour desc, plant

