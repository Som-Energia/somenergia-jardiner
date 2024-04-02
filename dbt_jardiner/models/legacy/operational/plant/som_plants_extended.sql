{{ config(materialized='view') }}

select
  plant.*,
  pp.peak_power_kw,
  pp.nominal_power_kw,
  pp.connection_date,
  pp.target_monthly_energy_mwh
from {{ ref('som_plants_raw') }} as plant
  left join {{ ref('plantparameters_raw') }} as pp on plant.plant_id = pp.plant_id
