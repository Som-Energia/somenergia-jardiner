{{ config(materialized="view") }}

{% if target.name == "testing" %}

    select
        "time"::timestamptz as "time",
        plant_id,
        plant_name,
        plant_code,
        inverter_id,
        inverter_name,
        inverter_brand,
        inverter_model,
        inverter_nominal_power_kw,
        power_kw,
        energy_kwh,
        intensity_cc_a,
        intensity_ca_a,
        voltage_cc_v,
        voltage_ca_v,
        uptime_h,
        temperature_c,
        readings

    from {{ ref(var("inverter_test_sample")) }}
{# example vars{“inverter_test_sample”:“inverter_test_name”} #}
{% else %}

  select *
  from {{ ref("inverterregistry_clean") }}
  where time between (now() - interval '2 hour') and now()

{% endif %}
