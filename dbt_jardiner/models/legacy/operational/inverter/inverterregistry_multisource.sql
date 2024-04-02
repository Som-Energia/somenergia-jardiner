{{ config(materialized='view') }}

with inverterregistry as (

  select
    time,
    inverter_id,
    power_kw,
    energy_kwh,
    intensity_cc_a,
    intensity_ca_a,
    voltage_cc_v,
    voltage_ca_v,
    uptime_h,
    temperature_c,
    readings
  from {{ ref('inverterregistry_raw') }}

  union all

  select
    time,
    inverter_id,
    power_kw,
    energy_kwh,
    intensity_cc_a,
    intensity_ca_a,
    voltage_cc_v,
    voltage_ca_v,
    uptime_h,
    temperature_c,
    readings
  from {{ ref('lake_modbusreadings_inverter_standard') }}

)

select * from inverterregistry
{% if target.name == 'pre' %}
where time >= current_date - interval '3 days'
{% endif %}
