{{ config(materialized='view') }}


with objectius_unpivoted as (
  {# Pivot values from columns to rows. Similar to pandas DataFrame melt() function.#}
  {{ dbt_utils.unpivot(
      relation=ref('raw_gestio_actius_production_target'),
      cast_to='numeric',
      exclude=['plant_name','plant_uuid','gestio_actius_updated_at','dbt_updated_at','dbt_valid_from','dbt_valid_to'],
      field_name='month',
      value_name='energy_production_target_mwh'
      )
  }}
)
select
  objectius_unpivoted.plant_name,
  objectius_unpivoted.plant_uuid,
  objectius_unpivoted.month,
  objectius_unpivoted.energy_production_target_mwh,
  objectius_unpivoted.dbt_valid_from,
  objectius_unpivoted.dbt_valid_to
from objectius_unpivoted
