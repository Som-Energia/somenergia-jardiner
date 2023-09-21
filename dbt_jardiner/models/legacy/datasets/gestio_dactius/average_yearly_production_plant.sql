SELECT yearly.plant_id,
yearly.plant,
avg(yearly.export_energy_mwh) AS historic_avg,
yearly.time_year AS "time"
FROM (SELECT plant.id as plant_id,
    plant.name AS plant,
    avg(meterregistry.export_energy_wh) / 1000000.0 * 24::numeric * 365::numeric AS export_energy_mwh,
    date_trunc('year'::text, meterregistry."time") AS time_year,
    date_part('year'::text, meterregistry."time") AS year
    FROM meterregistry
        LEFT JOIN meter ON meterregistry.meter = meter.id
        LEFT JOIN plant ON meter.plant = plant.id
    WHERE meterregistry."time" IS NOT NULL AND date_part('year'::text, meterregistry."time") < date_part('year'::text, now())
    GROUP BY plant.id, plant.name, (date_trunc('year'::text, meterregistry."time")), (date_part('year'::text, meterregistry."time"))) yearly
GROUP BY yearly.plant_id, yearly.plant, yearly.time_year