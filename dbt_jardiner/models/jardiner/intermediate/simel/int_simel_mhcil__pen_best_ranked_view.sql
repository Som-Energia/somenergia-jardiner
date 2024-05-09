{{ config(materialized="view") }}

with ranked as (
  select
    *,
    extract(epoch from start_at) + file_version + firmeza_rank + maturity_rank as total_rank
  from {{ ref("int_simel_mhcil__pen_extended") }}
),

ordered as (
  select
    *,
    row_number() over (
      partition by cil, start_at
      order by total_rank
    ) as row_order
  from ranked
),

best_ranked as (
  select
    *,
    now() as ranked_at,
    {{ dbt_utils.generate_surrogate_key(["cil", "start_at"]) }} as surrogate_key
  from ordered where row_order = 1
)

select * from best_ranked
