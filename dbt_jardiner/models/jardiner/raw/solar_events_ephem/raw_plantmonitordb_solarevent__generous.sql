{{ config(materialized='view') }}


select
  plant as plant_id,
  sunrise as sunrise_real,
  sunset as sunset_real,
  date_trunc('day', sunrise) as day,
  sunrise + interval '2 hours' as sunrise_generous,
  sunset - interval '2 hours' as sunset_generous,
  round(
    extract(epoch from (sunset - sunrise))::numeric / 3600, 2
  ) as solar_hours_real,
  round(
    extract(
      epoch from (sunset - interval '2 hours')
      - (sunrise + interval '2 hours')
    )::numeric
    / 3600,
    2
  ) as solar_hours_minimum
from {{ source('plantmonitor_jardiner', 'solarevent') }}
