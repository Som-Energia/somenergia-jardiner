{{ config(materialized="table") }}

with
combined_meter_satellite as (
  select
    spine.start_hour as start_hour,
    spine.start_hour::date as "day",
    spine.plant_id as plant_id,
    spine.plant_name as plant_name,
    spine.plant_codename as plant_codename,
    spine.meter_id as meter_id,
    spine.meter_name as meter_name,
    spine.meter_connection_protocol as current_meter_connection_protocol,
    --fmt:off
    round(spine.peak_power_w::numeric / 1000, 2) as plant_peak_power_kw,
    round(
      meter_registry.export_energy_wh::numeric / 1000, 2
    ) as meter_registry_export_energy_kwh,
    round(
      satellite_readings.horizontal_irradiation_wh_m2::numeric / 1000, 2
    ) as satellite_readings_horizontal_irradiation_kwh_m2,
    round(
      satellite_readings.tilted_irradiation_wh_m2::numeric / 1000, 2
    ) as satellite_readings_tilted_irradiation_kwh_m2,
    round(
      satellite_readings.module_temperature_dc::numeric / 100, 2
    ) as satellite_readings_module_temperature_dc,
    round(
      satellite_readings.energy_output_kwh::numeric, 2
    ) as satellite_readings_energy_output_kwh,
    spine.start_hour between solar_events.sunrise_real and solar_events.sunset_real as daylight_real,
    spine.start_hour between solar_events.sunrise_generous and solar_events.sunset_generous as daylight_generous,
    --fmt:on
    round(forecast.energy_kwh, 2) as forecast_energy_kwh
  from {{ ref("spine_plant_meter_until_last_hour") }} as spine
    left join
      {{ ref("meter_registry_hourly") }} as meter_registry
      on
        spine.plant_id = meter_registry.plant_id
        and spine.start_hour = meter_registry.time_start_hour
    left join
      {{ ref("satellite_readings__hourly_legacy") }} as satellite_readings
      on
        spine.plant_id = satellite_readings.plant_id
        and spine.start_hour = satellite_readings.start_hour
    left join
      {{ ref("plantmonitordb_solarevent__generous") }} as solar_events
      on
        spine.plant_id = solar_events.plant_id
        and solar_events.day = spine.start_hour::date
    left join
      {{ ref("forecasts_hourly") }} as forecast
      on
        spine.plant_id = forecast.plant_id
        and spine.start_hour = forecast.time_start_hour
)

select
  *,
  meter_registry_export_energy_kwh
  - satellite_readings_energy_output_kwh as deviation_exported_vs_satellite_expected_kwh,
  meter_registry_export_energy_kwh
  - forecast_energy_kwh as deviation_exported_vs_forecast_expected_kwh,
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
      and plant_peak_power_kw is not null
      and plant_peak_power_kw > 0
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
from combined_meter_satellite
order by start_hour desc
