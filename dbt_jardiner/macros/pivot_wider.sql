{#
Pivot wider. Long to wide table transformer.

Example:

    Input: `public.test`

    | size | color | value |
    |------+-------+-------|
    | S    | blue  |   23  |
    | M    | blue  |   65  |
    | S    | red   |   45  |
    | M    | red   |   78  |

    select
      size,
      {{ pivot('name', dbt_utils.get_column_values(table=ref('kpis_raw'), column='name')) }}
    from public.test
    group by size

    Output:

    | size | red | blue |
    |------+-----+------|
    | S    | 45  | 23   |
    | M    | 78  | 65   |

Arguments:
    column: Column observation, required
    names: Column of desired column names, required
    value_column: List of row values to turn into columns, required
    alias: Whether to create column aliases, default is True
    agg: SQL aggregation function, default is sum
    cmp: SQL value comparison, default is =
    prefix: Column alias prefix, default is blank
    suffix: Column alias postfix, default is blank
    else_value: Value to use if value does not exists, default is NULL
    quote_identifiers: Whether to surround column aliases with double quotes, default is true
    distinct: Whether to use distinct in the aggregation, default is False
#}

{% macro pivot(column,
               names,
               value_column,
               alias=True,
               agg='sum',
               cmp='=',
               prefix='',
               suffix='',
               else_value='NULL',
               quote_identifiers=True) %}
    {{ return(adapter.dispatch('pivot', 'dbt_utils')(column, names, value_column, alias, agg, cmp, prefix, suffix, else_value, quote_identifiers)) }}
{% endmacro %}

{% macro default__pivot(column,
               names,
               value_column,
               alias=True,
               agg='sum',
               cmp='=',
               prefix='',
               suffix='',
               else_value='NULL',
               quote_identifiers=True) %}
  {%- for name in names %}
    {{ agg }}(
      case
      when {{ column }} {{ cmp }} '{{ escape_single_quotes(name) }}'
        then {{ value_column }}
      else {{ else_value }}
      end
    )
    {% if alias -%}
      {%- if quote_identifiers -%}
            as {{ adapter.quote(prefix ~ name ~ suffix) }}
      {%- else -%}
        as {{ dbt_utils.slugify(prefix ~ name ~ suffix) }}
      {%- endif -%}
    {%- endif -%}
    {%- if not loop.last -%},{%- endif -%}
  {%- endfor %}
{% endmacro %}