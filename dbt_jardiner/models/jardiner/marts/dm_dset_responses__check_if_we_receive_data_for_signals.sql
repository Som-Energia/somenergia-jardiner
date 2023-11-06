{{ config(materialized="view") }}

with
    valors as (
        select true as rebut_from_dset, signal_uuid
        from {{ ref("raw_dset_responses__api_response") }}
        where ts = (select max(ts) from {{ ref("raw_dset_responses__api_response") }})
    )
select
    signals.plant,
    signals.signal,
    signals.signal_uuid,
    signals.device,
    signals.device_type,
    signals.device_uuid,
    coalesce(rebut_from_dset, false) as rebut_from_dset
from {{ ref("seed_signals__with_devices") }} as signals
left join valors on signals.signal_uuid = valors.signal_uuid
order by plant, signal
