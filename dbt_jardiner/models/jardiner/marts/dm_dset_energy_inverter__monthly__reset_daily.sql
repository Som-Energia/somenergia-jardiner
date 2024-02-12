{{ config(materialized="view") }}

with
    inverter_energy_monthly as (
        select
            date_trunc('month', day, 'Europe/Madrid') as month_date,
            plant_name,
            device_name,
            coalesce(sum(inverter_total_energy_kwh), sum(inverter_export_energy_kwh))/1000 as inverter_energy_mwh
        from {{ ref("int_dset_energy_inverter__daily__reset_daily") }}
        group by
            date_trunc('month', day, 'Europe/Madrid'),
            plant_name,
            device_name
    )
    select
        month_date as mes,
        plant_name as nom_planta,
        device_name as aparell,
        inverter_energy_mwh as energia_inversor_mwh
    from inverter_energy_monthly
    where month_date > '2023-12-01'
    order by month_date desc, plant_name, device_name
