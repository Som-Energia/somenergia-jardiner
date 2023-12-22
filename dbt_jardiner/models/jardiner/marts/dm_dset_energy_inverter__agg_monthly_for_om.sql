{{ config(materialized='view') }}

with production_monthly as (
    select
        date_trunc('month', start_hour, 'Europe/Madrid') as month_date,
        plant_name,
        device_name,
        sum(inverter_energy_mwh) as inverter_energy_mwh
    from {{ ref("int_dset_energy_inverter__agg_hourly_for_om") }}
    group by date_trunc('month', start_hour, 'Europe/Madrid'), device_name, plant_name

), aliased as (
select
    month_date as mes,
    plant_name as nom_planta,
    device_name as aparell,
    inverter_energy_mwh as energia_inversor_mwh
from production_monthly)

select * from aliased

