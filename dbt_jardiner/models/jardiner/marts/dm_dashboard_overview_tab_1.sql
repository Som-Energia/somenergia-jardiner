{{ config(materialized='view', enabled=False )}}

-- Identificació de la planta (nom, ubicació, tecnologia, potencia instalada)

with plants as (
    SELECT
        plant.plant_id as plant_id,
        plant.plant_name as plant_name,
        plant.plant_codename as plant_codename,
        plant.peak_power_w as peak_power_w,
        plant.nominal_power_w as nominal_power_w,
        plant.latitude as latitude,
        plant.longitude as latitude,
        'PV' as technology
    FROM {{ref('som_plants')}} as plant
),
-- Potencia inversors MW (instantani) vs potencia instalada
-- Recurs instani (irradiancia W/m2 de la sonda….)
instaneous_values as (
	SELECT
		plant_power.plant_id,
		plant_power.inverters_exported_energy_kwh,
        plant_power.irradiance
	from {{ref('stg_plant_production_instantaneous')}} as plant_power
)









-- Energia exportada diaria (d-1) - energia esperada diaria solarGis (d-1) = energia perduda (d-1). Gràfica comptadors Solar Gis
-- Alarmes:
--   on/off zero energia comptador
--   on/off zero potencia inversor
--   internet Ip publica nagios no fa ping
--   comunicació amb algun equip nagios no respon un port o equip