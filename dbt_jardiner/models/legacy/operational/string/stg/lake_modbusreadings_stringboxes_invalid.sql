{{ config(materialized='view') }}

{# modbus_unit = 32 and 33 is specific of asomada. This is a model for adomada standarization #}

with stringboxes as (
  select transactional_string_id
  from {{ ref('lake_modbusreadings_stringboxes') }}
)

select * from stringboxes
where transactional_string_id is null
