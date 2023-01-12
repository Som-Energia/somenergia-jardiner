{{ config(materialized='view') }}

with inverter_modbus_readings as (
    SELECT
        *
    FROM {{ ref('lake_modbusreadings_valid') }}
)

select
    plant_ip,
    modbus_port,
    modbus_unit,
    modbus_register_address,
    value,
    query_time,
    create_date,
    device_type,
    device_id,
    register_name
from inverter_modbus_readings
inner join {{ ref('modbus_registries_selected_meta')}} as meta
on
    meta.ip = inverter_modbus_readings.plant_ip
and meta.port = inverter_modbus_readings.modbus_port
and meta.unit = inverter_modbus_readings.modbus_unit
and meta.register_address = inverter_modbus_readings.modbus_register_address
