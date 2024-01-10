{{ config(materialized='view') }}

with inverters_energy as (
    select
        ts,
        plant_uuid,
        plant_name,
        device_uuid,
        device_name,
        metric_name,
        signal_unit,
        case
            when signal_unit = 'MWh' then signal_value*1000
            when signal_unit = 'kWh' then signal_value
            else NULL
        end as inverter_energy_kwh
    from {{ ref('int_dset_responses__values_incremental') }}
    where device_type in ('inverter') and metric_name = 'energia_activa_exportada'
    {# filter to discard previous day data which gets reset early morning #}
    and extract(hour from ts at time zone 'Europe/Madrid') > 3
)
select * from inverters_energy
order by ts
