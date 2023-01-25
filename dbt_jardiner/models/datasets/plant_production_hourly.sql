{{ config(materialized='table') }}

with combined_meter_satellite as (
  select
    spine.start_hour as start_hour,
    spine.start_hour::date as day,
    spine.plant_id as plant_id,
    spine.plant_name as plant_name,
    spine.plant_codename as plant_codename,
    spine.meter_id as meter_id,
    spine.meter_name as meter_name,
    spine.meter_connection_protocol as current_meter_connection_protocol,
    round(spine.peak_power_w::numeric/1000, 2) as plant_peak_power_kw,
    round(meter_registry.export_energy_wh::numeric/1000, 2) as meter_registry_export_energy_kwh,
    round(satellite_readings.horizontal_irradiation_wh_m2::numeric/1000, 2) as satellite_readings_horizontal_irradiation_kwh_m2,
    round(satellite_readings.tilted_irradiation_wh_m2::numeric/1000, 2) as satellite_readings_tilted_irradiation_kwh_m2,
    round(satellite_readings.module_temperature_dc::numeric/100, 2) as satellite_readings_module_temperature_dc,
    round(satellite_readings.energy_output_kwh::numeric, 2) as satellite_readings_energy_output_kwh,
    start_hour between sunrise_real and sunset_real as daylight_real,
    start_hour between sunrise_generous and sunset_generous as daylight_generous,
    round(forecast.energy_kwh,2) as forecast_energy_kwh
  from {{ref('spine_plant_meter_until_last_hour')}} as spine
  left join {{ref('meter_registry_hourly')}} as meter_registry
    on meter_registry.plant_id = spine.plant_id and meter_registry.time_start_hour = spine.start_hour
  left join {{ ref('satellite_readings_hourly') }} as satellite_readings
    on satellite_readings.plant_id = spine.plant_id and satellite_readings.time_start_hour = spine.start_hour
  left join {{ ref('solar_events_generous') }} as solar_events
    on solar_events.plant_id = spine.plant_id and solar_events.day = spine.start_hour::date
  left join {{ ref('forecasts_hourly') }} as forecast
    on forecast.plant_id = spine.plant_id and forecast.time_start_hour = spine.start_hour
)

select
  *,
  meter_registry_export_energy_kwh - satellite_readings_energy_output_kwh as deviation_exported_vs_satellite_expected_kwh,
  meter_registry_export_energy_kwh - forecast_energy_kwh as deviation_exported_vs_forecast_expected_kwh,
  CASE
    WHEN meter_registry_export_energy_kwh is not null and meter_registry_export_energy_kwh > 0
      AND satellite_readings_energy_output_kwh is not null and satellite_readings_energy_output_kwh > 0
    THEN round(((meter_registry_export_energy_kwh / satellite_readings_energy_output_kwh)-1)::numeric*100,2)
  END as p_deviation_exported_vs_expected_satellite,
  CASE
    WHEN meter_registry_export_energy_kwh is not null and meter_registry_export_energy_kwh > 0
      AND plant_peak_power_kw is not null and plant_peak_power_kw > 0
      AND satellite_readings_tilted_irradiation_kwh_m2 is not null and satellite_readings_tilted_irradiation_kwh_m2 > 0
    THEN round(((meter_registry_export_energy_kwh / plant_peak_power_kw)::float / satellite_readings_tilted_irradiation_kwh_m2)::numeric,4)
  END as performance_ratio
  from combined_meter_satellite
order by start_hour desc