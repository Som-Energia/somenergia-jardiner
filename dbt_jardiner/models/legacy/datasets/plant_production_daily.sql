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
    sum(
      coalesce(meter_registry_export_energy_kwh, 0)
    ) as meter_registry_export_energy_kwh,
    sum(
      case
        when meter_registry_export_energy_kwh is not null then 1 else 0
      end
    ) as meter_registry_hours_with_readings,
    sum(
      case when meter_registry_export_energy_kwh > 0 then 1 else 0 end
    ) as meter_registry_hours_with_energy,
    sum(
      satellite_readings_horizontal_irradiation_kwh_m2
    ) as satellite_readings_horizontal_irradiation_kwh_m2,
    sum(
      satellite_readings_tilted_irradiation_kwh_m2
    ) as satellite_readings_tilted_irradiation_kwh_m2,
    round(
      avg(satellite_readings_module_temperature_dc), 2
    ) as satellite_readings_module_temperature_dc_mean,
    sum(
      satellite_readings_energy_output_kwh
    ) as satellite_readings_energy_output_kwh,
    sum(
      case
        when
          satellite_readings_energy_output_kwh is not null
          then 1
        else 0
      end
    ) as satellite_hours_with_readings,
    sum(
      case when daylight_real is true then 1 else 0 end
    ) as solar_hours_real,
    sum(
      case when daylight_generous is true then 1 else 0 end
    ) as solar_hours_minimum,
    sum(forecast_energy_kwh) as forecast_energy_kwh,
    sum(
      abs(deviation_exported_vs_forecast_expected_kwh)
    ) as deviation_exported_vs_forecast_expected_kwh_cumsum_abs
  from {{ ref('plant_production_hourly') }}
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
  meter_registry_export_energy_kwh
  - satellite_readings_energy_output_kwh as deviation_exported_vs_satellite_expected_kwh,
  solar_hours_minimum
  - meter_registry_hours_with_energy as unexpected_hours_without_energy,
  round(
    (
      deviation_exported_vs_forecast_expected_kwh_cumsum_abs
      / nullif(meter_registry_export_energy_kwh, 0)
    )
    * 100,
    2
  ) as deviation_from_forecast_cumsum_ratio,
  case
    when
      meter_registry_export_energy_kwh is not null
      and meter_registry_export_energy_kwh > 0
      and satellite_readings_energy_output_kwh is not null
      and satellite_readings_energy_output_kwh > 0
      then
        round(
          (
            (
              meter_registry_export_energy_kwh
              / satellite_readings_energy_output_kwh
            )
            - 1
          )::numeric
          * 100,
          2
        )
  end as p_deviation_exported_vs_expected_satellite,
  case
    when
      meter_registry_export_energy_kwh is not null
      and meter_registry_export_energy_kwh > 0
      and plant_peak_power_kw is not null and plant_peak_power_kw > 0
      and satellite_readings_tilted_irradiation_kwh_m2 is not null
      and satellite_readings_tilted_irradiation_kwh_m2 > 0
      then
        round(
          (
            (
              meter_registry_export_energy_kwh
              / plant_peak_power_kw
            )::float
            / satellite_readings_tilted_irradiation_kwh_m2
          )::numeric,
          4
        )
  end as performance_ratio
from ppd
order by day desc
