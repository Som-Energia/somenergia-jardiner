{{ config(materialized="table") }}

select *
from {{ ref("int_dset_responses__values_incremental") }}
where signal_last_ts > (current_date - interval '30 days')
