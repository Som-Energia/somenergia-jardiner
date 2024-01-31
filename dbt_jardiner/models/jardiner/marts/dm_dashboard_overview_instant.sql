{{ config(materialized="view") }}

select
    nom_planta,
    provincia,
    tecnologia,
    potencia_pic_kw,
    pot_instantanea_planta_kw_last_registered_at,
    irradiacio_w_m2_last_registered_at,
    irradiacio_w_m2,
    dia,
    round(pot_instantanea_planta_kw, 2) as pot_instantanea_planta_kw,
    round(pot_instantanea_planta_kw / potencia_pic_kw, 2) as instant_vs_pic,
    round((energia_exportada_comptador_kwh - energia_esperada_solargis_kwh) / 1000, 2) as energia_perduda_mwh
from {{ ref("int_plants_overview_instant") }}
