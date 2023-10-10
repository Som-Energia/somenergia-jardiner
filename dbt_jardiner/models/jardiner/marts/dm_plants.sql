{{ config(materialize='view') }}

select
    plant_name as nom_planta,
    latitude as latitud,
    longitude as longitud,
    peak_power_kw as potencia_pic_kw,
    nominal_power_kw as potencia_nominal_kw,
    technology as tecnologia,
    connection_date as data_connexio,
    target_monthly_energy_gwh as energia_mensual_objectiu,
    "owner" as empresa_manteniment
from {{ ref('seed_plants__parameters') }}