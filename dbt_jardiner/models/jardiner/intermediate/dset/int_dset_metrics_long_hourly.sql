{{ config(materialized="view") }}

{# inverter_energy resets between 1 and 2 +02, which gives us energy spikes.
We therefore set it to 0 between midnight and 3 since all plants are fotovoltaic #}
{# TODO we should pass the inverter_energy to incremental instead of accumulative
since this is ugly as fuck #}
with
    dset_key_metrics as (
        select date_trunc('hour', ts) as start_hour, plant, device_type, metric as split_metric, signal_value
        from {{ ref("int_dset_responses__values_incremental") }}
        where metric in ('inverter_energy', 'irradiance', 'exported_energy')
    )
select
    start_hour,
    plant,
    case when split_metric = 'irradiance' then 'irradiation' else split_metric end as metric,
    case
        when split_metric = 'inverter_energy' and device_type = 'inverter'
        then (extract(hour from start_hour) > 3)::integer * (max(signal_value) - min(signal_value))  {# we have random-ish resets before 3 #}
        when split_metric = 'irradiance' and device_type in ('sensor', 'module', 'inverter')
        then avg(signal_value)
        when split_metric = 'exported_energy' and device_type = 'meter'
        then max(signal_value) - min(signal_value)
        else null
    end as metric_value
from dset_key_metrics
group by start_hour, plant, device_type, split_metric
