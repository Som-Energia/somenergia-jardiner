
{{ config(materialized = 'table') }}

select
  spine.*,
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_codename,
  meter.name as meter_name,
  meter.connection_protocol as meter_connection_protocol
from {{ ref('spine_days_localized')}} as spine
left join plant ON TRUE
left join meter on meter.plant = plant.id
