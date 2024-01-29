{{ config(materialized='table') }}



select
    start_hour as hora_inici,
    start_hour + interval '1 hour' as hora_final,
    plant_uuid,
    plant_name as nom_planta,
    technology as tecnologia,
    peak_power_kw as potencia_pic_kw,
    dset_inverter_energy_kwh as energia_instantania_inversor_kwh,
    dset_meter_instant_exported_energy_kwh as energia_exportada_instantania_comptador_kwh,
    1 - {{dbt_utils.safe_divide('dset_inverter_energy_kwh','dset_meter_instant_exported_energy_kwh')}} as energia_perduda_inversor_a_comptador,
    meter_exported_energy_kwh as energia_exportada_comptador_kwh,
    dset_meter_exported_energy_kwh as dset_energia_exportada_comptador_kwh,
    erp_meter_exported_energy_kwh as erp_energia_exportada_comptador_kwh,
    meter_imported_energy_kwh as energia_importada_comptador_kwh,
    dset_meter_imported_energy_kwh as dset_energia_importada_comptador_kwh,
    erp_meter_imported_energy_kwh as erp_energia_importada_comptador_kwh,
    date_trunc('day',forecast_date,'Europe/Madrid')::date as data_prediccio,
    forecast_energy_kwh as energia_predita_meteologica_kwh,
    satellite_energy_output_kwh as energia_esperada_solargis_kwh,
    (satellite_energy_output_kwh - dset_meter_exported_energy_kwh) as energia_perduda_kwh,
    omie_price_eur_mwh as preu_omie_eur_mwh,
    dset_irradiation_wh as irradiation_wh_m2,
    satellite_irradiation_wh_m2 as irradiacio_satellit_wh_m2,
    satellite_module_temperature_dc*100 as temperatura_modul_avg_c,
    pr_hourly as pr_horari,
    (pr_hourly > 0.7)::integer as hora_disponible,
    (satellite_irradiation_wh_m2 > 5)::integer as hora_total,
    {# hd/ht only makes sense in daily and up#}
    {#(pr_hourly > 0.7)/NULLIF(satellite_irradiation_wh_m2 > 5,0) as disponibilitat,#}
    (dset_meter_exported_energy_kwh - forecast_energy_kwh) as energia_desviada_omie_kwh,
    1 - forecast_energy_kwh/NULLIF(dset_meter_exported_energy_kwh,0) as energia_desviada_percent,
    is_daylight_generous as is_daylight
    {# HMCIL #}
    {# billed_energy as energia_liquidada,
    billed_energy/dset_meter_exported_energy_kwh as energia_liquidada_percent#}
from {{ ref("obt_hourly_incremental") }}

