{{ config(materialized='view') }}

select
    nom_planta,
    --municipality as municipi,
    provincia,
    tecnologia,
    potencia_pic_kw,
    ultim_registre_pot_instantanea,
    round(pot_instantantanea_planta_kw,2) as pot_instantantanea_planta_kw,
    round(pot_instantantanea_planta_kw/potencia_pic_kw,2) as instant_vs_pic,
    ultim_registre_irradiacio,
    irradiacio,
    dia,
    round((energia_exportada_comptador_kwh - energia_esperada_solargis_kwh)/1000,2) as energia_perduda_mw
from {{ ref('int_plants_overview_instant') }}