{{ config(materialized='view') }}

SELECT
	date_trunc('month', (meterregistry."time" - interval '1 hour'), 'Europe/Madrid') as "time",
	plant.id AS plant_id,
	plant.name AS plant_name,
	meter.id AS meter_id,
	meter.name AS meter_name,
	sum(meterregistry.export_energy_wh) AS export_energy_wh
FROM 
	{{ source('plantmonitordb','meter') }} as meter
LEFT JOIN 
	{{ source('plantmonitordb','plant') }} as plant
ON
	plant.id = meter.plant
LEFT JOIN 
	{{ source('plantmonitordb','meterregistry') }} as meterregistry
ON 
	meter.id = meterregistry.meter
GROUP BY 
	date_trunc('month', (meterregistry."time" - interval '1 hour'), 'Europe/Madrid'), plant_id, plant_name, meter_id, meter_name
ORDER BY 
	date_trunc('month', (meterregistry."time" - interval '1 hour'), 'Europe/Madrid'), plant_id, plant_name, meter_id, meter_name