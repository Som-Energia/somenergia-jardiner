{{ config(materialized="table") }}

select *
from {{ ref("int_dset_responses__spined_metadata") }}
where signal_last_ts > (current_date - interval '30 days')
