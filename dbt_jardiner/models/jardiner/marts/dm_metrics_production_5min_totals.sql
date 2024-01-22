{{ config(materialized="view") }}

with dset_with_meta_and_totals as (
    select
        ts,
        sum(signal_value) as valor,
        plant_name as nom_planta,
        device_uuid as uuid_aparell,
        coalesce(device_name, device_type || '_total') as aparell,
        device_type as tipus_aparell,
        signal_unit as unitat_senyal,
        metric_name as nom_metrica,
        signal_name as senyal,
        device_parent as nom_aparell_pare
    from {{ ref("int_dset_responses__spined_metadata") }}
    where
    device_type in ('inverter', 'sensor', 'string')
    and ts > (now() at time zone 'Europe/Madrid')::date - interval '30 days'
    group by ts,
        plant_name,
        device_type,
        signal_unit,
        device_parent,
        metric_name,
        grouping sets ((device_uuid, device_name, signal_name),())
    order by ts desc, nom_planta
)
select * from dset_with_meta_and_totals