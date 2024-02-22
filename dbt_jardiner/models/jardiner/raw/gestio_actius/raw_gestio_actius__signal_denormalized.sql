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
    device_parent_uuid::uuid,
    signal_uuid::uuid,
    coalesce(is_enabled = 'VERDADERO', false) as is_enabled,
    inserted_at::timestamptz,
    updated_at::timestamptz
  from fresh
)

select * from base
where is_enabled
