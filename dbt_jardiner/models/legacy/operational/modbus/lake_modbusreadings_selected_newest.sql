{{ config(materialized='view') }}

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
  register_name,
  time_bucket('5 minutes', query_time) as five_minute
from (
  select
    *,
    row_number()
      over (
        partition by
          plant_ip,
          modbus_port,
          modbus_unit,
          modbus_register_address,
          time_bucket('5 minutes', query_time)
        order by create_date desc
      )
    as row_number
  from {{ ref('lake_modbusreadings_selected_raw') }}
) as lake_modbusreadings_newest
where row_number = 1
