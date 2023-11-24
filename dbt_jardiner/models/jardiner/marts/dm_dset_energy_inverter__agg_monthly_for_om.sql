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
        (extract(hour from start_hour) > 3)::integer * (max(signal_value) - min(signal_value)) as inverter_energy
    from inverters_energy
    group by start_hour, plant_name, device_name, metric_name, signal_unit
), signal_unit_standardization as (
    select
        start_hour,
        plant_name,
        device_name,
        signal_unit,
        case
            when signal_unit = 'MWh' then round(inverter_energy,3)
            when signal_unit = 'kWh' then round(inverter_energy/1000,3)
            else NULL
        end as inverter_energy_mwh
    from production_hourly
), production_monthly as (
    select
        date_trunc('month', start_hour, 'Europe/Madrid') as month_date,
        plant_name,
        device_name,
        sum(inverter_energy_mwh) as inverter_energy_mwh
    from signal_unit_standardization
    group by date_trunc('month', start_hour, 'Europe/Madrid'), device_name, plant_name

)
select
    month_date as mes,
    plant_name as nom_planta,
    device_name as aparell,
    inverter_energy_MWh as energia_inversor_mwh
from production_monthly
