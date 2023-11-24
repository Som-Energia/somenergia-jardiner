{{ config(materialized='view') }}


with pot_instantanea_planta as (
    select
        plant_uuid,
        min(ts) as ultim_registre_pot_instantanea,
        round(sum(signal_value),1) as pot_instantantanea_planta_kw
    from {{ref('int_dset__last_registries')}}
    group by
        plant_uuid,
        device_type,
        signal_name
    having signal_name = 'potencia_activa'
), plant_production_daily_previous_day as(
    SELECT
        plant_uuid,
        nom_planta,
        dia,
        energia_exportada_comptador_kwh,
        energia_esperada_solargis_kwh
    FROM {{ ref('dm_plant_production_daily') }} as ppd
    where dia = current_date - interval '1 day'
)
select
    p.plant_uuid,
    p.plant_name as nom_planta,
    -- p.municipality as municipi,
    p.province as provincia,
    p.technology as tecnologia,
    p.peak_power_kw as potencia_pic_kw,
    p.nominal_power_kw as potencia_nominal_kw,
    i.ultim_registre_pot_instantanea,
    i.pot_instantantanea_planta_kw,
    ir.ts as ultim_registre_irradiacio,
    ir.signal_value as irradiacio,
    ppd.dia,
    ppd.energia_exportada_comptador_kwh,
    ppd.energia_esperada_solargis_kwh
from {{ ref('raw_gestio_actius_plant_parameters') }} p
left join pot_instantanea_planta i using(plant_uuid)
left join plant_production_daily_previous_day ppd using(plant_uuid)
left join {{ref('int_dset_last_registries_irradiation')}} ir using(plant_uuid)
