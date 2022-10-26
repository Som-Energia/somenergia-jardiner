# [short title of solved problem and solution]

* Status: [proposed | rejected | accepted | deprecated | … | superseded by [ADR-0005](0005-example.md)] <!-- optional -->
* Deciders: [list everyone involved in the decision] <!-- optional -->
* Date: [YYYY-MM-DD when the decision was last updated] <!-- optional -->

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

Necessitem alertes d'incidències dels diferents dispositius de les plantes.
Cada dispositiu té especificitats: granularitat temporal de les lectures, lag natural en al càrrega de lectures i casuístiques concretes que es consideren errors.

Dispositius:
- Meter ip
Granularitat lectura: 1 hora
Cada quan arriben les lectures: 20 min (però ERP sincronitza cada 2 hores)
Valors historics updatable: No actualment (a l'erp sí)
Poden aparèixer lectures antigues: No actualment (a l'erp sí)

- Meter moxa
Granularitat lectura: 1 hora
Cada quan arriben les lectures: 20 min (però ERP sincronitza cada 24 hores)
Batch: 24h
Valors historics updatable: No actualment (a l'erp sí)
Poden aparèixer lectures antigues: No actualment (a l'erp sí)

- Inverter
Granularitat lectura: 5 minuts
Cada quan arriben les lectures: 5 minuts
Valors historics updatable: No
Poden aparèixer lectures antigues: Rarament

- String
Granularitat lectura: 5 minuts
Cada quan arriben les lectures: 5 minuts
Valors historics updatable: No
Poden aparèixer lectures antigues: Rarament

- Plant

Casuística: Meter és variable enla cadència d'enviar lectures (sovint tarda a reconnectar)

- Meter que no conecta
Granularitat lectura: 1 hora
Cada quan arriben les lectures:
Valors historics updatable: No
Poden aparèixer lectures antigues: No

## Decision Drivers

* Velocitat d'execució si cal exeutar-ho sovint
* Poder recalcular les alarmes històriques en el futur
* Necessitat de notificar a diversos agents diverses alarmes
* Real-time és necessari en algunes alarmes per evitar pèrdues económiques
* Necessitem un històric
* Hauriem de tenir un from to de duració de les alarmes (tot i que confón una mica a projectes)

## Considered Options

* HI - Calcular realtime a partir de l'històric individual de cada alarma
* RT - Calcular una taula real-time i una històrica més lenta
* ~~RH - Calcular la real-time i guardar-ho com a històric~~
* ~~ST - Trobar la manera de fer stream enlloc de batch~~


## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### HI - Calcular la taula històrica

[example | description | pointer to more information | …] <!-- optional -->

* + Una única lògica si no tenim incremental
* - No hem fet incremental amb DBT mai encara
* + l'incremental pot reescriure dels dos darrers dies
* + pots regenerar la taula sempre

* - fa més complexe les alarmes individuals (over partitions)

```sql
DAG:
(production_inverter) -> (alarm) -> (alrm2)

with ( Taula production_inverter (registry gapfilled, clean, alarms )) as foo

time     | inverter_id | energy | n_readings | alarm_no_reading | alarm_zero_daylight
10:00:00      16           34          1            FALSE               FALSE
09:55:00      16         0/NULL        0            TRUE                NULL
09:50:00      16            0          1            FALSE               TRUE

select last row of foo where alarm = TRUE
```


### RT - Calcular una taula real-time i una històrica més lenta

[example | description | pointer to more information | …] <!-- optional -->

* + Logica més senzilla i ràpida que podem executar més sovint a airflow
* + Permet amb un date_trunc() sobre les lectures fer l'agregació i no cal rolling
* - Igualment s'ha d'escriure la lògica HI per tenir l'històric correcte
* + Podries tenir la taula d'estat actual més fàcilment
* - La unificada s'hauria de fer unint la taula històrica amb la real-time
* - requereix molt lag en escriure la històrica, o posar-hi la lògica que necessites igualment a la opció HI
* - Pot generar incongruències entre el Real-Time (alarmed) que no surtin a l'històric
* - A projectes no li agrada tenir una taula estat actual i històric separat

RT:

real-time, per les alarmes que necessiten notificació immediata, i per cada tipus d'alarma
```sql
with foo as (
select
    count(energy),
    max(energy)
from registry
where NOW() - device.alarm_offset < time
group by device
)
select
 now() as time,
 count = 0 as no_reading_alarm,
 max = 0 as no_energy_alarm
from foo
```
notify OK/KO en aquella execució fent un diff de la taula anterior com ara


històric:
com tenim ara, al final del dia o d'una setmana, re-calcular les alarmes històricament


### ST- Trobar la manera de fer stream enlloc de batch

* Dolent perquè no podem regenerar-ho a posteriori

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
