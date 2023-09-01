{{ config(materialized='view') }}

{# TODO check that this selects the previous day or the same day forecast #}

with forecasts_denormalized as (
  select * from {{ref('forecasts_denormalized')}}
)
select distinct on(plant_id, "time")
  forecastdate,
  "time" - INTERVAL '1 hour' as start_hour,
  plant_id,
  plant_name as plant,
  energy_kwh
from forecasts_denormalized fd
order by plant_id, "time" desc, forecastdate desc