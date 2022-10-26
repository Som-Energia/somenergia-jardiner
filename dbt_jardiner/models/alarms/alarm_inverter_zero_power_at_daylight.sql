{{ config(materialized='view') }}

with ir as (
    SELECT
        inverterregistry.*,
        solar.sunrise_generous,
        solar.sunset_generous
    FROM {{ref('inverterregistry_clean')}} as inverterregistry
    left join {{ref('solar_events_generous')}} as solar on inverterregistry.time::date = solar.day and inverterregistry.plant_id = solar.plant_id
	where time between solar.sunrise_generous and solar.sunset_generous
),
ir_solar as (
    SELECT
        ir.time,
        date_trunc('day', ir.time) as day,
        ir.plant_id,
        ir.plant_name,
        ir.inverter_id,
        ir.inverter_name,
        ir.power_kw,
        ir.sunrise_generous,
        ir.sunset_generous,
        max(ir.power_kw) OVER w AS power_kw_max_last_12_readings,
        count(ir.power_kw) OVER w AS power_kw_count_existing_last_12_readings
    from ir
    window w as (PARTITION BY ir.inverter_id ORDER By time ROWS BETWEEN 11 PRECEDING AND current row)
)
select * from ir_solar
where power_kw_count_existing_last_12_readings = 12
and power_kw_max_last_12_readings is not null
and power_kw_max_last_12_readings = 0
order by day desc