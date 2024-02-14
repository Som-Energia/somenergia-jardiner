{{ config(materialized='view') }}


with ts_last_registry as (
    select signal_uuid, plant_uuid, max(ts) as ultim_registre
    from {{ ref('int_dset_responses__values_incremental') }}
    group by plant_uuid, signal_uuid
)
select m.*
from ts_last_registry as tslr
left join {{ ref('int_dset_responses__values_incremental') }} as m
    on tslr.signal_uuid = m.signal_uuid and tslr.ultim_registre = m.ts
