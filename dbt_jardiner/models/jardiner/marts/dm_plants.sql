{{ config(materialize='view') }}

select
    plant_uuid,
    plant_name as nom_planta,
    municipality as municipi,
    province as provincia,
    latitude as latitud,
    longitude as longitud,
    peak_power_kw as potencia_pic_kw,
    nominal_power_kw as potencia_nominal_kw,
    technology as tecnologia,
    subtechnology as subtecnologia,
    connection_date as connexio,
    owner as propietat,
    maintenance_company as empresa_manteniment,
    manager as responsable_ga,
    n_strings_plant as "strings/planta",
    n_modules_total as modules_total,--"moduls/string",
    n_inverters as inversors,--"strings/inversor",
    n_modules_total,
    n_inverters,
    esquema_unifilar,
    layout
from {{ ref('int_gda_plants__plants_catalog') }}
