{{ config(materialized='view') }}

{#

This code is for the registries 32bit metrics that are splitted into 2 modbus registries

Assumes signed registries. We've seen that only uptime is unsigned, meaning that in 68 years we will get a negative uptime.
#}

with inverter_modbus as (
    select
        five_minute,
        inverter_id,
        {{concat_bytes('power_kw')}},
        {{concat_bytes('temperature_dc')}},
        {{concat_bytes('uptime_s')}},
        {{concat_bytes('energy_total_10kwh')}},
        {{concat_bytes('energy_10kwh_daily')}}
    from {{ ref("lake_modbusreadings_inverter_pivoted")}}
)

select
    *
from inverter_modbus
