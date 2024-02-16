{{ config(materialized='view') }}


select
  s.month,
  pt.plant_name,
  pt.energy_production_target_mwh
from {{ ref('spine_monthly__full_year') }} as s
  left join {{ ref('int_production_target__long') }} as pt
    on
      s.month >= pt.dbt_valid_from and s.month < pt.dbt_valid_to
      and to_char(s.month, 'FMmonth') ilike pt.month
