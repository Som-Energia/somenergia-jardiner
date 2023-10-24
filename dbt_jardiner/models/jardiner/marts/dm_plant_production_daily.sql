{{ config(materialized='table') }}



select
    date_trunc('day', hora_inici, 'Europe/Madrid')::date as dia,
    nom_planta,
    tecnologia,
    potencia_pic_kw,
    sum(energia_instantania_inversor_kwh) as energia_instantania_inversor_kwh,
    count(energia_instantania_inversor_kwh) as energia_inversor_count,
    sum(energia_exportada_instantania_comptador_kwh) as energia_exportada_instantania_comptador_kwh,
    count(energia_exportada_instantania_comptador_kwh) as energia_exportada_instantania_comptador_count,
    sum(energia_exportada_comptador_kwh) as energia_exportada_comptador_kwh,
    sum(energia_importada_comptador_kwh) as energia_importada_comptador_kwh,
    min(data_prediccio) as data_prediccio,
    sum(energia_predita_meteologica_kwh) as energia_predita_meteologica_kwh,
    sum(energia_esperada_solargis_kwh) as energia_esperada_solargis_kwh,
    avg(preu_omie_eur_mwh) as preu_omie_eur_mwh,
    sum(irradiation_wh_m2) as irradiation_wh_m2,
    sum(irradiacio_satellit_wh_m2) as irradiacio_satellit_wh_m2,
    avg(temperatura_modul_avg_c) as temperatura_modul_avg_c,
    sum(energia_exportada_comptador_kwh / potencia_pic_kw) / (NULLIF(sum(irradiacio_satellit_wh_m2), 0.0) / 1000.0) as pr,
    sum(hora_disponible) as hora_disponible,
    sum(hora_total) as hora_total,
    sum(hora_disponible)/NULLIF(sum(hora_total),0) as disponibilitat,
    sum(energia_desviada_omie_kwh) as energia_desviada_omie_kwh,
    sum(abs(energia_desviada_omie_kwh)) as energia_desviada_omie_kwh_absolute, {# should it be abs or we let compensate itself? #}
    sum(energia_perduda_kwh) as energia_perduda_kwh,
    1 - sum(energia_predita_meteologica_kwh)/NULLIF(sum(energia_exportada_comptador_kwh),0) as energia_desviada_percent
    {# HMCIL #}
    {# billed_energy as energia_liquidada,
    sum(billed_energy)/sum(dset_meter_exported_energy_kwh) as energia_liquidada_percent#}
from {{ ref("dm_plant_production_hourly") }}
group by date_trunc('day', hora_inici, 'Europe/Madrid'), nom_planta, tecnologia, potencia_pic_kw

