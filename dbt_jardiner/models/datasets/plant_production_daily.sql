{{ config(materialized='table') }}

with combined_meter_satellite as (
  select
    spine.day::date as day,
    spine.plant_id as plant_id,
    spine.plant_name as plant_name,
    spine.plant_codename as plant_codename,
    spine.meter_id as meter_id,
    spine.meter_name as meter_name,
    spine.meter_connection_protocol as meter_connection_protocol,
    coalesce(meter_registry.hours_with_reading, 0) as meter_registry_hours_with_readings,
    round(meter_registry.export_energy_wh::numeric/1000, 2) as meter_registry_export_energy_kwh,
    meter_registry.hours_with_energy as meter_registry_hours_with_energy,
    round(satellite_readings.horizontal_irradiation_wh_m2::numeric/1000, 2) as satellite_readings_horizontal_irradiation_kwh_m2,
    round(satellite_readings.tilted_irradiation_wh_m2::numeric/1000, 2) as satellite_readings_tilted_irradiation_kwh_m2,
    round(satellite_readings.module_temperature_dc_mean::numeric/100, 2) as satellite_readings_module_temperature_dc_mean,
    round(satellite_readings.energy_output_wh::numeric/1000, 2) as satellite_readings_energy_output_kwh,
    solar_events.solar_hours_real,
    solar_events.solar_hours_minimum,
    round(forecast.energy_kwh,2) as forecast_energy_kwh
  from {{ref('spine_plant_meter_today')}} as spine
  left join {{ref('meter_registry_daily')}} as meter_registry
    using(plant_id, day)
  left join {{ ref('satellite_readings_daily') }} as satellite_readings
    using(plant_id, day)
  left join {{ ref('solar_events_generous') }} as solar_events
    using(plant_id, day)
  left join {{ ref('forecasts_daily') }} as forecast
    using(plant_id, day)
)

select
  *,
  satellite_readings_energy_output_kwh - meter_registry_export_energy_kwh as satellite_meter_difference_energy_wh,
  forecast_energy_kwh - meter_registry_export_energy_kwh as forecast_meter_difference_energy_kwh,
  solar_hours_minimum - meter_registry_hours_with_energy as unexpected_hours_without_energy
  --100*(photovoltaic_energy_output_wh/NULLIF(export_energy_wh_total, 0.0)) as relative_energy_difference
  from combined_meter_satellite
order by day desc