{{ config(materialize="view") }}

with
    ordered as (
        select *, row_number() over (partition by ts, signal_id order by queried_at desc) as row_order
        from {{ ref("raw_dset_responses__api_response") }}
    )
select {{ dbt_utils.star(from=ref("raw_dset_responses__api_response")) }}
from ordered
where row_order = 1
