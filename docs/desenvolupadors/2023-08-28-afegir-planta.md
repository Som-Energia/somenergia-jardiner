# Com afegir una planta (dset)

Una nova planta afegirà signals al paquet de dset amb llurs devices. Per tant cal

Anirem al directori [sincronització airbyte](https://drive.google.com/drive/folders/1xeGCcfYTTFo9p0cPEmi9RKT9e1HOWIlR?usp=drive_link) i omplir els tres documents

1. [] Mirar si ja és a [airbyte_Dades fixes de planta]()
2. [] Producció anual
3. [] Buscar el seu Mapeig de comunicacions al drive i posar un enllaç a [mapejos_plantes](https://drive.google.com/drive/u/0/folders/1LePhB83sKLQZ58onEluj4PyN_sjgD8aQ)
4. [] Modificar el csv `airbyte_signal_device_relation` copiant les columnes

    ```
    signal_description -> signal
    device_description -> device
    metric -> metric
    device_type -> device_type
    device_uuid -> device_uuid
    signal_uuid -> signal_uuid
    ```

    I copiant el plant i plant_uuid de les dades fixes, posant l'inserted_at a ara

5. [] Executar la tasca de sync de l'airbyte d'uuids
6. [] Executar `dbt snapshot`
7. [] Executar un `dbt build --target prod` o fer un push a main

El pas 2 executarà dbt seed, dbt run i dbt test i extreurà els nous devices de la signal_device_relation.

Com que ja no tenim ORM que verifiqui la integritat de les dades, tenim tests que compleixen aquesta funció.

Si algun senyal d'un device no té una definició igual de device (per uuid), els tests no passaran.
Per a veure quin senyal és el transgressor, executeu amb el flag `--store-failures`
i així guardarà el resultat de la query del test en una taula sota l'schema `<schema>_dbt_test__audit`

En particular, podeu veure `test_to_debug_device_uuid_errors` per verue les senyals que no quadren.
