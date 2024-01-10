{{ config(materialized="view") }}

with
    inverters_energy as (
        select
            ts,
            plant_uuid,
            plant_name,
            metric_name,
            signal_uuid,
            sum(inverter_energy_kwh) as inverter_energy_kwh
        from {{ ref("int_dset_energy_inverter__5m") }}
        group by ts, plant_uuid, plant_name, metric_name, signal_uuid
    )
select *
from inverters_energy
order by ts desc
