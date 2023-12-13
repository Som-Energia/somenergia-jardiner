{{ config(enabled=true, severity='warn', warn_if = '>0') }}

SELECT DISTINCT ON (plant_name, device_name, signal_uuid)
	*
FROM {{ ref('int_dset_responses__with_signal_metadata') }}
WHERE signal_value BETWEEN 65500 AND 65599
ORDER BY plant_name, device_name, signal_uuid, ts DESC
