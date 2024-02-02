{{ config(materialized="view") }}

select
    ts,
    signal_value as valor,
    plant_name as nom_planta,
    device_uuid as uuid_aparell,
    device_name as aparell,
    device_type as tipus_aparell,
    signal_unit as unitat_senyal,
    metric_name as nom_metrica,
    signal_name as senyal,
    device_parent as nom_aparell_pare
from {{ ref("int_dset_responses__spined_metadata") }}
where
    device_type in ('inverter', 'sensor', 'string')
    and ts > (now() at time zone 'Europe/Madrid')::date - interval '30 days'
order by ts desc, plant_name asc
