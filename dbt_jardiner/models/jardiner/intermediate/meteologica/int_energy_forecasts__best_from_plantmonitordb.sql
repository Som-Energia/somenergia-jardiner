{{
    config(
        materialized="view",
    )
}}

{# TODO check that this selects the previous day or the same day forecast #}
with
    forecasts_denormalized as (
        select *
        from {{ ref("raw_energy_forecasts__denormalized_from_plantmonitordb") }}
    )
select distinct
    on (plant_id, "time")
    fd.forecastdate,
    fd."time" - interval '1 hour' as start_hour,
    p.plant_uuid,
    fd.energy_kwh
from forecasts_denormalized fd
left join {{ ref("raw_plantmonitor_plants") }} p using (plant_id)
order by plant_id, "time" desc, forecastdate desc
