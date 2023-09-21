-- to generate the seed for plants_descriptions.csv
SELECT
    p.id AS plant_id,
    p.name AS plant_name,
    p2.latitude AS latitude,
    p2.longitude AS longitude,
    p3.connection_date AS connection_date,
    FALSE AS is_tilted,
    p3.peak_power_w / 1000 AS peak_power_kw,
    p3.nominal_power_w / 1000 AS nominal_power_kw,
    CASE
        WHEN p.name = 'Torregrossa' THEN 'GAS'
        WHEN p.name = 'Valteina' THEN 'HIDRO'
        ELSE 'FV'
    END AS technology,
    p3.target_monthly_energy_wh / 100 AS target_monthly_energy_gwh,
    CASE
        WHEN
            p.name IN ('Florida', 'Alcolea', 'Matallana') THEN 'energes'
        WHEN
            p.name IN ('Valteina') THEN 'energetica'
        WHEN
            p.name IN ('Fontivsolar') THEN 'ercam'
        WHEN
            p.name IN ('Llanillos', 'Asomada') THEN 'exiom'
    END AS propietari
FROM
    public.plant AS p
LEFT JOIN
    public.plantparameters AS p3
    ON
        p.id = p3.plant
LEFT JOIN
    public.plantlocation AS p2
    ON
        p.id = p2.plant
WHERE
    "description" != 'SomRenovables'
ORDER BY
    p.id;
