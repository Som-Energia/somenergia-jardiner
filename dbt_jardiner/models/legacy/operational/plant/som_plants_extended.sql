{{ config(materialized='view') }}

SELECT
    plant.*,
    pp.peak_power_kw,
    pp.nominal_power_kw,
    pp.connection_date,
    pp.target_monthly_energy_mwh
FROM {{ ref('som_plants_raw') }} as plant
left join {{ ref('plantparameters_raw')}} pp using(plant_id)

