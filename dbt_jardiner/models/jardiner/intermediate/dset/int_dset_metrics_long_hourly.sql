{{ config(materialized="view") }}

{# inverter_energy resets between 1 and 2 +02, which gives us energy spikes.
We therefore set it to 0 between midnight and 3 since all plants are fotovoltaic #}
{# TODO we should pass the inverter_energy to incremental instead of accumulative
since this is ugly as fuck #}

{#
    This model is followed by a pivot which wants to distinguish between meter_exported_energy and inverter_exported_energy

    case when the content of the google sheets is fragile. We should limit the amount of metrics
    to what we need to uniformize at the dropdown of
    [sheet](https://docs.google.com/spreadsheets/d/1ybUXREO8cMaLMlV4Kt2iYyoNg2msirnbTTiYL2PBY2M).

#}
with
dset_key_metrics as (
  select
    plant_name,
    plant_uuid,
    device_type,
    metric_name as split_metric,
    signal_value,
    date_trunc('hour', ts) as start_hour
  from {{ ref("int_dset_responses__values_incremental") }}
  where
    metric_name in (
      'energia_activa_exportada',
      'energia_activa_exportada_instantania',
      'energia_activa_importada',
      'irradiancia'
    )
)

select
  start_hour,
  plant_name,
  plant_uuid,
  case
    when
      split_metric = 'irradiancia'
      then 'irradiation'
    {# from W/m^2 to Wh/m^2 because split_metric has hourly granularity #}
    when
      split_metric = 'energia_activa_exportada'
      then device_type || '_exported_energy'
    when
      split_metric = 'energia_activa_importada'
      then device_type || '_imported_energy'
    when
      split_metric = 'energia_activa_exportada_instantania'
      then device_type || '_instant_exported_energy'
    else split_metric
  end as metric_name,
  case
    when
      device_type = 'inverter'
      and split_metric = 'energia_activa_exportada'
      then
        (extract(hour from start_hour) > 3)::integer
        * (max(signal_value) - min(signal_value))
    {# we have random-ish resets before 3 #}
    when
      device_type in ('sensor', 'module', 'inverter')
      and split_metric = 'irradiancia'
      then avg(signal_value)
    when
      device_type = 'meter'
      and (
        split_metric = 'energia_activa_exportada'
        or split_metric = 'energia_activa_importada'
      )
      then sum(signal_value)
    when
      device_type = 'meter'
      and (split_metric = 'energia_activa_exportada_instantania')
      then max(signal_value) - min(signal_value)
  end as metric_value
from dset_key_metrics
group by start_hour, plant_name, plant_uuid, device_type, split_metric
