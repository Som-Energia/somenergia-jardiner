{{ config(materialize='view') }}

select
    plant as nom_planta,
    municipality as municipi,
    province as provincia,
    latitude as latitud,
    longitude as longitud,
    peak_power_kw as potencia_pic_kw,
    nominal_power_kw as potencia_nominal_kw,
    technology as tecnologia,
    connection_date as connexio,
    owner as manteniment,
    n_strings_plant as "strings/planta",
    n_modules_string as "moduls/string",
    n_strings_inverter as "strings/inversor",
    esquema_unifilar,
    layout
from {{ ref('raw_gestio_actius_plant_parameters') }}