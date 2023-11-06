{{ config(materialized="view") }}

select
    start_hour,
    plant,
    {{
        pivot(
            column="metric",
            names=dbt_utils.get_column_values(table=ref("int_dset_metrics_long_hourly"), column="metric"),
            value_column="metric_value",
            agg="max",
        )
    }}
from {{ ref("int_dset_metrics_long_hourly") }}
group by start_hour, plant
order by start_hour desc
