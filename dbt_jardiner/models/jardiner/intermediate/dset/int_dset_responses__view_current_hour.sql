{{ config(materialized="view") }}


with
    latest as (
      select max(ts) as max_ts
      from {{ ref("int_dset_responses__materialized") }}
    ),

    normalized_jsonb as (
        select
            group_name,
            queried_at,
            ts,
            signal_code,
            signal_device_type,
            signal_device_uuid,
            signal_frequency,
            signal_id,
            signal_is_virtual,
            signal_last_ts,
            signal_last_value,
            signal_type,
            signal_tz,
            signal_uuid_raw,
            signal_unit,
            signal_value,
            signal_uuid
        from {{ ref("int_dset_responses__deduplicated") }}
        where ts > (select max_ts from latest) and queried_at > (select max_ts from latest)
    ),

    ordered as (
        select *, row_number() over (partition by ts, signal_id order by queried_at desc) as row_order
        from normalized_jsonb
    )

select *
from ordered
where row_order = 1
