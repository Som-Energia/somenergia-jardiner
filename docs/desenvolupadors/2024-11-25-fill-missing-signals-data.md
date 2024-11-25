title: Omplir forats de dades de senyals
description: Passes a seguir a l'hora d'omplir forats de dades de senyals manualment
lang: ca_ES
tags: [pipe, jardiner, forats]
date: 2024-11-25
slug: omplir-forats-dades-dset

# Omplir forats de dades de senyals

Actualment, el sistema de monitoratge de senyals de les plantes pot tenir forats de dades. Aquests forats poden ser deguts a problemes de comunicació, errors en la recollida de dades, etc.

Per com funciona el pipe de dades, les dades se descarreguen nomès un cop si ha hagut una mesura incorrecte, o si no arriba a temps, s'ha de fer feina manual per tornar a descarregar les dades.

Recullim dos escenaris:

- Dades de comptadors amb granularitat de 15 minuts, actualitzades diariament
- Dades de senyals sense categoritzar, amb granularitat horària i actualitzades cada 5 minuts.

Segons el escenari, el procediment a seguir és diferent.

!!! warning "Dades no son a temps real"
    Les dades de senyals no són a temps real, i es disponibilitzen a l'api fins a 15 minuts desprès de que han set generades. Per això que no parlem de servir dades en temps real, perqué les dades disponibles arriben amb un retard.


## Dades de comptadors

### Descripció del script d'ingesta {#script-ingesta}

Actualment les dades de comptadors es llegeixen diàriament amb un DAG d'Airflow ([aqui](https://airflow.somenergia.coop/dags/dset_reader_meters_dag_v2/)). Aquest DAG llegeix executa un script que es pot trobar a [aquí](https://gitlab.somenergia.coop/et/somenergia-plant-reader/-/blob/main/scripts/read_dset_meters.py).

De manera resumida, el script fa el següent:

1. Descarrega les dades de la API de DSET al moment de l'execució.
2. Llegeix les dades de comptadors de la base de dades de SomEnergia. Agafem totes les senyals amb la seva última data de disponible.
3. Comparem les dates disponibles amb les dates de la API de DSET.
   1. Si les dates de la API de DSET són més recents, les descarreguem i les guardem a la base de dades de SomEnergia.
   2. Si les dates de la API de DSET són iguals més antigues, no fem res
   3. Si les dates no hi son a la nostra base de dades, les descarreguem i les guardem a la base de dades de SomEnergia.
4. Aixó té un _caveat_ que afecta a forats: si hi ha un forat però tenim dades més recents, no les podrem detectar per que ja tenim una mesura més recent.
5. Per això, si hi ha un forat, s'ha de fer manualment.


### Resum

Tot el procediment es pot resumir de la manera següent

1. Buscar i eliminar dades en el rang que es vol reomplir les dades
2. Tornar a descarregar les dades amb el [script d'ingesta](#script-ingesta)
3. Aturar DAGs d'Airflow que materialitzen dades en temps real amb `dbt
4. Tirar `dbt` amb `--full-refresh`
5. Tornar a activar DAGs desactivats

### Esborrar i tornar a llegir les dades

Per omplir forats de dades de comptadors, s'ha de seguir el següent procediment:

1. Anar a la base de dades de SomEnergia i buscar la senyal amb el forat de dades. Per exemple: _volem omplir dades de la planta Fontivsolar i Valteina entre el 2024-06-10 i el 2024-08-01_.

    ```sql
    select * from lake.dset_meters_readings dmr
    where group_name in
    (
      'SE_fontivsolar',
      'SE_valteina',
    )
    and ts between '2024-06-10' and '2024-08-01'
    ```

2. Esborrem aquestes dades per garantir que el script detecti els forats desprès. Per això nomès cal canviar la query anterior per una query de _delete_.

    ```sql
    delete from lake.dset_meters_readings dmr -- nou
    where group_name in
    (
      'SE_fontivsolar',
      'SE_valteina',
    )
    and ts between '2024-06-10' and '2024-08-01'
    ```

    !!! warning "Tingues cura amb el _delete_"
        El _delete_ esborra les dades de la base de dades. Assegura't de que les dades que esborres són les correctes.

    !!! note "Lectura de api es fa a nivel de senyal, no de planta"
        Les dades de comptadors es llegeixen a nivell de senyal, no de planta. Per això, s'ha de buscar les senyals amb forats, no les plantes. Aqui esborrem filtrant per planta o `group_name` però podriem fer-ho per `signal_name` també.

3. Executar el script de lectura de comptadors. Aquest script es pot trobar a [aquí](https://gitlab.somenergia.coop/et/somenergia-plant-reader/-/blob/main/scripts/read_dset_meters.py).

    ```bash
    python scripts/read_dset_meters.py
    --db-url <URI_DB> \
    --api-base-url https://api.dset-energy.com \
    --api-key <DSET_API_KEY> \
    --schema lake \
    --sig-detail \
    --apply-k-value \
    --return-null-values \
    --date-from  2024-06-10Z \
    --date-to 2024-08-01Z \
    --max-workers  4
    ```

    Si tens dubtes revisa la documentació del script amb `python scripts/read_dset_meters.py --help`.

4. Comprovar que les dades s'han omplert correctament. Per això, torna a executar la query de l'inici per veure si les dades s'han omplert correctament. Deuria ser així, i hauries de veure les dades que has omplert.

    ```sql
    select * from lake.dset_meters_readings dmr
    where group_name in
    (
      'SE_fontivsolar',
      'SE_valteina',
    )
    and ts between '2024-06-10' and '2024-08-01'
    ```

5. Si les dades s'han omplert correctament, ja hauràs acabat. Si no, revisa els logs del script per veure si hi ha hagut algun error.

### Aturar DAGs que materialitzen dades amb dbt {#aturar-dags-materialitzacio}

Actualment hi ha un [DAG d'Airflow](https://airflow.somenergia.coop/dags/dset_materialize_dag_v1/) que está constantment materalitztant les últimes capes del pipe per que els models finals vagin més rápid. Abans de tocar les dades amb `dbt` al següent pas, caldrà aturar aquest DAG per que en altre cas la db bloquejarà un dels dos processos.

### Executar `dbt --full-refresh`

Amb els forats omplerts, s'han de refer i propagar calculs fets amb dbt al passat amb les dades noves. Com no fem aquest calcul cada vegada al ser molt intensiu, només el fem per els últims dos dies de dades. Aquesta lógica es troba [aquí](https://gitlab.somenergia.coop/et/somenergia-jardiner/-/blob/0364c13c43983bdc0bd931f8cd33100ebfb3eee3/dbt_jardiner/models/jardiner/intermediate/dset/int_dset_responses__values_incremental.sql#L34)


Per això, s'ha de fer un `dbt --full-refresh` per que dbt torni a calcular les dades amb les dades noves del passat.

```bash
dbt build -s tag:jardiner --store-failures --full-refresh --target prod
```

Aquesta tasca és molt intensiva i pot trigar molta estona. Per això, s'ha de fer amb cura i en un moment de baixa càrrega.

### Activat DAGs que materialitzen dades amb dbt {#activar-dags-materialitzacio}

No oblidar-se de activar els DAGs que s'han desactivat en [les passes anteriors](#aturar-dags-materialitzacio)