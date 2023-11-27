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
        select *
        from {{ ref("raw_energy_forecasts__denormalized_from_plantmonitordb") }}
        inner join {{ ref("raw_plantmonitor_plants") }} p using (plant_id)
    )
select distinct
    on (plant_id, "time")
    fd.forecastdate,
    fd."time" - interval '1 hour' as start_hour,
    plant_uuid,
    fd.energy_kwh
from forecasts_denormalized fd
order by plant_id, "time" desc, forecastdate desc
