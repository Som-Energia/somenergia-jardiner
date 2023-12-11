{{ config(materialized="incremental") }}

select *
from {{ ref("int_dset_responses__spined_metadata") }}

{#
    on the live data view.
    dset provides data late, so with a espina 5m we will always have one or several null batches
    We discard the last hour for the hourly downstream, which is refreshed daily anyway.
#}
where
    ts < now() - interval '1 hour'

    {% if is_incremental() %}
        and ts >= coalesce((select max(ts) from {{ this }}), '1900-01-01')
    {% endif %}
