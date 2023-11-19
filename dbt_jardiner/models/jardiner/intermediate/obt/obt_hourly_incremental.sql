{{ config(materialized='table') }}

{# falta afegir
    - l'iMHèCIL
#}

with plants as (
    select distinct plant, plant_uuid from {{ ref('int_signal_device_relation__distinct_devices') }}
)
select
    spine.start_hour,
    plants.plant_uuid,
    plants.plant as plant_name,
    plant_metadata.plant_id as plantmonitor_plant_id,
    plant_metadata.peak_power_kw::float as peak_power_kw,
    plant_metadata.technology as technology,
    dset.irradiation as dset_irradiation_wh,
    dset.inverter_exported_energy as dset_inverter_energy_kwh,
    dset.meter_exported_energy as dset_meter_instant_exported_energy_kwh,
    NULL::integer as dset_meter_exported_energy_kwh,
    NULL::integer as dset_meter_imported_energy_kwh,
    forecast.forecastdate as forecast_date,
    forecast.energy_kwh as forecast_energy_kwh,
    sr.tilted_irradiation_wh_m2 as satellite_irradiation_wh_m2,
    sr.module_temperature_dc as satellite_module_temperature_dc,
    sr.energy_output_kwh as satellite_energy_output_kwh,
    omie.price as omie_price_eur_mwh,
    {# exported_energy should be in wh we pass it to kwh. Also the /1000 is GSTC[W/m2] #}
    (dset.meter_exported_energy*1000 / plant_metadata.peak_power_kw::float) / (NULLIF(sr.tilted_irradiation_wh_m2, 0.0) / 1000.0) as pr_hourly,
    spine.start_hour between solar_events.sunrise_real and solar_events.sunset_real as is_daylight_real,
    spine.start_hour between solar_events.sunrise_generous and solar_events.sunset_generous as is_daylight_generous,
    round(meter_registry.export_energy_wh/1000,2) as erp_meter_exported_energy_kwh,
    round(meter_registry.import_energy_wh/1000,2) as erp_meter_imported_energy_kwh
from {{ ref('spine_hourly') }} as spine
left join plants ON TRUE
left join {{ ref('raw_gestio_actius_plant_parameters') }} plant_metadata on plants.plant_uuid = plant_metadata.plant_uuid
left join {{ ref('int_dset_metrics_wide_hourly') }} dset using(start_hour, plant)
left join {{ ref('int_energy_forecasts__best_from_plantmonitordb') }} forecast using(start_hour, plant_id)
left join {{ ref('int_satellite_readings__hourly') }} sr
    on spine.start_hour = sr.start_hour and sr.plant_name = plants.plant
left join {{ ref('raw_plantlake_omie_historical_price__with_row_number_per_date') }} omie on omie.start_hour = spine.start_hour
{# old plantmonitor stuff #}
left join {{ ref('raw_plantmonitordb_solarevent__generous') }} as solar_events
    on solar_events.plant_id = plant_metadata.plant_id and solar_events.day = spine.start_hour::date
{# temporarely use plantmonitors' meterregistry until dset provides it #}
left join {{ref('int_erp_meter_registry__hourly')}} as meter_registry
    on meter_registry.plant_id = plant_metadata.plant_id and meter_registry.time_start_hour = spine.start_hour
order by start_hour desc, plant
