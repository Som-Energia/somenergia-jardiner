{{ config(materialized='view') }}

with sub_ir as (
    SELECT
        ir.time,
        ir.plant_id,
        ir.plant_name,
        ir.inverter_id,
        ir.inverter_name,
        ir.power_kw,
        max(ir.power_kw) OVER w AS power_kw_max_last_12_readings,
        count(ir.power_kw) OVER w AS power_kw_count_existing_last_12_readings,
        ir.time between solar.sunrise_generous and solar.sunset_generous as is_daylight,
        solar.sunrise_generous as daylight_start,
        solar.sunset_generous as daylight_end
    FROM {{ref('alert_inverterregistry_clean_last_hour')}} as ir
    left join {{ref('plantmonitordb_solarevent__generous')}} as solar on ir.time::date = solar.day and ir.plant_id = solar.plant_id
    window w as (PARTITION BY ir.inverter_id ORDER By time ROWS BETWEEN 11 PRECEDING AND current row)
), sub_alarm as (
    select
        *,
    case
        when not is_daylight
            then NULL
        when power_kw_count_existing_last_12_readings < 12
            then NULL
        when power_kw_max_last_12_readings = 0
            then TRUE
        else FALSE
    end as is_alarmed
    from sub_ir
)

SELECT *,
    'inverter' as device_type,
    inverter_id as device_id,
    inverter_name as device_name,
    'alert_inverter_zero_power_at_daylight' as alarm_name
FROM sub_alarm
where (time,plant_id, inverter_name) in
	( select max(time) as time, plant_id, inverter_name
	  from sub_alarm
	  group by plant_id, inverter_name
	) -- get last row for each plant and deivce
order by plant_id, inverter_name desc
