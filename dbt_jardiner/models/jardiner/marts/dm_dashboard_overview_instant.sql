{{ config(materialized="view") }}

select
    overview.plant_name as nom_planta,
    overview.province as provincia,
    overview.technology as tecnologia,
    overview.peak_power_kw as potencia_pic_kw,
    overview.nominal_power_kw as potencia_nominal_kw,
    overview.irradiance_w_m2_last_registered_at as irradiancia_ts,
    round(overview.irradiance_w_m2, 2) as irradiancia_w_m2,
    overview.instant_power_plant_kw_registered_at as potencia_inst_ts,
    round(overview.instant_power_plant_kw, 2) as potencia_inst_kw,
    round(overview.instant_power_plant_kw / overview.peak_power_kw, 2) as potencia_inst_vs_pic,
    overview.day as dia,
    round((overview.meter_exported_energy_kwh - overview.solargis_meter_expected_energy_kwh) / 1000, 2) as energia_perduda_mwh
from {{ ref("int_plants_overview_instant") }} as overview
