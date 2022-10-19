{{config(materialized='view')}}

SELECT
    date_trunc('month', view_ht_daily."time") AS "time",
    view_ht_daily.plant,
    sum(hd) as hd,
    sum(ht) as ht,
    sum(hd)::float/sum(ht) AS "availability"
FROM {{ref('view_ht_daily')}} as view_ht_daily
JOIN {{ref('view_hd_daily')}} as view_hd_daily
    ON view_hd_daily.time = view_ht_daily.time
    and view_hd_daily.plant = view_ht_daily.plant
group by date_trunc('month', view_ht_daily."time"), view_ht_daily.plant