{{ config(materialized='view') }}


select
  plantmonitor_plant.plant_uuid,
  solarevent.day,
  solarevent.sunrise_real,
  solarevent.sunset_real,
  solarevent.sunrise_generous,
  solarevent.sunset_generous,
  solarevent.solar_hours_real,
  solarevent.solar_hours_minimum
from {{ ref("raw_plantmonitordb_solarevent__generous") }} as solarevent
left join {{ ref("raw_plantmonitor_plants") }} as plantmonitor_plant using(plant_id)
