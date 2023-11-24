{{ config(materialized="table") }}


{#
    Cada planta té un o diversos tipus de senyals d'irradancia. Així, per cada planta, triem una senyal
    d'irradancia. l'Order by permet fer una jerarquia quan a una planta hi ha més d'un tipus de irradància.
#}
select distinct
    on (plant_uuid, ts)
    plant_uuid,
    plant_name,
    signal_name,
    metric_name,
    device_name,
    device_type,
    device_uuid,
    device_parent,
    signal_uuid,
    group_name,
    signal_id,
    signal_tz,
    signal_code,
    signal_type,
    signal_unit,
    signal_last_ts,
    signal_frequency,
    signal_is_virtual,
    signal_last_value,
    ts,
    signal_value
from {{ ref("int_dset__last_registries") }}
where
    signal_name = 'irradiacio'
    or signal_name = 'irradiacio_sonda_bruta'
    or signal_name = 'irradiacio_sonda_neta'
    or signal_name = 'irradiacio_sonda'
order by
    plant_uuid,
    ts,
    case
        when signal_name = 'irradiacio'
        then 1
        when signal_name = 'irradiacio_sonda_bruta'
        then 2
        when signal_name = 'irradiacio_sonda_neta'
        then 3
        when signal_name = 'irradiacio_sonda'
        then 4
    end
