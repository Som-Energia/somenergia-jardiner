{{ config(materialized='view') }}

with unnest_groups as (
	SELECT
		query_time as queried_at,
		jsonb_array_elements(response)->>'group_name' as group_name,
		jsonb_array_elements(response) as response
	FROM {{ source('lake', 'dset_responses') }}
), filter_dummy_group as (
	SELECT *
	FROM unnest_groups
	WHERE group_name != 'SOMENERGIA'
),
unnested_dset_response as (
	SELECT
		group_name,
		queried_at,
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
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_description')::text as signal_description,
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_device_external_id')::text as signal_device_uuid,
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_device_external_description')::text as signal_device_type,
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_external_id')::text as signal_uuid,
		(jsonb_array_elements(jsonb_array_elements((response)::jsonb#>'{signals}')#>'{data}')->>'ts')::timestamp at time zone
		(jsonb_array_elements((response)::jsonb#>'{signals}')->>'signal_tz')::text as ts,
		(jsonb_array_elements(jsonb_array_elements((response)::jsonb#>'{signals}')#>'{data}')->>'value')::numeric as signal_value
	FROM filter_dummy_group
),
filtered_signal_uuid_nulls as (
	select * from unnested_dset_response udr
	where udr.signal_uuid is not null and udr.signal_uuid != ''
)
select
	queried_at,
	ts,
	group_name,
	signal_value,
	case when signal_uuid ~ E'^[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}$' then
		signal_uuid::uuid
	else NULL
	end
		as signal_uuid,
	signal_id,
	signal_tz,
	signal_code,
	signal_type,
	signal_unit,
	signal_last_ts,
	signal_frequency,
	signal_is_virtual,
	signal_last_value,
	signal_device_type,
	signal_device_uuid,
	signal_uuid as signal_uuid_raw
from filtered_signal_uuid_nulls
order by ts desc
