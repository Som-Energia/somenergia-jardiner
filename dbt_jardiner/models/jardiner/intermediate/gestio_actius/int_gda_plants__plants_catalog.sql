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
    subtechnology,
    connection_date,
    owner,
    maintenance_company,
    manager,
    n_strings_plant,
    n_modules_total,
    n_inverters,
    esquema_unifilar,
    layout
from {{ ref('raw_gestio_actius_plant_parameters') }}
