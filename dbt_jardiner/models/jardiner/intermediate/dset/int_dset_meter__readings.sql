{{ config(materialized="view") }}

with quarterhourly_spine as (
  select generate_series('2023-12-01', now(), '15 minutes') as start_ts
),

meter_metadata as (
  select
    metadata.plant_uuid::uuid,
    metadata.plant_name,
    metadata.signal_name,
    metadata.metric_name,
    metadata.device_name,
    metadata.device_type,
    metadata.device_uuid,
    metadata.device_parent,
    metadata.device_parent_uuid,
    metadata.signal_uuid,
    metadata.is_enabled
  from {{ ref("raw_gestio_actius__signal_denormalized") }} as metadata
  where
    metadata.device_type = 'meter'
    and metadata.is_enabled
    and metadata.metric_name ilike 'energia_%'
),

raw_meter_readings as (
  select
    meter_readings.start_ts,
    meter_readings.end_ts,
    meter_readings.signal_value,
    meter_readings.signal_uuid,
    meter_readings.signal_unit,
    null as queried_at
  from {{ ref("raw_dset_meter__readings") }} as meter_readings
  where meter_readings.signal_uuid is not null
),

meter_readings_with_metadata as (
  select
    meter_metadata.*,
    quarterhourly_spine.start_ts,
    raw_meter_readings.end_ts,
    raw_meter_readings.signal_value,
    raw_meter_readings.signal_unit,
    raw_meter_readings.queried_at,
    now() as materialized_at
  from quarterhourly_spine
    left join meter_metadata on true
    left join raw_meter_readings using (signal_uuid, start_ts)
)

select * from meter_readings_with_metadata
