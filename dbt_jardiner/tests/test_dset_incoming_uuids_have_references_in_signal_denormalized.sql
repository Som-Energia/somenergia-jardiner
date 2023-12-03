{{ config(severity="warn", store_failures=true) }}

with
    child as (
        select *, signal_uuid as signal_uuid_from_field
        from {{ ref("int_dset_responses__union_view_and_materialized") }}
        where signal_uuid is not null
    ),

    parent as (
      select signal_uuid as signal_uuid_to_field
      from {{ ref("raw_gestio_actius__signal_denormalized") }}
    )

select *
from child
left join parent on child.signal_uuid_from_field = parent.signal_uuid_to_field
where parent.signal_uuid_to_field is null
