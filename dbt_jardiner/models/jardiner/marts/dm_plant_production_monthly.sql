{{ config(materialized='table') }}


select
    date_trunc('month', dia) as month,
    nom_planta as nom_planta,
    tecnologia as tecnologia,
    potencia_pic_kw as potencia_pic_kw,
    sum(energia_instantania_inversor_kwh)/1000.0 as energia_instantania_inversor_mwh,
    count(energia_instantania_inversor_kwh) as energia_inversor_count,
    round(sum(energia_exportada_instantania_comptador_kwh)/1000.0, 1) as energia_exportada_instantania_comptador_mwh,
    count(energia_exportada_instantania_comptador_kwh) as energia_exportada_instantania_comptador_count,
    round(sum(energia_exportada_comptador_kwh)/1000.0, 1) as energia_exportada_comptador_mwh,
    round(sum(energia_importada_comptador_kwh)/1000.0, 1) as energia_importada_comptador_mwh,
    --min(data_prediccio) as data_prediccio,
    round(sum(energia_predita_meteologica_kwh)/1000.0, 1) as energia_predita_meteologica_mwh,
    round(sum(energia_esperada_solargis_kwh)/1000.0, 1) as energia_esperada_solargis_mwh,
    avg(preu_omie_eur_mwh) as preu_omie_eur_mwh,
    sum(irradiation_wh_m2) as irradiation_wh_m2,
    sum(irradiacio_satellit_wh_m2) as irradiacio_satellit_wh_m2,
    --avg(temperatura_modul_avg_c) as temperatura_modul_avg_c,
    round((sum(energia_exportada_comptador_kwh / potencia_pic_kw) / (NULLIF(sum(irradiacio_satellit_wh_m2), 0.0) / 1000.0))::numeric, 3) as pr,
    round((sum(energia_exportada_comptador_kwh) / potencia_pic_kw)::numeric, 2) AS hores_equivalents,
    sum(hora_disponible) as hora_disponible,
    sum(hora_total) as hora_total,
    sum(hora_disponible)/NULLIF(sum(hora_total),0) as disponibilitat,
    round(sum(energia_desviada_omie_kwh)/1000.0, 1) as energia_desviada_omie_mwh,
    round((sum(abs(energia_desviada_omie_kwh_absolute))/1000.0)::numeric, 1) as energia_desviada_omie_mwh_absolute, {# should it be abs or we let compensate itself? #}
    round(sum(energia_perduda_kwh)/1000.0, 1) as energia_perduda_mwh,
    round((1 - sum(energia_predita_meteologica_kwh)/NULLIF(sum(energia_exportada_comptador_kwh),0))::numeric, 2) as energia_desviada_percent
from {{ ref("dm_plant_production_daily") }}
group by date_trunc('month', dia), nom_planta, tecnologia, potencia_pic_kw
order by month desc

