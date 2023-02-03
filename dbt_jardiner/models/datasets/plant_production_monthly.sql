{{ config(materialized='table') }}

-- current providers:
-- Satellite: Solargis
-- Forecast: OMIE (Meteologica)

with plant_production_daily as (
  select
  date_trunc('month', day) as month,
  plant_id,
  plant_name,
  plant_codename,
  meter_id,
  meter_name,
  current_meter_connection_protocol,
  plant_peak_power_kw,
  round(sum(meter_registry_hours_with_readings)/(count(*)*24)*100,2) as p_meter_hours_with_readings, --ens mengem el cavni d'hora
  round(sum(satellite_hours_with_readings)/(count(*)*24)*100,2) as p_satellite_hours_with_readings,--ens mengem el cavni d'hora
  sum(meter_registry_export_energy_kwh) as meter_registry_export_energy_kwh,
  sum(meter_registry_hours_with_energy) as meter_registry_hours_with_energy,
  sum(satellite_readings_horizontal_irradiation_kwh_m2) as satellite_readings_horizontal_irradiation_kwh_m2,
  sum(satellite_readings_tilted_irradiation_kwh_m2) as satellite_readings_tilted_irradiation_kwh_m2,
  round(avg(satellite_readings_module_temperature_dc_mean),2) as satellite_readings_module_temperature_dc_mean,
  sum(satellite_readings_energy_output_kwh) as satellite_readings_energy_output_kwh,
  sum(solar_hours_real) as solar_hours_real,
  sum(solar_hours_minimum) as solar_hours_minimum,
  sum(forecast_energy_kwh) as forecast_energy_kwh,
  sum(deviation_exported_vs_satellite_expected_kwh) as deviation_exported_vs_satellite_expected_kwh,
  sum(deviation_exported_vs_forecast_expected_kwh_cumsum_abs) as deviation_exported_vs_forecast_expected_kwh_cumsum_abs,
  sum(unexpected_hours_without_energy) as unexpected_hours_without_energy
  from {{ref('plant_production_daily')}}
  group by
    month,
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
from plant_production_daily
order by month desc