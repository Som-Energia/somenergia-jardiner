{{ config(materialized="view") }}


with timestamp_crafted as (
  select
    *,
    make_timestamp(
      cast("year" as int), cast("month" as int), cast("day" as int), cast("hour" as int), 0, 0
    ) as measurement_timestamp
  from {{ ref("raw_airbyte_simel__mhcil_pen") }}
),

timestamp_localized as (
  select
    *,
    case
      when is_summer
        then measurement_timestamp at time zone 'CEST'
      else measurement_timestamp at time zone 'CET'
    end as measurement_timestamptz
  from timestamp_crafted
),

extended_mhcil as (
  select
    cil,
    measurement_timestamptz as start_at,
    hour,
    is_summer,
    energy_kwh,
    reactive_energy_2_kvarh,
    reactive_energy_3_kvarh,
    measurement_type,
    _ab_source_file_url as file_name,
    _airbyte_normalized_at as ingested_at,
    cast(_ab_source_file_last_modified as timestamptz) as file_last_modified_at,
    cast(split_part(_ab_source_file_url, '.', 2) as int) as file_version,
    cast(split_part(_ab_source_file_url, '_', 1) as varchar(5)) as file_type,  -- fecha a la que corresponden los datos
    cast(split_part(_ab_source_file_url, '_', 2) as varchar(2)) as release_period,  -- tipo de fichero según simel
    cast(split_part(_ab_source_file_url, '_', 3) as varchar(4)) as member_code,  -- periodo de publicación
    cast(split_part(_ab_source_file_url, '_', 4) as varchar(2)) as file_receiver_type,  -- código de participante
    to_date(right(split_part(_ab_source_file_url, '.', 1), 8), 'YYYYMMDD') as file_date  -- tipo de receptor de fichero
  from timestamp_localized
),

ranked as (
  select
    exmhcil.*,
    cast(firmeza_ranking.rank as int) as firmeza_rank,
    cast(maturity_ranking.rank as int) as maturity_rank
  from extended_mhcil as exmhcil
    left join {{ ref("seed_simel_mhcil_rankings__firmeza") }} as firmeza_ranking
      on exmhcil.measurement_type = firmeza_ranking.name
    left join {{ ref("seed_simel_mhcil_rankings__maturity") }} as maturity_ranking
      on exmhcil.release_period = maturity_ranking.name
)

select *
from ranked
