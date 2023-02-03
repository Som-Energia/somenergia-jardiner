{{ config(materialized='view') }}

{# TODO we have to limit per connection_day per plant to avoid having NULL readings before plant existed#}

select
    day,
    somplants.plant_id,
    somplants.plant_name,
    meter_name,
    current_meter_connection_protocol,
    COALESCE(meter_registry_hours_with_readings,0) as meter_registry_hours_with_readings,
    1 as alarm_priority
from {{ref('plant_production_daily') }} as plant_production_daily
inner join {{ ref('som_plants') }} as somplants using(plant_id)
where day < CURRENT_DATE
  and COALESCE(meter_registry_hours_with_readings,0) < 12
order by day desc