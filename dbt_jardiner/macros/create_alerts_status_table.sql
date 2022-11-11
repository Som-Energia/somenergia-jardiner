{% macro create_alerts_status_table() %}
{% set sql %}
    CREATE TABLE IF NOT EXISTS {{ target.schema }}.alerts_status
(
    "time" timestamp with time zone,
    plant_id integer,
    plant_name text COLLATE pg_catalog."default",
    device_type text COLLATE pg_catalog."default",
    device_name text COLLATE pg_catalog."default",
    alarm_name text COLLATE pg_catalog."default",
    is_alarmed text COLLATE pg_catalog."default"
);

ALTER TABLE IF EXISTS {{ target.schema }}.alerts_status
    OWNER to jardiner;
{% endset %}

{% do run_query(sql) %}
{% do log("create alerts_status table", info=True) %}
{% endmacro %}