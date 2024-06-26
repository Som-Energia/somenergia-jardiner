{{ config(materialized='view') }}

select
  ip as plant_ip,
  port::integer as modbus_port,
  unit::integer as modbus_unit,
  register_address::integer as modbus_register_address,
  value::integer as value, --noqa: RF04
  is_valid,
  query_time,
  create_date
from {{ source('plantlake', 'modbus_readings') }}
