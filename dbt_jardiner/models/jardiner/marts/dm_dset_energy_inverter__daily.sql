{{ config(materialized='view') }}

with inverter_energy_daily as (
    select
        date_trunc('day', ts, 'Europe/Madrid') as day,
        plant_uuid,
        plant_name,
        device_uuid,
        device_name,
        max(inverter_energy_kwh) as inverter_energy_kwh
    from {{ ref("dm_dset_energy_inverter__5m") }}
    group by date_trunc('day', ts, 'Europe/Madrid'), plant_uuid, plant_name, device_uuid, device_name
)
select * from inverter_energy_daily

