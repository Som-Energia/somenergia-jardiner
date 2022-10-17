{{ config(materialized='view') }}

{# TODO we have to limit per connection_day per plant to avoid having NULL readings before plant existed#}


with alarm_meter_no_readings as (
  select
    day,
    plant_id,
    plant_name,
    'plant' as device_type,
    plant_name as device_name,
    'alarm_meter_no_readings' as alarm_name,
    TRUE as is_alarmed
  from {{ ref('alarm_meter_no_readings') }}
),
alarm_meter_no_energy as (
  select
    day,
    plant_id,
    plant_name,
    'meter' as device_type,
    plant_name as device_name,
    'alarm_meter_no_energy' as alarm_name,
    TRUE as is_alarmed
  from {{ ref('alarm_meter_no_energy') }}
)

select * from alarm_meter_no_readings
UNION
select * from alarm_meter_no_energy

