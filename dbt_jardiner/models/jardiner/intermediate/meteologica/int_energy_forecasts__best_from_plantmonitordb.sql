{{
    config(
        materialized="view",
    )
}}

{# TODO check that this selects the previous day or the same day forecast #}

{#
    notice the inner join. We only consider plants in raw_plantmonitor_plants,
    thus discarding the SomRenovables plants
#}

with
forecasts_denormalized as (
  select
    forecasts.plant_id,
    forecasts.time,
    forecasts.forecastdate,
    plants.plant_uuid,
    forecasts.energy_kwh
  from {{ ref("raw_energy_forecasts__denormalized_from_plantmonitordb") }} as forecasts
    inner join {{ ref("raw_plantmonitor_plants") }} as plants using (plant_id)
)

select distinct
on (fd.plant_id, fd."time")
  fd.forecastdate,
  fd.plant_uuid,
  fd.energy_kwh,
  fd."time" - interval '1 hour' as start_hour
from forecasts_denormalized as fd
order by fd.plant_id asc, fd."time" desc, fd.forecastdate desc
