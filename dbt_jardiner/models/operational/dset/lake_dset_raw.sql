{{ config(materialized='view') }}

SELECT
    params,
	endpoint,
	group_id,
	is_valid,
	signal_id,
	group_code,
	group_name,
	query_time,
	signal_code,
	signal_type,
	signal_unit,
	signal_last_ts,
	signal_frequency,
	signal_is_virtual,
	signal_last_value,
	signal_description
FROM {{ source('lake', 'dset_readings') }}

