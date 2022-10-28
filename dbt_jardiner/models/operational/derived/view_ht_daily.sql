{{config(materialized='view')}}

SELECT reg.plant,
       date_trunc('day', reg.time AT TIME ZONE 'Europe/Madrid') AS "time",
       count(*) AS ht
FROM {{ref('view_satellite_irradiation')}} as reg
INNER JOIN {{source('plantmonitor', 'plant')}} as plant ON reg.plant = plant.id
WHERE irradiation_wh_m2 > 5
GROUP BY date_trunc('day', reg.time AT TIME ZONE 'Europe/Madrid'),
         reg.plant
ORDER BY date_trunc('day', reg.time AT TIME ZONE 'Europe/Madrid')
