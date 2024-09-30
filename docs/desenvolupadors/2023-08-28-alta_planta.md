title: Alta d'una planta fotovoltaica al pipe de Jardiner
description: Procediment a seguir a l’incorporar una nova planta fotovoltaica
lang: ca_ES
tags: [pipe, jardiner, planta, fotovoltaica]
date: 2023-08-28

# Context

Tenim un pipe de transformació de dades que acaba en una serie de dashboards de [superset](https://indicadors.somenergia.coop) que mostra dades de plantes des de el pipe de transformació de dades arribant del nostre proveïdor de dades.

## Protocol d'alta d'una planta fotovoltaica

Per afegir una nova planta a la visualització, cal seguir un protocol documentat al [Formulari d’inscripció de noves plantes a Superset](https://docs.google.com/document/d/172qofxlvavQhdQhyJ9HE73CX6YLVYA2u6Mq3w_NOzyA/edit#heading=h.mcehna5jn0kc)

El equip de gestio d'actius ha d'omplir aquest formulari amb les dades de la planta i ens ho han de comunicar per a que puguem seguir amb el procés nosaltres.

!!! info "Obres en curs amb jardiner-admin"

    Aquesta tasca està en procés de ser portada al [jardiner-admin](https://jardiner-admin.moll.somenergia.coop/). Per tant, aquest protocol pot canviar en el futur.

!!! warning "Necessites permisos d'administrador"

    Aquesta tasca és per a desenvolupadors que treballen amb el pipe de transformació de dades. Si no ets un desenvolupador, no cal que facis aquesta tasca.

Aqui sota ens dediquem a documentar técnicament els passos a seguir des de la perspectiva de desenvolupament.

## Checklist general per IT

- [ ] Tenir accés als següents documents
    - [ ] [Mapeig de senyals](#fitxer-mapeig-de-senyals)
    - [ ] [Dades fixes de planta](#fitxer-dades-fixes-de-planta)
    - [ ] [Info api solargis](#fitxer-info-api-solargis)
    - [ ] [Rendiment de planta](#fitxer-rendiment-de-planta)
    - [ ] [Producció actual de planta](#fitxer-produccio-actual-de-planta)
- [ ] [Omplir dades al excel de mapeigs d’airbyte](#afegir-mapeig-airbyte)
- [ ] [Afegir planta segons l’estructura de plantmonitor](#afegir-meteologica-plantmonitor)
- [ ] [Dades de Solargis de planta nova són al script a plantmonitor](#afegir-solargis)
- [ ] Dades apareixen al superset correctament

## Descripció de Dades


### Mapeig de senyals de Planta {#fitxer-mapeig-de-senyals}

Per cada planta, GdA genera fitxers amb informació de la planta per la seva gestió. Aquests fitxers contenen informació de senyals, aparells, plantes, etc. però sense el context del pipe de Jardiner. Com IT, portem aquesta informació al [fitxer de mapeig de senyals](#afegir-mapeig-airbyte) per a que el pipe de Jardiner pugui fer integrar les dades de la planta.

[Un exemple d'aquest fitxer pot ser aquest](https://docs.google.com/spreadsheets/d/1Fo1y_d2hks8Az9Bx4hzOrqVVNCwMf5t2/edit?gid=455448997#gid=455448997).


### Dades fixes de planta {#fitxer-dades-fixes-de-planta}

Aquest fitxer conté dades fixes de la planta, com ara la potència de la planta, la seva ubicació, etc. [Es trova a google drive](https://docs.google.com/spreadsheets/d/1Av9l0y--J4755JRMWL5kOSQlSY-c797X13CUqzfu3rw/edit?usp=sharing) i [es transforma amb airbyte aqui](https://airbyte.moll.somenergia.coop/workspaces/12f265b4-e398-44b4-9c95-1b5b165d6883/connections/e3301299-f721-4efb-b864-0e5b0233b145)

### Info API SolarGIS {#fitxer-info-api-solargis}

GdA ha de crear una entrada per la planta nova al [fitxer excel per això](https://docs.google.com/spreadsheets/d/1J2G6IuqIxIXT4ETG3vxVpryszs9Or_ss8NtMnGCJ6yw/edit#gid=0)

### Rendiment de planta {#fitxer-rendiment-de-planta}

Té un nom tipus `"Càlcul Rendiment de Planta <nom planta>"`. El podeu buscar al cercador de drive.

### Objectius de producció de planta {#fitxer-produccio-actual-de-planta}

Es troba al fitxer de [google sheets aqui](https://docs.google.com/spreadsheets/d/1VR5wQiHahicm9Q5mxVvzJUfBESYPGP5yvtLDf5NiMfc/edit#gid=2056763057) i es [transforma amb airbyte aqui](https://airbyte.moll.somenergia.coop/workspaces/12f265b4-e398-44b4-9c95-1b5b165d6883/connections/e5a12532-7c8b-4e12-a7ee-9b71f47c655a/status).

### Unificació Noms Projectes Generació {#fitxer-unificacio-noms-projectes-generacio}

Conté els llistat de noms unificats en un sol fitxer. Ves a [Unificació Noms Projectes Generació](https://docs.google.com/spreadsheets/d/1JwHmZ_FuIs7em8nLrdSNg052O_0IA9Fm1qGp_hz8QlU/edit#gid=0).

### Modelos contadores_inversores_SCADAS {#fitxer-modelos-contadores-inversores-scadas}

[Modelos contadores_inversores_SCADAS](https://docs.google.com/spreadsheets/d/1Z7_QpzestHBzVf9o78IC3hdGWMDH6dlyUr8f9LewO1o/edit#gid=904950265)

## Descripció de tasques

### Afegir dades al mapeig d'airbyte {#afegir-mapeig-airbyte}

Tenim un [document](https://docs.google.com/spreadsheets/d/1ybUXREO8cMaLMlV4Kt2iYyoNg2msirnbTTiYL2PBY2M/edit?gid=310640207#gid=310640207) on consolidem relacions entre UUIDs de senyals, aparells i plantes que inserim amb [airbyte](https://airbyte.moll.somenergia.coop/workspaces/12f265b4-e398-44b4-9c95-1b5b165d6883/connections/6ee76168-27ab-4ac4-9f50-b619664191db/status)

Aquest mapeig es una traducció del [fitxer de mapeigs](#fitxer-mapeig-de-senyals).

Un cop heu acabat de fer el mapeig, cal engegar la tasca de sync de l'airbyte d'uuids per que les dades arribin a la base de dades. Heu de tenir especial cura d'omplir les columnes `updated_at` i aquelles que posen UUIDs, ja que amb elles se creuen les dades dins del pipe.

!!! info "`update_at` s'actualitza automagicament"

    Al fitxer de google sheets hi ha un script que actualitza la columna `updated_at` quan hi ha hagut un canvi a nivell de fila. Es molt limitat i heu de supervisar que s'ha actualitzat correctament, ja que de vegades google sheets no ho fa. Podeu mirar a `Extensions > Apps Script` per veure el codi.

!!! warning "UUID són versió 4"

    Els senyals porten UUID4 (han de ser versio 4) únics al mapeig de la planta indicada. Es poden generar UUID4 amb <https://www.uuidgenerator.net/> O ben vé amb un script de python que podeu afegir a `~/.bash_aliases`:

    ```bash
    #·function·to·genenerate·random·uuid4·using·python$
    function pyuuid4() {
    python -c "import uuid$
    for _ in range(${N:-1}):
        print(uuid.uuid4())" ; }
    ```

    i el podeu executar amb `N=<n> pyuuid4` per a generar `n` UUID4.

    ```bash
    $ N=10 pyuuid4
    bf98707e-688c-471c-8700-9ffeaf436531
    8f6bfcc0-48bf-4b7c-895f-0b2efa37dd63
    ee5dcfd1-80ba-48fb-800d-5bc8c04d217f
    d32b0a23-c479-4ae9-bb54-43390fedf8e4
    eced945e-7a91-4451-bbd5-974a82c9c0d4
    fbacbf3d-23f6-4361-b5ec-b48b390d9c09
    b9c4ea66-672e-4dca-ad08-fddacdfb3627
    ae3e242e-9a57-4359-a72b-313a72b48348
    9e11a595-c32c-42e1-8549-a5161c0ea624
    172061ed-96b4-4aa3-b5bd-0c66e850383b
    ```


### Afegir planta per `meteologica` amb `plantmonitor` {#afegir-meteologica-plantmonitor}

!!! info "Què és `meteologica`?"

    `meteologica` és un servei que ens permet tenir dades meteorològiques de les plantes fotovoltaiques. Aquest servei es comunica amb `plantmonitor` per a obtenir dades de les plantes.

!!! info "Què és `plantmonitor`?"

    Tots els scripts en aquest apartat fan referència al repositori de github [`plantmonitor`](https://github.com/Som-Energia/plantmonitor/). És un projecte previ a `jardiner` que ens permet monitoritzar plantes fotovoltaiques quan l'obtenció de dades la gestionem nosaltres.

A `plantmonitor` tenim un script que ens permet afegir plantes noves. Aquest script s'ha de cridar amb un fitxer yaml que contingui les dades de la planta.

S'ha de crear la planta a la base de dades tant a la raspberrypi com a plantmonitor (no calen els dispositius, que els crea automàticament). Haureu d'afegir `plantlocation`, `plantparameters` i `moduleparameters`. Trobareu un exemple [a plantmonitor](https://github.com/Som-Energia/plantmonitor/blob/master/docs/2023-01-09-add_plantparameters_of_a_plant.md)

Un cop teniu el fitxer yaml, per exemple `data/plant-nova.yaml`, podeu cridar l'script `addPlant.py` amb el següent comandament:

```bash
PLANTMONITOR_MODULE_SETTINGS='conf.settings.prod' python addPlant.py data/plant-asomada.yaml
```

Haureu de tenir un fitxer `.env.prod` amb les variables d'entorn necessàries per a que l'script funcioni correctament. Mireu a la documentació de plantmonitor per a més informació.

De moment manualment cal afegir els registres de `plantestimatedmonthlyenergy`. L'any és irrellevant.
Si tenim històrics d'energia objectiu, els podeu afegir.

```sql
INSERT INTO
 public.plantestimatedmonthlyenergy(plantparameters, "time", monthly_target_energy_kwh)
VALUES
 (33, '2022-01-01 00:00:00+01', 473630),
 (33, '2022-02-01 00:00:00+01', 453370),
 (33, '2022-03-01 00:00:00+01', 592040),
 (33, '2022-04-01 00:00:00+02', 617000),
 (33, '2022-05-01 00:00:00+02', 667210),
 (33, '2022-06-01 00:00:00+02', 648940),
 (33, '2022-07-01 00:00:00+02', 703030),
 (33, '2022-08-01 00:00:00+02', 644500),
 (33, '2022-09-01 00:00:00+02', 574580),
 (33, '2022-10-01 00:00:00+02', 524110),
 (33, '2022-11-01 00:00:00+01', 446490),
 (33, '2022-12-01 00:00:00+01', 442060);
```

- Executar l’script d’alba i posta per a generar totes les albes i postes dels propers 10 anys

    ```bash
    python -m scripts.sun_events -p Alcolea -s 2021-12-13 -e 2021-12-14
    ```

- Afegir les dades al diccionari de solargis ([Veure com aqui](#afegir-solargis)). Quan deixi de ser hard-coded ja no caldrà aquest pas.

### Afegir planta al script de SolarGIS {#afegir-solargis}

S'ha de modificar el codi de plantmonitor per incloure la nova planta. Podeu trobar un exemple de modificacions [github](https://github.com/Som-Energia/plantmonitor/pull/40/commits/77aa3914905cce6d39062271085a633d8c6a1506)

Amb la MR aprovada i fusionada, s'ha de fer `git pull` des de el servidor de producció i reiniciar el servei de plantmonitor.

La API de SolarGIS requereix un token d'accés i es crida remotament amb `supervisord`, amb codi al repositori de [plantmonitor](https://github.com/Som-Energia/plantmonitor).

!!! info "L'API de SolarGIS és SOAP"

    [L'API es del tipus SOAP i no REST](https://www.redhat.com/es/topics/integration/whats-the-difference-between-soap-rest). És a dir, demana un XML amb les dades de la planta.


## Dades requerides per aparells

### Afegir Comptadors a l'ERP

Les lectures a l'ERP són necessaries mentre metelogica faci servir les lectures de comptadors que plantmonitor copia de l'ERP. També són necessàries per al [generationkwh](#generationkwh). Per això cal agafar les dades de [Modelos contadores_inversores_SCADAS](https://docs.google.com/spreadsheets/d/1Z7_QpzestHBzVf9o78IC3hdGWMDH6dlyUr8f9LewO1o/edit#gid=904950265) i afegir-les a l'erp Infrastructura -> Registradors -> tots els registradors.

- ip lan, port, porta d’enllaç i contrasenya
- telèfon, si s'escau

## Serveis de SomEnergia addicionals

### nagios

Preguntar a Gestió d'Actius si encara fan servir el nagios.
Si si, afegir-la al nagios o modificar-la en cas de canvi d’ip pública

### opendata

Cal afegir la info de la nova planta a taula literal que es fa servir a `somenergia-opendata/som_opendata/queries/plantpower.sql`. Un cop aquesta info estigui a plantmonitor, l’opendata podrà agafar-la directament per sql i no caldrà fer aquest pas.

### generationkwh {#generationkwh}

Si la planta està inclosa al generation, és important afegir-la a l’erp abans de la mitja nit del dia de posada a producció.
Si no, cal descartar càlculs de drets del generation per a que incloguin els resultats. Si, a més, els drets s’han començat a gastar (15 dies de marge de facturació), cal reperfilar els nous drets amb la producció afegida perquè no superi els drets ja atorgats.

La nova planta es crea fent servir l’script a [`somenergia-generationkwh/scripts/genkwh_plants.py`](https://github.com/Som-Energia/somenergia-generationkwh/blob/master/scripts/genkwh_plants.py)

Un exemple complert de com afegir una planta amb aquest script el podeu trobar a <https://github.com/Som-Energia/somenergia-generationkwh/blob/master/scripts/genkwh_migrate_plantmeter_1_7_0_newplant.sh>

Es recomana provar primer a un ERP de testing o local, i, després aplicar-ho a producció.

#### Reperfilació de dades

Un exemple d’script de migració en la que vam haver de reperfilar: <https://github.com/Som-Energia/somenergia-generationkwh/blob/master/scripts/genkwh_migrate_plantmeter_1_7_2_fontivsolarfix.sh>
