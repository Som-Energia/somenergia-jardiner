-- Test 2: Assregurem que efectgivament hi ha 288 rows per dia (5 minuts)
-- TODO: Treure dia d'avui + tenir en compte els dies cavni d'hora
SELECT *
FROM (
	SELECT
		time::date,
		inverter_id,
		count(*) as n
	FROM dbt_roger.inverterregistry_clean as ir
	group by time::date, inverter_id
) AS TAL
where n != 288