{{ config(materialized="view") }}

with
    inverters_energy as (
        select
            ts,
            plant_uuid,
            plant_name,
            device_uuid,
            device_name,
            metric_name,
            signal_uuid,
            case
                when signal_unit = 'MWh' then signal_value * 1000
                when signal_unit = 'kWh' then signal_value
                else null
            end as inverter_energy_kwh
        from {{ ref("int_dset_responses__values_incremental") }}
        where
            device_type in ('inverter')
            and metric_name
            in ('energia_activa_exportada', 'energia_activa_exportada_total')
    )
select *
from inverters_energy
order by ts desc
