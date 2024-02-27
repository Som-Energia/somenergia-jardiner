{{ config(materialized="view") }}

with meter_readings as (
  select
    group_name as dset_plant_name,
    signal_device_external_description as signal_device_type,
    signal_description,
    ts::timestamp at time zone signal_tz as ts,
    signal_value,
    group_id as dset_plant_id,
    group_code as dset_plant_code,
    signal_id as dset_signal_id,
    signal_code as dset_signal_code,
    signal_type,
    signal_frequency,
    signal_is_virtual::boolean as signal_is_virtual,
    signal_tz,
    signal_last_ts::timestamp at time zone signal_tz as signal_last_ts,
    signal_last_value,
    signal_unit,
    case
      when signal_external_id ~ e'^[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}$' then signal_external_id::uuid -- noqa: LT01
    end as signal_uuid,
    signal_external_id as signal_uuid_raw,
    signal_device_external_id as signal_device_uuid
  from {{ source("lake", "dset_meters_readings") }}
)
select * from meter_readings
