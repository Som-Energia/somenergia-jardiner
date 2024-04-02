{{ config(materialized='view') }}

with sub_ir as (
  select
    ir.time,
    ir.plant_id,
    ir.plant_name,
    ir.inverter_id,
    ir.inverter_name,
    ir.power_kw,
    solar.sunrise_generous as daylight_start,
    solar.sunset_generous as daylight_end,
    max(ir.power_kw) over w as power_kw_max_last_12_readings,
    count(ir.power_kw) over w as power_kw_count_existing_last_12_readings,
    ir.time between solar.sunrise_generous and solar.sunset_generous as is_daylight
  from {{ ref('alert_inverterregistry_clean_last_hour') }} as ir
    left join
      {{ ref('plantmonitordb_solarevent__generous') }} as solar
      on ir.time::date = solar.day and ir.plant_id = solar.plant_id
  window
    w as (
      partition by ir.inverter_id
      order by ir.time rows between 11 preceding and current row
    )
),

sub_alarm as (
  select
    *,
    case
      when not is_daylight
        then null
      when power_kw_count_existing_last_12_readings < 12
        then null
      when power_kw_max_last_12_readings = 0
        then true
      else false
    end as is_alarmed
  from sub_ir
)

select
  *,
  'inverter' as device_type,
  inverter_id as device_id,
  inverter_name as device_name,
  'alert_inverter_zero_power_at_daylight' as alarm_name
from sub_alarm
where
  (time, plant_id, inverter_name) in
  (
    select
      max(time) as time, --noqa: RF04
      plant_id,
      inverter_name
    from sub_alarm
    group by plant_id, inverter_name
  ) -- get last row for each plant and deivce
order by plant_id asc, inverter_name desc
