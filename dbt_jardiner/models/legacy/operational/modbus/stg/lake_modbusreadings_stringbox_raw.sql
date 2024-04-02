{{ config(materialized='view') }}

select *
from {{ ref('lake_modbusreadings_raw') }}
where
  plant_ip ilike 'planta-asomada.somenergia.coop'
  and (modbus_register_address = 33 or modbus_register_address = 32)
