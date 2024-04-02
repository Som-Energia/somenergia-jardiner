{{ config(
    materialized = 'view'
) }}

with forecast_denormalized as (

  select
    forecast.time as "time",
    forecastmetadata.plant as plant_id,
    forecastmetadata.forecastdate as forecastdate,
    round(
      forecast.percentil50 / 1000.0,
      2
    ) as energy_kwh
  from {{ source('meteologica', 'forecast') }} as forecast
    left join {{ source('meteologica', 'forecastmetadata') }} as forecastmetadata
      on forecastmetadata.id = forecast.forecastmetadata
)

select *
from
  forecast_denormalized
