{{ config(materialized='table',
        docs={'node_color': '#d05808'}) }}

with erp_meter_registries_before_2024 as (
  select * from {{ ref('int_erp_meter_registry__hourly') }}
  where start_hour < '2024-01-01'
),
obt_base as (
  select
    spine.start_hour,
    plant_metadata.plant_uuid,
    plant_metadata.plant_name,
    plant_metadata.plant_id as plantmonitor_plant_id,
    plant_metadata.has_plantmonitor,
    plant_metadata.peak_power_kw::float as peak_power_kw,
    plant_metadata.technology as technology,
    dset.irradiation as dset_irradiation_wh,
    dset.inverter_exported_energy as dset_inverter_energy_kwh,
    dset.meter_instant_exported_energy as dset_meter_instant_exported_energy_kwh,
    dset_meter_readings.meter_exported_energy as dset_meter_exported_energy_kwh,
    dset_meter_readings.meter_imported_energy as dset_meter_imported_energy_kwh,
    forecast.forecastdate as forecast_date,
    forecast.energy_kwh as forecast_energy_kwh,
    sr.tilted_irradiation_wh_m2 as satellite_irradiation_wh_m2,
    sr.module_temperature_dc as satellite_module_temperature_dc,
    sr.energy_output_kwh as satellite_energy_output_kwh,
    omie.price as omie_price_eur_mwh,
    spine.start_hour between solar_events.sunrise_real and solar_events.sunset_real as is_daylight_real,
    spine.start_hour between solar_events.sunrise_generous and solar_events.sunset_generous as is_daylight_generous,
    {#- exported_energy should be in wh we pass it to kwh #}
    round(meter_registry.export_energy_wh / 1000, 2) as erp_meter_exported_energy_kwh,
    round(meter_registry.import_energy_wh / 1000, 2) as erp_meter_imported_energy_kwh
  from
    {{ ref('spine_hourly') }} as spine
    {#- plant_parameters is the single source of truth about which plants we have, unexpected plants won't join#}
    left join {{ ref('raw_gestio_actius_plant_parameters') }} as plant_metadata on true
    left join {{ ref('int_dset_metrics_wide_hourly') }} as dset using (start_hour, plant_uuid)
    left join {{ ref('int_dset_meter__readings_wide_hourly') }} as dset_meter_readings using (start_hour, plant_uuid)
    left join {{ ref('int_energy_forecasts__best_from_plantmonitordb') }} as forecast using (start_hour, plant_uuid)
    left join {{ ref('int_satellite_readings__hourly') }} as sr using (start_hour, plant_uuid)
    left join {{ ref('raw_plantlake_omie_historical_price__with_row_number_per_date') }} as omie using (start_hour)
    left join erp_meter_registries_before_2024 as meter_registry using (start_hour, plant_uuid)
    left join {{ ref('int_plantmonitordb_solarevent__generous') }} as solar_events
      on plant_metadata.plant_uuid = solar_events.plant_uuid and solar_events.day = spine.start_hour::date
), obt_derived as (
  select
    *,
    coalesce(dset_meter_exported_energy_kwh, erp_meter_exported_energy_kwh) as meter_exported_energy_kwh,
    coalesce(dset_meter_imported_energy_kwh, erp_meter_imported_energy_kwh) as meter_imported_energy_kwh,
    {# The /1000 is GSTC[W/m2] #}
    (dset_meter_exported_energy_kwh / peak_power_kw) / (nullif(satellite_irradiation_wh_m2, 0.0) / 1000.0) as pr_hourly
  from obt_base
  order by start_hour desc, plant_name asc
)
select
  *
from obt_derived
