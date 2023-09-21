{{ config(materialized='view') }}

{% if target.name == 'testing' %}
--vars{“meter_test_sample”:“meter_sample_name”}

  select
    time::TIMESTAMPTZ as time,
    export_energy_wh,
    import_energy_wh,
    meter_id,
    meter_name,
    connection_protocol
  from  {{ ref(var('meter_test_sample')) }}
  where current_date - interval '90 day' < time::TIMESTAMPTZ

{% else %}

  SELECT
    time - interval '1 hour' as time,
    export_energy_wh,
    import_energy_wh,
    meter as meter_id,
    meter.name as meter_name,
    meter.connection_protocol
  FROM {{source('plantmonitor_legacy','meterregistry')}} as mr
  left join {{source('plantmonitor_legacy','meter')}} on meter.id = mr.meter
  left join {{source('plantmonitor_legacy','plant')}} as plant on plant.id = meter.plant

{% endif %}