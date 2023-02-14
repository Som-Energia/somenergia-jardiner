 {# TODO: change inverterregistry for inverterregistry_clean which includes asomada#}

 SELECT date_trunc('day'::text, inverterregistry."time") AS "time",
    plant.id AS plant,
    plant.name AS plant_name,
    inverter.id AS inverter,
    inverter.name AS inverter_name,
    max(inverterregistry.energy_wh) AS energy_wh,
    max(inverterregistry.temperature_dc) AS max_temperature_dc,
    min(inverterregistry.temperature_dc) AS min_temperature_dc,
    avg(inverterregistry.temperature_dc) AS avg_temperature_dc,
    max(inverterregistry.power_w) AS power_w
   FROM {{ source('plantmonitordb', 'inverterregistry') }}
     LEFT JOIN inverter ON inverter.id = inverterregistry.inverter
     LEFT JOIN plant ON plant.id = inverter.plant
  GROUP BY (date_trunc('day'::text, inverterregistry."time")), plant.id, plant.name, inverter.id, inverter.name
  ORDER BY (date_trunc('day'::text, inverterregistry."time")), plant.id, plant.name, inverter.id, inverter.name