{{ config(
    materialized = 'view'
) }}

select
  *,
  date_trunc(
    'hour',
    "time"
  ) as time_start_hour
from
  (
    select
      *,
      row_number() over (
        partition by plant_id, date_trunc('hour', "time")
        order by
          forecastdate desc
      ) as ranking
    from
      {{ ref('energy_forecasts__denormalized_from_plantmonitordb') }}
  ) as forecast
where
  ranking = 1
