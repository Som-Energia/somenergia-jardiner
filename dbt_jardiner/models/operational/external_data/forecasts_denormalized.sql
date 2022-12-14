{{ config(materialized='view') }}

with forecast_denormalized as (
  SELECT
    forecast.time as "time",
    plant.id as plant_id,
    plant.name as plant_name,
    forecastmetadata.forecastdate as forecastdate,
    forecast.percentil50/1000.0 as energy_kwh,
    TRUE
  FROM {{source('plantmonitordb','forecast')}}
  LEFT JOIN {{source('plantmonitordb','forecastmetadata')}} ON forecastmetadata.id = forecast.forecastmetadata
  LEFT JOIN {{source('plantmonitordb','plant')}} ON plant.id = forecastmetadata.plant
)
select * from forecast_denormalized
