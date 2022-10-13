{{ config(materialized='view') }}



SELECT *
FROM
	(VALUES
    ('Riudarenes_SM', 10)
    ('Riudarenes_BR', 10)
    ('Riudarenes_ZE', 10)
    ('Picanya', 1)
    ('Manlleu_piscina', 4)
    ('Manlleu_pavello', 4)
    ('Lleida', 4)
    ('Torrefarrera', 4)
    ('Picanya', )
    

(2, 10) --'Riudarenes_SM')
(4, 10) --'Riudarenes_BR')
(5, 10) --'Riudarenes_ZE')
(9, 1) --'Picanya')
(10,) -- 'Torregrossa')
(11,) -- 'Valteina')
(1, ) --'Alcolea')
(3, ) --'Fontivsolar')
(14,4) -- 'Manlleu_Piscina')
(15,4) -- 'Manlleu_Pavello')
(17,) -- 'Torrefarrera')
(16,4) -- 'Lleida')
(6, ) --'Florida')
(7, ) --'Matallana')
(22,) -- 'Llanillos')
(13,) -- 'Terborg')



  ) h (hores)
WHERE 1 = 1


select * from VALUES()