{{ config(materialized="view") }}

with
    inverter_energy_daily_metrics as (
        select
            date_trunc('day', ts, 'Europe/Madrid') as day,
            plant_uuid,
            plant_name,
            device_uuid,
            device_name,
            metric_name,
            max(inverter_energy_kwh) as max_inverter_energy_kwh,
            min(inverter_energy_kwh) as min_inverter_energy_kwh,
            max(inverter_energy_kwh) - min(inverter_energy_kwh) as diff_inverter_energy_kwh,
            max(inverter_energy_kwh) - min(nullif(inverter_energy_kwh, 0)) as diff_nozero_inverter_energy_kwh
        from {{ ref("dm_dset_energy_inverter__5m") }}
        where
            metric_name = 'energia_activa_exportada'
            {# filter to discard previous day data which gets reset early morning #}
            and extract(hour from ts at time zone 'Europe/Madrid') > 3
        group by
            date_trunc('day', ts, 'Europe/Madrid'),
            plant_uuid,
            plant_name,
            device_uuid,
            device_name,
            metric_name
    ),
    inverter_energy_daily as (
        select *, diff_inverter_energy_kwh as inverter_energy_kwh
        from inverter_energy_daily_metrics
        order by day desc, plant_name, device_name
    )
select *
from inverter_energy_daily
