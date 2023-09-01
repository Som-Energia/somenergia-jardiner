{{ config(materialized='view') }}

{#select   {{ dbt_utils.star(from=ref('dset_responses_raw'), except=['signal_uuid'] }}#}

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
FROM {{ ref('signal_device_relation_raw') }} AS metadata
LEFT JOIN {{ ref('dset_responses_raw') }} AS valors USING(signal_uuid)