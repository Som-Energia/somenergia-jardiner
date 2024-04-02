{{ config(materialized = 'view') }}

select
  spine.start_hour as start_hour,
  plant.plant_id as plant_id,
  plant.plant_name as plant_name,
  plant.plant_codename as plant_codename,
  plant.peak_power_w as peak_power_w,
  meter.id as meter_id,
  meter.name as meter_name,
  meter.connection_protocol as meter_connection_protocol
from {{ ref('spine_hours_localized') }} as spine
  left join {{ ref('som_plants') }} as plant on true
  left join
    {{ source('plantmonitor_legacy','meter') }} as meter
    on meter.plant = plant.plant_id
