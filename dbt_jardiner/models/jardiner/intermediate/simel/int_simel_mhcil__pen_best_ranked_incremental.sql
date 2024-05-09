{{
    config(
        enabled=false,
        materialized="incremental",
        incremental_strategy="append",
        unique_key="surrogate_key",
    )
}}


{% if not is_incremental() %}

  select {{ dbt_utils.star(from=ref("int_simel_mhcil__pen_best_ranked_view")) }}
  from {{ ref("int_simel_mhcil__pen_best_ranked_view") }}

{% else %}

  with existing as (
    select
      surrogate_key,
      total_rank,
      ranked_at
    from {{ this }}
  ),

  incoming as (
    select {{ dbt_utils.star(from=ref("int_simel_mhcil__pen_best_ranked_view")) }}
    from {{ ref("int_simel_mhcil__pen_best_ranked_view") }}
  ),

  new_rankings as (
    select
      incoming.surrogate_key,
      incoming.total_rank,
      incoming.ranked_at
    from existing
      left join incoming
        on existing.surrogate_key = incoming.surrogate_key
    where
      existing.total_rank < incoming.total_rank
      and existing.ranked_at < incoming.ranked_at
  )

  select *
  from new_rankings

{% endif %}
