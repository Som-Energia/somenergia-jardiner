{{ config(materialized='view') }}


with pot_instantanea_planta as (
    select
        plant_uuid,
        min(ts) as pot_instantanea_planta_kw_last_registered_at,
        round(sum(signal_value), 1) as pot_instantanea_planta_kw
    from {{ ref('int_dset__last_registries') }}
    group by
        plant_uuid,
        device_type,
        signal_name
    having signal_name = 'potencia_activa'
),

plant_production_daily_previous_day as (
    select
        plant_uuid,
        nom_planta,
        dia,
        energia_exportada_comptador_kwh,
        energia_esperada_solargis_kwh
    from {{ ref('dm_plant_production_daily') }}
    where dia = current_date - interval '1 day'
)

select
    p.plant_uuid,
    p.plant_name as nom_planta,
    p.municipality as municipi,
    p.province as provincia,
    p.technology as tecnologia,
    p.peak_power_kw as potencia_pic_kw,
    p.nominal_power_kw as potencia_nominal_kw,
    i.pot_instantanea_planta_kw_last_registered_at,
    i.pot_instantanea_planta_kw,
    ir.ts as irradiacio_w_m2_last_registered_at,
    ir.signal_value as irradiacio_w_m2,
    ppd.dia,
    ppd.energia_exportada_comptador_kwh,
    ppd.energia_esperada_solargis_kwh
from {{ ref('raw_gestio_actius_plant_parameters') }} as p
left join pot_instantanea_planta as i on p.plant_uuid = i.plant_uuid
left join plant_production_daily_previous_day as ppd on p.plant_uuid = ppd.plant_uuid
left join {{ ref('int_dset_last_registries_irradiation') }} as ir on p.plant_uuid = ir.plant_uuid
