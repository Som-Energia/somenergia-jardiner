{{ config(materialized='view') }}


select
  plant as plant_id,
  date_trunc('day', sunrise) as day,
  sunrise as sunrise_real,
  sunset as sunset_real,
  sunrise + interval '2 hours' as sunrise_generous,
  sunset - interval '2 hours' as sunset_generous,
  round(EXTRACT(EPOCH FROM (sunset - sunrise))::numeric/3600,2) as solar_hours_real,
  round(EXTRACT(EPOCH FROM (sunset - interval '2 hours') - (sunrise + interval '2 hours'))::numeric/3600,2) as solar_hours_minimum
from {{source('plantmonitor', 'solarevent')}}