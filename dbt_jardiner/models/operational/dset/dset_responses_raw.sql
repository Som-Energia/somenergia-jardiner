{{ config(materialized='view') }}

with unnest_groups as (
	SELECT
		jsonb_array_elements(response)->>'group_name' as group_name,
		jsonb_array_elements(response) as response
	FROM {{ source('lake', 'dset_responses') }}
), filter_dummy_group as (
	SELECT *
	FROM unnest_groups
	WHERE group_name != 'SOMENERGIA'
)
SELECT
	group_name,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_id')::text as signal_id,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_tz')::text as signal_tz,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_code')::text as signal_code,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_type')::text as signal_type,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_unit')::text as signal_unit,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_last_ts')::timestamp at time zone
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_tz')::text as signal_last_ts,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_frequency')::text as signal_frequency,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_is_virtual')::text as signal_is_virtual,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_last_value')::numeric as signal_last_value,
	(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_description')::uuid as signal_uuid,
	(jsonb_array_elements(jsonb_array_elements((response)::jsonb#>'{signals}')#>'{data}')->>'ts')::timestamp at time zone
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_tz')::text as ts,
	(jsonb_array_elements(jsonb_array_elements((response)::jsonb#>'{signals}')#>'{data}')->>'value')::numeric as signal_value
FROM filter_dummy_group