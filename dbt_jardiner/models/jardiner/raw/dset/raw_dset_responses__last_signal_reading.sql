{{ config(materialized="view") }}

with
last_dset_response as (
  select * from lake.dset_responses
  order by query_time desc
  limit 1
),

unnest_groups as (
  select
      query_time as queried_at,
      (jsonb_array_elements(response) ->> 'signals')::jsonb as signals,
      jsonb_array_elements(response) ->> 'group_name' as group_name
  from last_dset_response
),

filter_dummy_group as (
    select * from unnest_groups where group_name != 'SOMENERGIA'
  ),

unnested_dset_response as (
    select
      group_name,
      queried_at,
      jsonb_array_elements(signals) as signals
    from filter_dummy_group
)
select
	group_name,
	queried_at,
	(signals ->> 'signal_id')::integer as signal_id,
	(signals ->> 'signal_code')::text as signal_code,
	(signals ->> 'signal_type')::text as signal_type,
	(signals ->> 'signal_unit')::text as signal_unit,
	(signals ->> 'signal_last_ts')::timestamp at time zone (signals ->> 'signal_tz')::text as signal_last_ts,
	(signals ->> 'signal_tz')::text as signal_tz,
	(signals ->> 'signal_frequency')::text as signal_frequency,
	(signals ->> 'signal_is_virtual')::text as signal_is_virtual,
	(signals ->> 'signal_last_value')::numeric as signal_last_value,
	(signals ->> 'signal_description')::text as signal_description,
	(signals ->> 'signal_device_external_id')::text as signal_device_uuid,
	(signals ->> 'signal_device_external_description')::text as signal_device_type,
	(signals ->> 'signal_external_id')::text as signal_uuid
from unnested_dset_response
