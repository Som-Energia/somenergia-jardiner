{{ config(materialized='view') }}


with objectius_unpivoted as (
  {# Pivot values from columns to rows. Similar to pandas DataFrame melt() function.#}
  {{ dbt_utils.unpivot(relation=ref('raw_gestio_actius_production_target'), cast_to='numeric', exclude=['plant_name','gestio_actius_updated_at','dbt_updated_at','dbt_valid_from','dbt_valid_to'], field_name='month', value_name='energy_production_target_mwh') }}
)
select
  plant_name,
  month,
  energy_production_target_mwh,
  dbt_valid_from,
  dbt_valid_to
from objectius_unpivoted
