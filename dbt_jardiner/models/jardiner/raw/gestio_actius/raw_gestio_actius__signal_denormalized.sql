{{ config(materialized='view') }}

WITH fresh AS (
  SELECT *
  FROM {{ ref("snapshot_signal_denormalized") }} sn
  WHERE sn.dbt_valid_to IS NULL
)
SELECT
  plant_uuid::uuid,
  plant::text,
  signal::text,
  metric::text,
  device::text,
  device_type::text,
  device_uuid::uuid,
  device_parent::text,
  signal_uuid::uuid,
  inserted_at::timestamptz,
  updated_at::timestamptz
FROM fresh
