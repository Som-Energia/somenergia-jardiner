{{ config(materialized="view") }}


with inesperades as (
  select *
  from {{ ref("dm_dset_last_reading__from_signal_last_ts") }}
  where uuid_senyal is null
)
select nom_planta_dset, count(*) as senyals_inesperades
from inesperades
group by nom_planta_dset
