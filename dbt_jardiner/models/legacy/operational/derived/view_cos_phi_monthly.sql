{{ config(materialized='view') }}

select
  "time",
  plant_id,
  meter_id,
  import_energy_wh,
  export_energy_wh,
  qimportada,
  qexportada,
  --pendent de validar amb el grafana, mensual = suma(horaria), segur?
  sqrt(
    qimportada * qimportada + export_energy_wh * export_energy_wh
  ) as simportada,
  sqrt(
    qexportada * qexportada + import_energy_wh * import_energy_wh
  ) as sexportada,
  qimportada
  / nullif(
    sqrt(qimportada * qimportada + export_energy_wh * export_energy_wh), 0
  ) as cos_phi_importacio,
  qexportada
  / nullif(
    sqrt(qexportada * qexportada + import_energy_wh * import_energy_wh), 0
  ) as cos_phi_exportacio
from {{ ref('view_q_monthly') }}
