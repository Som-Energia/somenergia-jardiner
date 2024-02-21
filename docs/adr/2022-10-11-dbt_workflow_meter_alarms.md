# Com processem les alarmes en DBT?

## Context and Problem Statement

Alarmes decomptadors venen en batches que poden venir molt tard.

## Decision Drivers

* Necessitem un històric d'alarmes
* Cal suportar un batch arbitrari (rebre les lectures de les útlimes 24h o dels últims 3 mesos)
* Alarma és pròpia d'un punt en el temps i un aparell o un conjunt (planta)

**unsupported ara mateix**

* No suportarem out of the box updates de les lectures (el plantmonitor ni ho considera, ara per ara)

## Considered Options

1. Calcular l'alarma de les últimes N hores (rang definit per l'alarma)
2. Calcular per cada row si en aquell moment hi havia alarma o no

pseudocode-ish idea: Energy last 24h is 0 -> alarm

select sum(energy) from
    select lag(energy, partition by device order by date desc) from (select * from registry where device1 and date > last_date_1 or device2 and date > last_date_2)
group

on last_date = select max(date) from processed group by device

3. Union amb jinja de 2


select '' as lectura_date, '' as device, '' as alarm


calculated_alarms:

{% foreach row in meters%}
UNION
opció 2
select max(energy) > 0 from registry
where
 device = row['device'] and
 date > row['date'] - 24h
{% endfor %}

select from {{ this }} order by date desc limit 1

materialitzada:
select max(date) from calculated_alarms group by device


4. incremental de dbt + foreach device

{{ config(materialized='incremental') }}

select date, max(energy) > 0 from registry --> caldrà un lag o algo


from raw_app_data.events

{% if is_incremental() %}
  where event_time > (select max(event_time) from {{ this }})
{% endif %}

quan entri un device nou hem de comprovar que where event_time > NULL torna totsels resultats

* without lag: left join with itself on row_number()-24 < row_number() < row_number()

[source](https://learn.microsoft.com/en-us/answers/questions/874769/sql-server-how-to-get-previous-row39s-value-withou.html)

## Decision Outcome

Chosen option: triem l'opció 2. per suportar calcular alarmes en el passat

### Positive Consequences

* Suporta la càrrega de batches arbitraris
* Manté un històric d'alarma

### Negative Consequences

* Requereix materialitzar una taula amb la última lectura processada (o tenir un staging on s'inserten les noves)
* Incrementa la complexitat de la query SQL
