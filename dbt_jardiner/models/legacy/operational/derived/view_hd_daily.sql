{{config(materialized='view')}}

SELECT date_trunc('day', "time" at time zone 'Europe/Madrid')  at time zone 'Europe/Madrid' AS "time",
    plant,
    count(*) AS hd
FROM {{ref('view_pr_hourly')}}
WHERE pr_hourly > 0.70
GROUP BY date_trunc('day', "time" at time zone 'Europe/Madrid'), plant