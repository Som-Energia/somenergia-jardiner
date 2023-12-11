{{ config(materialized="view") }}

select
    plant_name as nom_planta,
    signal_last_ts as ultim_ts,
    signal_last_value as ultim_valor,
    queried_at as peticionat_a,
    signal_name as nom_senyal,
    metric_name as nom_metrica,
    signal_unit as unitat,
    device_name as nom_aparell,
    device_type as tipus_aparell,
    device_parent as aparell_pare,
    signal_uuid as uuid_senyal,
    signal_id as id_dset_senyal,
    signal_code as codi_dset_senyal,
    signal_type as tipus_senyal
from {{ ref("int_dset_last_signal__from_latest_batch_dset_last") }}