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
    FROM {{ref('inverterregistry_clean')}} as ir
    left join {{ref('solar_events_generous')}} as solar on ir.time::date = solar.day and ir.plant_id = solar.plant_id
    window w as (PARTITION BY ir.inverter_id ORDER By time ROWS BETWEEN 11 PRECEDING AND current row)
)

select
    *,
    case
        when is_daylight
            and power_kw_count_existing_last_12_readings = 12
            and power_kw_max_last_12_readings = 0
        then TRUE
        else FALSE
    end as alarm_inverter_zero_power_at_daylight
from sub_ir


{# TODO A from-to table can be made downstream if they want it #}