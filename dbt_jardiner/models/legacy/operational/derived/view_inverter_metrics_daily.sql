{# TODO: change inverterregistry for inverterregistry_clean which includes asomada#}

select
  plant.id as plant,
  plant.name as plant_name,
  inverter.id as inverter,
  inverter.name as inverter_name,
  date_trunc('day'::text, inverterregistry."time") as "time",
  max(inverterregistry.energy_wh) as energy_wh,
  max(inverterregistry.temperature_dc) as max_temperature_dc,
  min(inverterregistry.temperature_dc) as min_temperature_dc,
  avg(inverterregistry.temperature_dc) as avg_temperature_dc,
  max(inverterregistry.power_w) as power_w
from {{ source('plantmonitor_legacy', 'inverterregistry') }} as inverterregistry
  left join inverter on inverter.id = inverterregistry.inverter
  left join plant on inverter.plant = plant.id
group by
  (date_trunc('day'::text, inverterregistry."time")),
  plant.id,
  plant.name,
  inverter.id,
  inverter.name
order by
  (date_trunc('day'::text, inverterregistry."time")),
  plant.id,
  plant.name,
  inverter.id,
  inverter.name
