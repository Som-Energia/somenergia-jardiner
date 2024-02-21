title: Incremental Dedup
description: How to deduplicate incremental loads in dbt
date: 2024-01-11
tags: dbt, incremental

# Incremental Dedup

Exemple de com fer un incremental amb deduplicació en dbt.

```sql
{{
  config(
    materialized = 'incremental',
    unique_key = ['signal_uuid','ts'],
    incremental_strategy = 'merge',
    incremental_predicates = [
      "DBT_INTERNAL_DEST.queried_at > dateadd(day, -1, current_date)"
    ]
  )
}}

where
    ts < now() - interval '1 hour'  {#- select only freshly ingested rows #}

    {% if is_incremental() -%}
        and queried_at > coalesce((select max(queried_at) from {{ this }}), '1900-01-01') and queried_at > now() - interval '2 hour'
    {%- endif %}
```

| source senyal     | ts    | valor | queried_at |
| ----------------- | ----- | ----- | ---------- |
| energia_comptador | 03:00 | 80    | +1d 04:00  |
| energia_comptador | 03:00 | null  | 04:00      |
| potencia_inversor | 03:00 | 50    | +1d 04:00  |
| potencia_inversor | 03:00 | 50    | 04:00      |

Son ara les 15:04. en la materialitzada tindrem

| source senyal     | ts    | valor |
| ----------------- | ----- | ----- |
| potencia_inversor | 14:00 | 67    |
| energia_comptador | 14:00 | null  |

o bien, la última fila no hi serà:

| source senyal     | ts    | valor |
| ----------------- | ----- | ----- |
| potencia_inversor | 14:00 | 67    |

# Explicació

`where max(ts) = 14:00`:

| source senyal     | ts    | valor |
| ----------------- | ----- | ----- |
| potencia_inversor | 14:00 | 67    |
| energia_comptador | 14:00 | null  |

`where max(ts) - 24h`:

| source senyal     | ts    | valor | queried_at |
| ----------------- | ----- | ----- | ---------- |
| energia_comptador | 03:00 | 80    | +1d 04:00  |
| potencia_inversor | 03:00 | 50    | +1d 04:00  |
| potencia_inversor | 03:00 | 50    | 04:00      |
| potencia_inversor | 14:00 | 67    |            |
| energia_comptador | 14:00 | null  |            |

`unique (signal_uuid, ts)`:

| source senyal     | ts    | valor | queried_at |
| ----------------- | ----- | ----- | ---------- |
| energia_comptador | 03:00 | 80    | +1d 04:00  |

# prova pràctica

Abans d'executar l'incremental tenim aquest tres últims registres a materialized one hour late

| group_name      | queried_at                    | ts                     | signal_code     | signal_device_type | signal_device_uuid                   | signal_frequency | signal_id | signal_is_virtual | signal_last_ts         | signal_last_value | signal_type | signal_tz     | signal_unit | signal_uuid                          | signal_uuid_raw                      | signal_value | materialized_at               |
| --------------- | ----------------------------- | ---------------------- | --------------- | ------------------ | ------------------------------------ | ---------------- | --------- | ----------------- | ---------------------- | ----------------- | ----------- | ------------- | ----------- | ------------------------------------ | ------------------------------------ | ------------ | ----------------------------- |
| SE_vallehermoso | 2024-01-09 13:24:42.488123+01 | 2024-01-05 23:15:00+01 | ce_eactexp      | meter              | 08bc8d88-4ea2-4ee9-b817-00e1f07debba | 15 minutes       | 983894    | false             | 2024-01-08 23:45:00+01 | 0                 | absolute    | Europe/Madrid | kWh         | 646d1ec2-0ca2-4c22-9739-8161aafb224e | 646d1ec2-0ca2-4c22-9739-8161aafb224e | 0.0          | 2024-01-09 13:36:52.925381+01 |
| SE_asomada      | 2024-01-09 13:24:42.488123+01 | 2024-01-05 23:00:00+01 | s8102           | meter              | c5ed9fab-e73c-40a5-acb3-113e22052fd6 | 5 minutes        | 1031060   | false             | 2024-01-09 11:47:00+01 | 60.2              | absolute    | Europe/Madrid | V           | dd065f6a-4ded-41a8-98d3-ba239f9a2a47 | dd065f6a-4ded-41a8-98d3-ba239f9a2a47 | 60.2         | 2024-01-09 13:36:52.925381+01 |
| SE_tahal        | 2024-01-09 13:24:42.488123+01 | 2024-01-05 23:45:00+01 | ce_ercapexp_er3 | meter              | 5deb3780-02e2-4dcf-a6a7-de646991762c | 15 minutes       | 983890    | false             | 2024-01-08 23:45:00+01 | 0                 | absolute    | Europe/Madrid | kVArh       | 31ae7d09-95db-447d-b5bf-358b056ef5bf | 31ae7d09-95db-447d-b5bf-358b056ef5bf | 0.0          | 2024-01-09 13:36:52.925381+01 |
