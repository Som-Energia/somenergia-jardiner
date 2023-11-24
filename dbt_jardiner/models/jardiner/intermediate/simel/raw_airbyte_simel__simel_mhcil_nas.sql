with
    source as (
      select * from {{ source("airbyte_simel", "simel_mhcil_nas") }}
),
renamed as (
	select
		{{ adapter.quote("cil") }}::text,
		{{ adapter.quote("year") }}::integer,
		{{ adapter.quote("month") }}::integer,
		{{ adapter.quote("day") }}::integer,
		{{ adapter.quote("hour") }}::integer,
		{{ adapter.quote("is_summer") }}::boolean,
		nullif( {{ adapter.quote("energy_kwh") }}, '')::numeric as {{ adapter.quote("energy_kwh") }},
		nullif( {{ adapter.quote("reactive_energy_2_kvarh") }}, '')::numeric as {{ adapter.quote("reactive_energy_2_kvarh") }},
		nullif( {{ adapter.quote("reactive_energy_3_kvarh") }}, '')::numeric as {{ adapter.quote("reactive_energy_3_kvarh") }},
		{{ adapter.quote("measurement_type") }}::text,
		{{ adapter.quote("empty_col") }}::text,
		{{ adapter.quote("_ab_source_file_last_modified") }},
		{{ adapter.quote("_ab_source_file_url") }},
		{{ adapter.quote("_airbyte_ab_id") }},
		{{ adapter.quote("_airbyte_emitted_at") }},
		{{ adapter.quote("_airbyte_normalized_at") }},
		{{ adapter.quote("_airbyte_simel_mhcil_nas_hashid") }}
	from source
)
select * from renamed
