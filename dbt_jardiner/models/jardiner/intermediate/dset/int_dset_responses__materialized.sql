{{
    config(
        materialized="incremental",
        on_schema_change="sync_all_columns",
        incremental_strategy = 'delete+insert',
        unique_key = ['ts', 'signal_uuid'],
        incremental_predicates = ["int_dset_responses__materialized.ts > now() - interval '2 days'"]
    )
}}


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
            signal_value,
            now() as materialized_at
        from {{ ref("int_dset_responses__deduplicated") }}
    )

select *
from normalized_jsonb
{% if is_incremental() -%}
where queried_at > coalesce((select max(queried_at) from {{ this }}), '1900-01-01')
  and ts > now() - interval '2 days'
  -- dedupliquem 2 dies enrera (ho diu el predicate) i per això no podem garantir que tot l'anterior sigui unic
  -- i per tant ho descartem aqui, en la selecció del incremental
  -- Si per algun motiu deixem de materialitzar durant 48 hores, caldrà fer un full-refresh!
{%- endif %}
