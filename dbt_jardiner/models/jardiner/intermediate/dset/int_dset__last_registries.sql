{{ config(materialized='view') }}


with ts_last_registry as (
    SELECT signal_uuid, plant, max(ts) as ultim_registre
    from {{ ref('int_dset_responses__last_month')}}
    group by plant, signal_uuid
)
SELECT m.*
from ts_last_registry tslr
left join {{ ref('int_dset_responses__last_month') }} m
    on m.signal_uuid = tslr.signal_uuid and m.ts = tslr.ultim_registre
