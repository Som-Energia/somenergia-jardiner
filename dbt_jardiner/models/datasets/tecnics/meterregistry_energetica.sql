{{ config(post_hook="grant select on {{ this }} to group energetica") }}

select
  time_start_hour as time,
  export_energy_wh,
  import_energy_wh,
  meter_id,
  meter_name,
  connection_protocol,
  plant_id as plant,
  plant_name,
  plant_code
from {{ ref('meter_registry') }}
where plant_id in (select id from {{ ref('plants_energetica') }})