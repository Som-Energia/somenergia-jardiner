{{ config(materialized='table') }}

with ppd as (
  select
    day as day,
    plant_id as plant_id,
    plant_name as plant_name,
    plant_codename as plant_codename,
    meter_id as meter_id,
    meter_name as meter_name,
    current_meter_connection_protocol as current_meter_connection_protocol,
    plant_peak_power_kw as plant_peak_power_kw,
    sum(coalesce(meter_registry_export_energy_kwh,0)) as meter_registry_export_energy_kwh,
    SUM(CASE WHEN meter_registry_export_energy_kwh is not null THEN 1  else 0 END) as meter_registry_hours_with_readings,
    SUM(CASE WHEN meter_registry_export_energy_kwh > 0 THEN 1  else 0 END) as meter_registry_hours_with_energy,
    SUM(satellite_readings_horizontal_irradiation_kwh_m2) as satellite_readings_horizontal_irradiation_kwh_m2,
    SUM(satellite_readings_tilted_irradiation_kwh_m2) as satellite_readings_tilted_irradiation_kwh_m2,
    round(avg(satellite_readings_module_temperature_dc),2) as satellite_readings_module_temperature_dc_mean,
    SUM(satellite_readings_energy_output_kwh) as satellite_readings_energy_output_kwh,
    SUM(CASE WHEN satellite_readings_energy_output_kwh is not null THEN 1  else 0 END) as satellite_hours_with_readings,
    SUM(CASE WHEN daylight_real is TRUE THEN 1 else 0 END) as solar_hours_real,
    SUM(CASE WHEN daylight_generous is TRUE THEN 1 else 0 END) as solar_hours_minimum,
    SUM(forecast_energy_kwh) as forecast_energy_kwh,
    sum(abs(deviation_exported_vs_forecast_expected_kwh)) as deviation_exported_vs_forecast_expected_kwh_cumsum_abs
  from {{ref('plant_production_hourly')}}
  group by
    day,
    plant_id,
    plant_name,
    plant_codename,
    meter_id,
    meter_name,
    current_meter_connection_protocol,
    plant_peak_power_kw
)

select
  *,
  meter_registry_export_energy_kwh - satellite_readings_energy_output_kwh as deviation_exported_vs_satellite_expected_kwh,
  solar_hours_minimum - meter_registry_hours_with_energy as unexpected_hours_without_energy,
  round((deviation_exported_vs_forecast_expected_kwh_cumsum_abs / NULLIF(meter_registry_export_energy_kwh,0)) * 100,2) as deviation_from_forecast_cumsum_ratio,
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
  from ppd
order by day desc