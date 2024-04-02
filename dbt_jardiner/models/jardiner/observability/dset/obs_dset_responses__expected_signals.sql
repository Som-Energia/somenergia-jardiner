{{ config(materialized="view") }}


with esperades as (
  select *
  from {{ ref("dm_dset_last_reading__from_signal_last_ts") }}
  where uuid_senyal is not null
)

select
  nom_planta,
  count(*) as senyals_esperades,
  count(*) filter (where ultim_ts is null) as no_rebudes_mai,
  count(*) filter (where ultim_ts is not null) as rebudes_alguna_vegada,
  count(*) filter (
    where ultim_ts is not null and ultim_ts >= current_date
  ) as rebudes_avui,
  count(*) filter (
    where ultim_ts is not null and ultim_ts < current_date
  ) as no_rebudes_avui,
  count(*) filter (
    where ultim_ts is null
    or (ultim_ts is not null and ultim_ts < current_date)
  ) as no_rebudes_total
from esperades
group by nom_planta
