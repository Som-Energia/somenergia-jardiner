{{ config(materialized='view', enabled=false) }}

with ir as (
    SELECT
        inverterregistry.*
    FROM {{ref('inverterregistry_clean')}} as inverterregistry
    left join {{ref('solar_events_generous')}} as solar on inverterregistry.time::date = solar.day
where time between solar.sunrise_generous and solar.sunset_generous
),
ir_solar as (
        SELECT
        --date_trunc('day', ir.time) as day,
        ir.time,
        ir.plant_id,
        ir.plant_name,
        ir.inverter_id,
        ir.inverter_name,
        ir.power_kw,
        max(ir.power_kw) OVER w AS power_kw_max_last_12_readings
        --count(ir.power_kw) OVER w AS power_kw_count_existing_last_12_readings
        from ir
        window w as (PARTITION BY ir.inverter_id ORDER By time ROWS BETWEEN 12 PRECEDING AND current row)
)
select * from ir_solar
-- select day, plant_id, plant_name, inverter_id, inverter_name
-- from ir_zero_power
-- group by day, plant_id, plant_name, inverter_id, inverter_name
-- where sum(nrow) >= 12




{#

with ir as (
    SELECT
        inverterregistry.*
    FROM dbt_roger.inverterregistry_clean as inverterregistry
    left join dbt_Roger.solar_events_generous as solar on inverterregistry.time::date = solar.day
	where time between solar.sunrise_generous and solar.sunset_generous
	and time > '2022-10-01'
),
ir_solar as (
        SELECT
        date_trunc('day', ir.time) as day,
        ir.plant_id,
        ir.plant_name,
        ir.inverter_id,
        ir.inverter_name,
        ir.power_kw,
        max(ir.power_kw) OVER w AS power_kw_max_last_12_readings,
        count(ir.power_kw) OVER w AS power_kw_count_existing_last_12_readings
        from ir
        window w as (PARTITION BY ir.inverter_id ORDER By time ROWS BETWEEN 12 PRECEDING AND current row)
)
select * from ir_solar limit 1000

#}













