# dbt sql for rolling window

```sql
{%- set plant_alarm_ranges = dbt_utils.get_query_results_as_dict(ref('plant_alarm_ranges')) -%}

{% for plant in plant_alarm_ranges %}

  {% if var('plants_code') == 'SomEnergia_Riudarenes_ZE' %}
      {%- set time_to_sum = '1 hour' -%}
  {% elif var('plants_code') == 'SomEnergia_Matalalana' %}
      {%- set time_to_sum = '4 hour' -%}
  {% else %}
          {{ ref('accounts') }}   accounts
  {% endif %}

  SELECT
      *,
      SUM(export_energy_wh) OVER (
          PARTITION BY plant_name
          ORDER BY "time"
          RANGE BETWEEN interval {{time_to_sum}} PRECEDING AND CURRENT ROW
      ) as export_energy_wh_sum
  FROM (
    select * from {{ref('meter_registry_cleaned')}} where codename = {{plants_code}}
  ) as meter_registry_cleaned_current_plant
  UNION ALL

{% endfor %}
```
