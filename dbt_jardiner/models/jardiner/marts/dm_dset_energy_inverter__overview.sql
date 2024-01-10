{{ config(materialized='view') }}

with inverters_energy as (
    select
        ts,
        plant_uuid,
        plant_name,
        device_name,
        metric_name,
        signal_unit,
        case
            when signal_unit = 'MWh' then round(signal_value,3)
            when signal_unit = 'kWh' then round(signal_value/1000,3)
            else NULL
        end as inverter_energy_mwh
    from {{ ref('int_dset_responses__values_incremental') }}
    where device_type in ('inverter') and metric_name = 'energia_activa_exportada'
    {# filter to discard previous day data which gets reset early morning #}
    and extract(hour from ts at time zone 'Europe/Madrid') > 3
), production_sum_plant as (
    select
        ts,
        plant_uuid,
        plant_name,
        sum(inverter_energy_mwh) as inverters_energy_mwh
    from inverters_energy
    group by ts, plant_uuid, plant_name
){#, production_agg as (
    select
        date_trunc('hour', ts) as start_hour,
        plant_uuid,
        plant_name,
        max(invertter_energy_mwh)
    from production_hourly
)#}
select * from production_sum_plant

