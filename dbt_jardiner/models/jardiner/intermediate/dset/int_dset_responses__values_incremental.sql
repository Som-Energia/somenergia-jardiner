{{
    config(
        materialized="incremental",
        on_schema_change="sync_all_columns",
        incremental_strategy = 'delete+insert',
        unique_key = ['ts', 'signal_uuid'],
        incremental_predicates = ["int_dset_responses__values_incremental.ts > now() - interval '2 days'"],
		post_hook=[
			"SELECT create_hypertable(
				relation => '{{ this }}',
				migrate_data => true,
				time_column_name => 'ts',
				chunk_time_interval => interval '30 days',
				if_not_exists => true
			)",
			"CREATE INDEX IF NOT EXISTS idx_int_dset_responses__values_incremental_device_type__ts ON {{ this }} (ts DESC, device_type)",
			"CREATE INDEX IF NOT EXISTS idx_int_dset_responses__values_incremental_metric_name__ts ON {{ this }} (ts DESC, metric_name)",
			]
    )
}}

select *
from {{ ref("int_dset_responses__spined_metadata") }}
{#
    on the live data view.
    dset provides data late, so with a espina 5m we will always have one or several null batches
    We discard the last hour for the hourly downstream, which is refreshed daily anyway.
#}
-- noqa: disable=LT02
{% if is_incremental() -%}
where
    materialized_at
    > coalesce((select max(materialized_at) from {{ this }}), '1900-01-01')
  and ts > now() - interval '2 days'
        {#
            dedupliquem 2 dies enrera (ho diu el predicate) i per això no podem garantir que tot l'anterior sigui unic
            i per tant ho descartem aqui, en la selecció del incremental
            Si per algun motiu deixem de materialitzar durant 48 hores, caldrà fer un full-refresh!
        #}
{%- endif %}
-- noqa: enable=all
