{{ config(materialized='view') }}

SELECT
 plant,
 signal,
 metric,
 device,
 device_type,
 device_uuid,
 device_parent,
 signal_uuid
FROM {{ ref('signal_device_relation') }}