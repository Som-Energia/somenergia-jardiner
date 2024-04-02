{{ config(materialized='view') }}

{# modbus_unit = 32 and 33 is specific of asomada. This is a model for adomada standarization #}

{# check that signed 16-bit is equivalent to this in complement two (and wether or not it's what it's using) #}

with stringboxes as (
  select
    mr.query_time,
    mr.device_id as string_id,
    mr.register_name as string_name,
    100 * (mr.value - 2 ^ 16 * (mr.value > 2 ^ 15)::int) as intensity_ma
  from {{ ref("lake_modbusreadings_selected_newest") }} as mr
  where mr.modbus_unit = 32 or mr.modbus_unit = 33
),

stringboxes_rounded as (
  select
    string_id,
    string_name,
    intensity_ma,
    time_bucket('5 minutes', query_time) as five_minute
  from stringboxes
),

stringboxes_joined as (
  select
    str_round.five_minute,
    str_round.string_id as string_id,
    str.string_name,
    str.string_id as transactional_string_id,
    str_round.intensity_ma
  from stringboxes_rounded as str_round
    left join
      {{ ref("strings_raw") }} as str
      on str_round.string_id = str.string_id
)


select * from stringboxes_joined
