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
        select date_trunc('hour', ts) as start_hour, plant_name, plant_uuid, device_type, metric_name as split_metric, signal_value
        from {{ ref("int_dset_responses__values_incremental") }}
        where metric_name in ('energia_activa_exportada', 'irradiancia')
    )
select
    start_hour,
    plant_name,
    plant_uuid,
    case
        when split_metric = 'irradiancia' then 'irradiation' {# from W/m^2 to Wh/m^2 because split_metric has hourly granularity #}
        when split_metric = 'energia_activa_exportada' then device_type || '_exported_energy'
        else split_metric
    end as metric_name,
    case
        when split_metric = 'energia_activa_exportada' and device_type = 'inverter'
        then (extract(hour from start_hour) > 3)::integer * (max(signal_value) - min(signal_value))  {# we have random-ish resets before 3 #}
        when split_metric = 'irradiancia' and device_type in ('sensor', 'module', 'inverter')
        then avg(signal_value)
        when split_metric = 'energia_activa_exportada' and device_type = 'meter'
        then max(signal_value) - min(signal_value)
        else null
    end as metric_value
from dset_key_metrics
group by start_hour, plant_name, plant_uuid, device_type, split_metric
