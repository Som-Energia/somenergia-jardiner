{% macro create_alert_inverter_zero_power_at_daylight_status() %}
{% set sql %}

CREATE TABLE IF NOT EXISTS {{ target.schema }}.alert_inverter_zero_power_at_daylight_status
(
    "time" timestamp with time zone,
    plant_id integer,
    plant_name text COLLATE pg_catalog."default",
    inverter_id integer,
    inverter_name text COLLATE pg_catalog."default",
    power_kw numeric,
    power_kw_max_last_12_readings numeric,
    power_kw_count_existing_last_12_readings bigint,
    is_daylight boolean,
    daylight_start timestamp with time zone,
    daylight_end timestamp with time zone,
    is_alarmed boolean
);

ALTER TABLE IF EXISTS {{ target.schema }}.alert_inverter_zero_power_at_daylight_status
    OWNER to jardiner;

{% endset %}

{% do run_query(sql) %}
{% do log("createalert_inverter_zero_power_at_daylight_status table", info=True) %}
{% endmacro %}