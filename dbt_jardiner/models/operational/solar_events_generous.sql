{{ config(materialized='view') }}

select
  plant,
  sunrise as sunrise_real,
  sunset as sunset_real,
  date_trunc('day', sunrise) as day,
  EXTRACT(EPOCH FROM (sunset - sunrise))/3600 as solar_hours_real,
  EXTRACT(
	  EPOCH FROM (sunset - interval '2 hours') - (sunrise + interval '2 hours')
  )/3600 solar_hours_minimum
from {{source('plantmonitor', 'solarevent')}}