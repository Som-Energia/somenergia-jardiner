{{ config(materialized='view') }}

with inverters_energy as (
    select
        date_trunc('hour', ts) as start_hour,
        plant_name,
        device_name,
        metric_name,
        signal_unit,
        signal_value
    from {{ ref('int_dset_responses__values_incremental') }}
    where device_type in ('inverter') and metric_name = 'energia_activa_exportada'
), production_hourly as (
    select
        start_hour,
        plant_name,
        device_name,
        signal_unit,
        max(signal_value) as max_abs_inverter_energy,
        min(signal_value) as min_abs_inverter_energy,
        (extract(hour from start_hour) > 3)::integer * (max(signal_value) - min(signal_value)) as inverter_energy
    from inverters_energy
    group by start_hour, plant_name, device_name, metric_name, signal_unit
), signal_unit_standardization as (
    select
        start_hour,
        plant_name,
        device_name,
        case
            when signal_unit = 'MWh' then round(inverter_energy,3)
            when signal_unit = 'kWh' then round(inverter_energy/1000,3)
            else NULL
        end as inverter_energy_mwh,
        max_abs_inverter_energy,
        min_abs_inverter_energy
    from production_hourly
)
select * from signal_unit_standardization

