{{ config(materialized='view') }}

with inverter_modbus_pivoted as (
  select
    five_minute,
    device_id as inverter_id,
    {{ pivot(column='register_name', names=dbt_utils.get_column_values(table=ref('lake_modbusreadings_inverter'), column='register_name'), value_column='value', agg='max') }}
  from {{ ref('lake_modbusreadings_inverter') }}
  where five_minute is not null
  group by five_minute, device_type, device_id
)

select
  *
from inverter_modbus_pivoted
