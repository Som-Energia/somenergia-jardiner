{{ config(materialized="view") }}


select
    nom_planta,
    nom_planta_dset,
    count(*) filter (
        where uuid_senyal is not null and id_senyal_dset is not null and ultim_ts is not null
    ) as senyals_rebudes,
    count(*) filter (
        where uuid_senyal is not null and (id_senyal_dset is null or ultim_ts is null)
    ) as senyals_no_rebudes,
    count(*) filter (where uuid_senyal is not null) as senyals_esperades,
    count(*) as total_count
from dbt_dev.dm_dset_last_reading__from_signal_last_ts
group by nom_planta, nom_planta_dset
order by nom_planta asc, nom_planta_dset asc
