{{ config(materialized='table') }}


{#
    Cada planta té un o diversos tipus de senyals d'irradancia. Així, per cada planta, triem una senyal
    d'irradancia. l'Order by permet fer una jerarquia quan a una planta hi ha més d'un tipus de irradància.
#}
select
    distinct on (plant, ts)
    plant,
    signal,
    metric,
    device,
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
from {{ref('int_dset__last_registries')}}
where signal = 'irradiacio'
    or signal = 'irradiacio_sonda_bruta'
    or signal = 'irradiacio_sonda_neta'
    or signal = 'irradiacio_sonda'
order by plant, ts,
    case
        when signal = 'irradiacio' then 1
        when signal = 'irradiacio_sonda_bruta' then 2
        when signal = 'irradiacio_sonda_neta' then 3
        when signal = 'irradiacio_sonda' then 4
    end
