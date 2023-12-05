{{ config(materialized="view") }}

with
    filtered_signal_uuid_nulls as (
        select *
        from {{ ref("raw_dset_responses__api_response") }}
        where signal_uuid is not null and signal_uuid != ''
    ),

    transformed as (
        select
            queried_at,
            ts,
            group_name,
            signal_value,
            signal_id,
            signal_tz,
            signal_code,
            signal_type,
            signal_unit,
            signal_last_ts,
            signal_frequency,
            signal_is_virtual,
            signal_last_value,
            signal_device_type,
            signal_device_uuid,
            signal_uuid as signal_uuid_raw,
            case
              when signal_uuid ~ e'^[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}$' then signal_uuid::uuid
            end as signal_uuid
        from filtered_signal_uuid_nulls
        order by ts desc
    )

select * from transformed
