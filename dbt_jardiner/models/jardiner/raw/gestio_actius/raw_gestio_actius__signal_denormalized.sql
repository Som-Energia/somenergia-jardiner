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
    metric::text as metric_name,
    device_type::text,
    device_uuid::uuid,
    device_parent_uuid::uuid,
    signal_uuid::uuid,
    inserted_at::timestamptz,
    updated_at::timestamptz,
    trim(plant::text) as plant_name,
    trim(signal::text) as signal_name,
    trim(device::text) as device_name,
    trim(device_parent::text) as device_parent,
    coalesce(is_enabled = 'VERDADERO', false) as is_enabled
  from fresh
)

select * from base
where is_enabled
