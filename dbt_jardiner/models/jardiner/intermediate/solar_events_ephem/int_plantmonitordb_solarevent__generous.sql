{{ config(materialized='view') }}


select
  plant_uuid,
  day,
  sunrise_real,
  sunset_real,
  sunrise_generous,
  sunset_generous,
  solar_hours_real,
  solar_hours_minimum
from {{ ref("raw_plantmonitordb_solarevent__generous") }}
left join {{ ref("raw_plantmonitor_plants") }} using(plant_id)