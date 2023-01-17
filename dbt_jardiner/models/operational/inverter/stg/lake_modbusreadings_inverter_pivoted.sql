{{ config(materialized='view') }}

{# modbus_unit = 3 assumes asomada at the moment, which is the unit of the inverter

this code is for the registries 32bit metrics that are splitted into 2 modbus registries
 #}

{# a fer demà : pivot tables #}
with inverter_modbus_pivoted as (
    select
        five_minute,
        device_id as inverter_id,
        {{ pivot(column='register_name', names=dbt_utils.get_column_values(table=ref('lake_modbusreadings_inverter'), column='register_name'), value_column='value', agg='max') }}
    from {{ ref('lake_modbusreadings_inverter') }}
    where five_minute is not NULL
    group by five_minute, device_type, device_id
)
{# do
high_bytes > 2^15 then -1*(high_bytes*2^16 + low_bytes)

add a comment that this assumes signed registries
 #}

select
    *
from inverter_modbus_pivoted
