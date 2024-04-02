{{ config(materialized='view') }}

with inverter_modbus_readings as (
  select *
  from {{ ref('lake_modbusreadings_valid') }}
)

select
  meta.ip as plant_ip,
  meta.port as modbus_port,
  meta.unit as modbus_unit,
  meta.register_address as modbus_register_address,
  inverter_modbus_readings.value,
  inverter_modbus_readings.query_time,
  inverter_modbus_readings.create_date,
  meta.device_type,
  meta.device_id,
  meta.register_name
from inverter_modbus_readings
  inner join {{ ref('modbus_registries_selected_meta') }} as meta
    on
      inverter_modbus_readings.plant_ip = meta.ip
      and inverter_modbus_readings.modbus_port = meta.port
      and inverter_modbus_readings.modbus_unit = meta.unit
      and inverter_modbus_readings.modbus_register_address
      = meta.register_address
