-- Test 2: Assregurem que efectgivament hi ha 288 rows per dia (5 minuts)
-- TODO: Treure dia d'avui + tenir en compte els dies cavni d'hora
SELECT *
FROM (
	SELECT
		(time at time zone 'UTC')::date as day,
		inverter_id,
		count(*) as n
	FROM {{ ref('inverterregistry_clean') }} as ir
	group by (time at time zone 'UTC')::date, inverter_id
) AS TAL
where n != 288
and day between '2020-01-01' and current_date - interval '1 day'