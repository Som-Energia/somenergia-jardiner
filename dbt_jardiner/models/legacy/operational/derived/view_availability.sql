{{ config(materialized='view') }}

select
  view_ht_daily.plant,
  date_trunc('month', view_ht_daily."time") as "time",
  sum(view_hd_daily.hd) as hd,
  sum(view_ht_daily.ht) as ht,
  sum(view_hd_daily.hd)::float / sum(view_ht_daily.ht) as "availability"
from {{ ref('view_ht_daily') }} as view_ht_daily
  inner join {{ ref('view_hd_daily') }} as view_hd_daily
    on
      view_ht_daily.time = view_hd_daily.time
      and view_ht_daily.plant = view_hd_daily.plant
group by date_trunc('month', view_ht_daily."time"), view_ht_daily.plant
