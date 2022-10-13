{{ config(materialized='view') }}

select
  plant,
  sunrise as sunrise_real,
  sunset as sunset_real,
  date_trunc('1 day', sunrise) as day,
  (sunset - interval '2 hours') - (sunrise + interval '2 hours') as solar_hours
from {{source('plantmonitor', 'solarevent')}}