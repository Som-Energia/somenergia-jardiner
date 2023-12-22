{{ config(materialize="view") }}

with
    ordered as (
        select *, row_number() over (partition by ts, signal_uuid order by queried_at desc) as row_order
        from {{ ref("int_dset_responses__validate_uuids") }}
    )
select {{ dbt_utils.star(from=ref("int_dset_responses__validate_uuids")) }}
from ordered
where row_order = 1
