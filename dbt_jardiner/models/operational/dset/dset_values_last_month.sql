{{ config(materialized='table') }}

select *
from {{ ref('dset_responses_with_signal_metadata') }}
where signal_last_ts > (current_date - interval '30 days')