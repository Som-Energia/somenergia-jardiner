{{ config(materialized='view') }}


select
  s.month,
  pt.plant_name,
  pt.plant_uuid,
  pt.energy_production_target_mwh
from {{ ref('spine_monthly__full_year') }} as s
  left join {{ ref('int_production_target__long') }} as pt
    on
      to_char(s.month, 'FMmonth') ilike pt.month
