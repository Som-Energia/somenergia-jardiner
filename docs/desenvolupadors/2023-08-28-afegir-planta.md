# Com afegir una planta (dset)

Una nova planta afegirà signals al paquet de dset amb llurs devices. Per tant cal

1. [] Modificar el csv `signal_device_relation`
2. [] Executar `dbt build -s signal_device_relation devices`

El pas 2 executarà dbt seed, dbt run i dbt test i extreurà els nous devices de la signal_device_relation.

Com que ja no tenim ORM que verifiqui la integritat de les dades, tenim tests que compleixen aquesta funció.

Si algun senyal d'un device no té una definició igual de device (per uuid), els tests no passaran.
Per a veure quin senyal és el transgressor, executeu amb el flag `--store-failures`
i així guardarà el resultat de la query del test en una taula sota l'schema `<schema>_dbt_test__audit`

En particular, podeu veure `test_to_debug_device_uuid_errors` per verue les senyals que no quadren.
