{{ config(materialized='view') }}

with forecast_denormalized as (
  SELECT
    forecast.time as "time",
    plant.id as plant_id,
    plant.name as plant_name,
    forecastmetadata.forecastdate as forecastdate,
    forecast.percentil50/1000.0 as energy_kwh,
    TRUE
  FROM {{source('plantmonitor','forecast')}}
  LEFT JOIN {{source('plantmonitor','forecastmetadata')}} ON forecastmetadata.id = forecast.forecastmetadata
  LEFT JOIN {{source('plantmonitor','plant')}} ON plant.id = forecastmetadata.plant
)
select * from forecast_denormalized
