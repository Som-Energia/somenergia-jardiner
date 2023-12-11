{{ config(materialized="view") }}

with
    dset_materialized as (
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
            signal_unit,
            signal_uuid,
            signal_uuid_raw,
            signal_value
        from {{ ref("int_dset_responses__materialized_one_hour_late") }}
    ),
dset_current_hour_view as (
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
            signal_unit,
            signal_uuid,
            signal_uuid_raw,
            signal_value
        from {{ ref("int_dset_responses__view_current_hour") }}
    )
select *
from dset_materialized
union all
select *
from dset_current_hour_view
