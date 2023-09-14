{{ config(materialized='view') }}

{# TODO left join with expected signals (we need those nulls!) #}


with spina5m as (
      select generate_series((now() at time zone 'Europe/Madrid')::date - interval '30 days', now(), '5 minutes') as ts
)
select
    spina5m.ts,
    plant as planta,
    device_uuid as uuid_aparell,
    device as aparell,
    device_type as tipus_aparell,
    signal as senyal,
    signal_unit as unitat_senyal,
    signal_value as valor
from spina5m
left join {{ ref("dset_responses_with_signal_metadata") }} as dset using(ts)
where device_type in ('inverter','sensor', 'string') or device_type is NULL
and ts > (now() at time zone 'Europe/Madrid')::date - interval '30 days'
order by ts desc, plant

