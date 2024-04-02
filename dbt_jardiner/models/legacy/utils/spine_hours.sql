{{ config(materialized = 'table') }}


{{ dbt_utils.date_spine(
    datepart="hour",
    start_date="to_date('01/01/2015', 'mm/dd/yyyy')",
    end_date="to_date('01/01/2030', 'mm/dd/yyyy')"
) }}
