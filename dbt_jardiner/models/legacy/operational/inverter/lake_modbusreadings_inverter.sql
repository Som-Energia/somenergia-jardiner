{{ config(materialized='view') }}

{# modbus_unit = 3 assumes asomada at the moment, which is the unit of the inverter #}

select * from {{ ref("lake_modbusreadings_selected_newest")}}
where modbus_unit = 3
