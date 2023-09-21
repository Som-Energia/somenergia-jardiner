{{ config(
    materialized = 'table'
) }}

SELECT DISTINCT
	plant,
    device,
    device_uuid,
    device_type,
    device_parent
FROM
    {{ ref('seed_signals__with_devices') }}
ORDER BY
    plant,
    device
