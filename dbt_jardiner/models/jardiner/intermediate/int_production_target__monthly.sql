{{ config(materialized='view') }}


select
  s.month,
  pt.plant,
  pt.energy_production_target_mwh
from {{ref('spine_monthly__full_year')}} s
left join {{ref('int_production_target__long')}} pt
  on pt.dbt_valid_from <= s.month and s.month < pt.dbt_valid_to
  and to_char(s.month,'FMmonth') ilike pt.month



