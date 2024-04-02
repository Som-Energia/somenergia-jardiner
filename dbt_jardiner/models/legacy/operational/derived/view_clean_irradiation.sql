{#
    TODO decide:
delete this view and do it in redash instead, with proper filters
[chosen option] or hope that it's true that the planner limits the rows necessary by the subquery given a parent where clause
Time it to decide
#}

{# this view is a legacy view which #}
select
  sir.sensor,
  sir."time",
  sir.irradiation_wh_m2 as sonda_irradiation_wh_m2,
  sat.global_tilted_irradiation_wh_m2 as satellite_irradiation_wh_m2,
  coalesce(
    sir.irradiation_wh_m2, sat.global_tilted_irradiation_wh_m2
  ) as irradiation_wh_m2_coalesce,
  case
    when sir.quality < 1 then sat.global_tilted_irradiation_wh_m2
    else sir.irradiation_wh_m2
  end as irradiation_wh_m2,
  case
    when sir.quality < 1 then 'satellite'
    else 'sonda'
  end as reading_source
from {{ source('plantmonitor_legacy', 'irradiationregistry') }} as sir
  left join
    {{ source('plantmonitor_legacy', 'sensor') }} as sensor
    on sir.sensor = sensor.id
  left join
    {{ source('plantmonitor_legacy', 'plant') }} as plant
    on sensor.plant = plant.id
  left join
    {{ source('plantmonitor_legacy', 'satellite_readings') }} as sat
    on
      sensor.plant = sat.plant
      and time_bucket('1 hour', sat."time")
      = time_bucket('1 hour', sir."time")
