{{ config(materialized='view') }}


with pot_instantanea_planta as (
    select
        plant,
        min(ts) as ultim_registre_pot_instantanea,
        round(sum(signal_value),1) as pot_instantantanea_planta_kw
    from {{ref('int_dset__last_registries')}}
    group by
        plant,
        device_type,
        signal
    having signal = 'potencia_activa'
), plant_production_daily_previous_day as(
    SELECT
        nom_planta,
        dia,
        energia_exportada_comptador_kwh,
        energia_esperada_solargis_kwh
    FROM {{ ref('dm_plant_production_daily') }} as ppd
    where dia = current_date - interval '1 day'
)
select
    p.plant_name as nom_planta,
    --municipality as municipi,
    province as provincia,
    technology as tecnologia,
    peak_power_kw as potencia_pic_kw,
    nominal_power_kw as potencia_nominal_kw,
    i.ultim_registre_pot_instantanea,
    i.pot_instantantanea_planta_kw,
    ir.ts as ultim_registre_irradiacio,
    ir.signal_value as irradiacio,
    ppd.dia,
    ppd.energia_exportada_comptador_kwh,
    ppd.energia_esperada_solargis_kwh
from {{ ref('seed_plants__parameters') }} p
left join pot_instantanea_planta i
    on i.plant = p.plant_name
left join plant_production_daily_previous_day ppd on ppd.nom_planta = p.plant_name
left join {{ref('int_dset_last_registries_irradiation')}} ir
    on ir.plant =p.plant_name