{{ config(materialized='view') }}

with inverterregistry_last_readings as (
    select * from {{ ref('inverterregistry_clean') }}
    where timezone('utc', now()) - interval '1 hour' < time
),
stringregistry_last_readings as (
    select * from {{ ref('stringregistry_raw') }}
    where timezone('utc', now()) - interval '1 hour' < time
), sub_sr as (
    select
        time as time,
        plant.plant_id,
        ir.inverter_id,
        string.string_name,
        coalesce(string.stringbox_name, string.name) as stringbox,
        sr.intensity_ma,
        ir.power_ma,
        sr.intensity_ma < 500 and ir.power_kw > 10 as is_low_intensity
    FROM stringregistry_last_readings AS sr
    LEFT JOIN {{ ref('strings_raw') }} as string using string_id
    LEFT JOIN {{ ref('inverters_raw') }} as inverter using inverter_id
    left join inverterregistry_last_readings as ir using inverter_id
    LEFT JOIN {{ ref('som_plants_raw') }} as plant using plant_id

),
sr_grouped as (
select
        max(time) as time,
        plant.plant_id,
        ir.inverter_id,
        string.string_name,
        coalesce(string.stringbox_name, string.name) as stringbox_name,
        sum(sr.intensity_ma) as intensity_ma,
        sum(ir.power_ma),
        max(is_low_intensity) as low_intensity_alarm
    from sub_sr
    GROUP BY plant_id, inverter_id, string_name, stringbox_name
)

select
*
from sr_grouped


