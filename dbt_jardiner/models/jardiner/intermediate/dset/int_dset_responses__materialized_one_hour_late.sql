{{ config(materialized="incremental") }}

with
    normalized_jsonb as (

        select
            group_name,
            queried_at,
            ts,
            signal_code,
            signal_device_type,
            signal_device_uuid,
            signal_frequency,
            signal_id,
            signal_is_virtual,
            signal_last_ts,
            signal_last_value,
            signal_type,
            signal_tz,
            signal_unit,
            signal_uuid,
            signal_uuid_raw,
            signal_value
        from {{ ref("int_dset_responses__deduplicated") }}
    )

select *
from normalized_jsonb
where
    ts < now() - interval '1 hour'  {#- select only freshly ingested rows #}

    {% if is_incremental() -%}
        and ts > coalesce((select max(ts) from {{ this }}), '1900-01-01') and queried_at > now() - interval '2 hour'
    {%- endif %}
