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
          plant::text as plant_name,
          signal::text as signal_name,
          metric::text as metric_name,
          device::text as device_name,
          device_type::text,
          device_uuid::uuid,
          device_parent::text,
          signal_uuid::uuid,
          inserted_at::timestamptz,
          updated_at::timestamptz
        from fresh
    )

select * from base
