{{ config(materialized='view') }}

{#select   {{ dbt_utils.star(from=ref('raw_dset_responses__api_response'), except=['signal_uuid'] }}#}

{# TODO one metric could have different units, we could standardize here
e.g. signal_value * (case when signal_unit = 'kwh' then 1000 else 1)#}

SELECT
    metadata.plant,
    metadata.signal,
    metadata.metric,
    metadata.device,
    metadata.device_type,
    metadata.device_uuid,
    metadata.device_parent,
    metadata.signal_uuid,
    valors.group_name,
    valors.signal_id,
    valors.signal_tz,
    valors.signal_code,
    valors.signal_type,
    valors.signal_unit,
    valors.signal_last_ts,
    valors.signal_frequency,
    valors.signal_is_virtual,
    valors.signal_last_value,
    valors.ts,
    valors.signal_value as signal_value
FROM {{ ref('seed_signals__with_devices') }} AS metadata
LEFT JOIN {{ ref('raw_dset_responses__api_response') }} AS valors USING(signal_uuid)