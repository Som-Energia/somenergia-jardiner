{{ config(materialized='view') }}

{# TODO we have to limit per connection_day per plant to avoid having NULL readings before plant existed#}

select
  prod.day,
  somplants.plant_id,
  somplants.plant_name,
  prod.meter_name,
  prod.current_meter_connection_protocol,
  1 as alarm_priority,
  coalesce(
    prod.meter_registry_hours_with_readings, 0
  ) as meter_registry_hours_with_readings
from {{ ref('plant_production_daily') }} as prod
  inner join {{ ref('som_plants') }} as somplants using (plant_id)
where
  prod.day < current_date
  and coalesce(prod.meter_registry_hours_with_readings, 0) < 12
order by prod.day desc
