{{ config(materialized="view") }}

with meter_readings_wide as (
  select
    mr.start_ts,
    mr.plant_uuid,
    mr.plant_name,
    {{
        pivot(
            column="metric_name",
            names=dbt_utils.get_column_values(table=ref("int_dset_meter__readings"), column="metric_name"),
            value_column="signal_value",
            agg="max",
        )
    }}
  from {{ ref("int_dset_meter__readings") }} as mr
  group by mr.plant_uuid, mr.plant_name, mr.start_ts
  order by mr.start_ts desc
)
select
  start_ts,
  plant_uuid,
  plant_name,
  energia_activa_exportada as meter_exported_energy,
  energia_activa_importada as meter_imported_energy,
  energia_reactiva_q1 as meter_reactive_energy_q1,
  energia_reactiva_q2 as meter_reactive_energy_q2,
  energia_reactiva_q3 as meter_reactive_energy_q3,
  energia_reactiva_q4 as meter_reactive_energy_q4,
  energia_activa_exportada_instantania as meter_instant_exported_energy
from meter_readings_wide
