{{ config(materialized="view") }}

select
  start_hour,
  plant_name,
  plant_uuid,
    {{
        pivot(
            column="metric_name",
            names=dbt_utils.get_column_values(table=ref("int_dset_metrics_long_hourly"), column="metric_name"),
            value_column="metric_value",
            agg="max",
        )
    }}
from {{ ref("int_dset_metrics_long_hourly") }}
group by start_hour, plant_uuid, plant_name
order by start_hour desc
