{{ config(materialized="view") }}

with
fresh as (
  select *
  from {{ ref("snapshot_signal_denormalized") }}
  where dbt_valid_to is null
),

base as (
  select
    plant_uuid::uuid,
    trim(plant::text) as plant_name,
    trim(signal::text) as signal_name,
    metric::text as metric_name,
    trim(device::text) as device_name,
    device_type::text,
    device_uuid::uuid,
    trim(device_parent::text) as device_parent,
    signal_uuid::uuid,
    inserted_at::timestamptz,
    updated_at::timestamptz
  from fresh
)

select * from base
