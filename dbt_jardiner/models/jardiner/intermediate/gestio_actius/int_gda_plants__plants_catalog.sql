{{ config(materialize='ephemeral') }}

select
    plant_uuid,
    plant_name,
    municipality,
    province,
    latitude,
    longitude,
    peak_power_kw,
    nominal_power_kw,
    technology,
    connection_date,
    "owner",
    n_strings_plant,
    n_modules_string,
    n_strings_inverter,
    esquema_unifilar,
    layout
from {{ ref('raw_gestio_actius_plant_parameters') }}
