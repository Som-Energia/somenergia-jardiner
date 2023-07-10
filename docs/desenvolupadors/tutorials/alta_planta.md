Procediment a seguir a l’incorporar una nova planta fotovoltaica
================================================================

Dades
-----

Les dades necessàries per a donar d'alta una planta són

[Unificació Noms Projectes Generació](https://docs.google.com/spreadsheets/d/1JwHmZ_FuIs7em8nLrdSNg052O_0IA9Fm1qGp_hz8QlU/edit#gid=0)

Càlcul Rendiment de Planta_<nom planta> (buscar-ho al cercador de drive)

[Modelos contadores_inversores_SCADAS](https://docs.google.com/spreadsheets/d/1Z7_QpzestHBzVf9o78IC3hdGWMDH6dlyUr8f9LewO1o/edit#gid=904950265)

Xarxa
-----

1. Conectar-se a la ip  del router de la planta i afegir el port forwarding que calgui (raspberrypi o aparells)
2. Demanar a sistemes que afegeixi la planta al dns e.g. planta-<nom_planta>.somenergia.coop

Tot això ha de quedar escrit en el document Mapeig de Planta

Aparells
--------

**Comptador**

Agafar les dades de [Modelos contadores_inversores_SCADAS](https://docs.google.com/spreadsheets/d/1Z7_QpzestHBzVf9o78IC3hdGWMDH6dlyUr8f9LewO1o/edit#gid=904950265)

ip lan, port, porta d’enllaç i contrasenya

telèfon si s'escau

**Inversor**

ip

**Raspberrypi**

ip lan, usuari, password

Prèvia
------

Tots els scripts fan referència al repositori de github `plantmonitor`.

crear la planta a la base de dades tant a la raspberrypi com a plantmonitor (no calen els dispositius, que els crea automàticament),
afegir la plantlocation, plantparameters i moduleparameters. Un exemple [a plantmonitor](https://github.com/Som-Energia/plantmonitor/blob/master/docs/2023-01-09-add_plantparameters_of_a_plant.md)

```bash
PLANTMONITOR_MODULE_SETTINGS='conf.settings.prod' python addPlant.py data/plant-asomada.yaml
```


De moment manualment cal afegir els registres de plantestimatedmonthlyenergy. L'any és irrellevant.
Si tenim històrics d'energia objectiu, els podeu afegir.

```sql
  INSERT INTO public.plantestimatedmonthlyenergy(plantparameters, "time", monthly_target_energy_kwh) VALUES
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

si té raspberrypi:

escriure el modmap.yaml (TODO: unificar tots els modmaps a un de sol?)

Executar l’script d’alba i posta per a generar totes les albes i postes dels propers 10 anys

```bash
python scripts/sun_events.py -p Alcolea -s 2021-12-13 -e 2021-12-14
```

whitelistejar la ip pública al plantmonitor per a què pugui pujar lectures

Afegir les dades al diccionari de solargis (quan deixi de ser hard-coded ja no caldrà aquest pas)


Serveis de SomEnergia addicionals
---------------------------------

**nagios**
afegir-la al nagios o modificar-la en cas de canvi d’ip pública

**opendata**

Cal afegir la info de la nova planta a taula literal que es fa servir a somenergia-opendata/som_opendata/queries/plantpower.sql

(Un cop aquesta info estigui a plantmonitor, l’opendata podrà agafar-la directament per sql i no caldrà fer aquest pas)

**generationkwh**

Si la planta està inclosa al generation, és important afegir-la a l’erp abans de la mitja nit del dia de posada a producció.
Si no, cal descartar càlculs de drets del generation per a que incloguin els resultats. Si, a més, els drets s’han començat a gastar (15 dies de marge de facturació), cal reperfilar els nous drets amb la producció afegida perquè no superi els drets ja atorgats.

La nova planta es crea fent servir l’script: somenergia-generationkwh/scripts/genkwh_plants.sh

Un exemple complert de com afegir una planta amb aquest script: https://github.com/Som-Energia/somenergia-generationkwh/blob/master/scripts/genkwh_migrate_plantmeter_1_7_0_newplant.sh

Es recomana provar primer a un ERP de testing o local, i, després aplicar-ho a producció.

Un exemple d’script de migració en la que vam haver de reperfilar: https://github.com/Som-Energia/somenergia-generationkwh/blob/master/scripts/genkwh_migrate_plantmeter_1_7_2_fontivsolarfix.sh


