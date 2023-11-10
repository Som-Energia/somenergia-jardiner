{{ config(materialize="view") }}

with
    ordered as (
        select row_number() over (partition by rdrar.ts, rdrar.signal_id order by rdrar.queried_at desc) as row_order, *
        from {{ ref("raw_dset_responses__api_response") }} rdrar
    )
select {{ dbt_utils.star(from=ref("raw_dset_responses__api_response")) }}
from ordered o
where o.row_order = 1
