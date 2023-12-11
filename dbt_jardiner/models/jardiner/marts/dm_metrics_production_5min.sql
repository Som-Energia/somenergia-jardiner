{{ config(materialized='view') }}

{# TODO left join with expected signals (we need those nulls!) #}


select
    ts,
    plant_name as nom_planta,
    device_uuid as uuid_aparell,
    device_name as aparell,
    device_type as tipus_aparell,
    signal_name as senyal,
    signal_unit as unitat_senyal,
    signal_value as valor
from {{ ref("int_dset_responses__spined_metadata") }}
where device_type in ('inverter','sensor', 'string')
and ts > (now() at time zone 'Europe/Madrid')::date - interval '30 days'
order by ts desc, plant_name

