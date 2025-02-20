
--1.Отобразить сколько предложений сделал каждый из менеджеров за всю историю

SELECT 
    m."ID" AS Manager_ID,
    m."NAME" AS Manager_Name,
    COUNT(u."Manager_ID") AS Count_Offers
FROM 
    managers m 
LEFT JOIN 
    upsale u ON m."ID" = u."Manager_ID" 
GROUP BY 
    m."ID", m."NAME"
ORDER BY 
    Count_Offers DESC;


--2 Отобразить конверсию предложений в подключения для менеджеров за указанный период времени.
--Конверcия это отношение количества принятых предложений к общему количеству предложений


SELECT 
    m."ID" AS Manager_ID,
    m."NAME" AS Manager_Name,
    COALESCE(SUM(CASE WHEN u."RESULT"  = 'yes' THEN 1 ELSE 0 END), 0) AS accepted_offers,
    COALESCE(COUNT(u."RESULT"), 0) AS total_offers, 
    CASE 
        WHEN COUNT(u."RESULT") > 0 THEN 
            ROUND(COALESCE(SUM(CASE WHEN u."RESULT"  = 'yes' THEN 1 ELSE 0 END), 0) * 100.0 / COUNT(u."RESULT"), 2)
        ELSE 
            0
    END AS conversion_rate
FROM 
    managers m 
LEFT JOIN 
    upsale u ON m."ID" = u."Manager_ID"
WHERE 
    u."DT" BETWEEN '01.02.2017' AND '02.02.2017'
GROUP BY 
    m."ID", m."NAME"
ORDER BY 
    m."ID";



--3. Вывести конверсии тех менеджеров, у которых было больше 100 звонков за указанный период времени. 
   
   CREATE OR REPLACE VIEW manager_conversion AS
-- Создаем или заменяем представление manager_conversion
SELECT 
    m."ID" AS manager_id,
    m."NAME" AS manager_name,
    m."OFFICE",
    COALESCE(sub.accepted_offers, 0) AS accepted_offers,
    COALESCE(sub.total_offers, 0) AS total_offers,
    CASE 
        WHEN COALESCE(sub.total_offers, 0) > 0 THEN 
            ROUND(COALESCE(sub.accepted_offers, 0) * 100.0 / COALESCE(sub.total_offers, 1), 2) 
        ELSE 
            0
    END AS conversion_rate
FROM 
    managers m
LEFT JOIN (
    SELECT 
        u."Manager_ID",
        COUNT(u."ID") AS total_offers,
        SUM(CASE WHEN u."RESULT" = 'yes' THEN 1 ELSE 0 END) AS accepted_offers
    FROM 
        upsale u
    GROUP BY 
        u."Manager_ID"
) sub ON m."ID" = sub."Manager_ID";


   SELECT 
    u."Manager_ID",
    COUNT(u."CALL_ID") AS sum_call,
    mc.conversion_rate
FROM 
    manager_conversion mc
LEFT JOIN 
    upsale u ON mc."manager_id" = u."Manager_ID" 
GROUP BY 
    u."Manager_ID", mc.conversion_rate
HAVING 
    COUNT(u."CALL_ID") > 2;
   
   
 
--4 Вывести офисы, отсортированные в порядке убывания средней конверсии менеджеров из офиса за всю историю.  
   
   SELECT mc."OFFICE",
   			AVG(mc.conversion_rate) AS average_conversion_rate
FROM manager_conversion mc
group by mc."OFFICE"
ORDER by average_conversion_rate desc

SELECT 
    mc."OFFICE" AS office,
    AVG(mc.conversion_rate) AS average_conversion_rate
FROM 
    manager_conversion mc
GROUP BY 
    mc."OFFICE"
ORDER BY 
    average_conversion_rate DESC;

--5 Вывести минимальный порядковый номер звонка клиента с RESULT = Yes, перед которым был RESULT = No для каждого менеджера.

with cte1 as(
 SELECT u."Manager_ID", u."CALL_ID", u."RESULT", 
        LAG(u."RESULT") OVER (PARTITION BY u."Manager_ID" ORDER BY u."CALL_ID") AS previous_result
    FROM upsale u 
 )
 select m."ID",m."NAME", min(ct."CALL_ID")
 from managers m
 left join cte1 ct on m."ID" = ct."Manager_ID" and ct."RESULT" = 'yes' and ct.previous_result = 'no'
 group by m."ID", m."NAME"
 order by m."ID"
 
 WITH cte1 AS (
    SELECT 
        u."Manager_ID", 
        u."CALL_ID", 
        u."RESULT", 
        LAG(u."RESULT") OVER (PARTITION BY u."Manager_ID" ORDER BY u."CALL_ID") AS previous_result
    FROM 
        upsale u
)
SELECT 
    m."ID", m."NAME", MIN(ct."CALL_ID")
FROM 
    managers m
LEFT JOIN 
    cte1 ct ON m."ID" = ct."Manager_ID" AND ct."RESULT" = 'yes' AND ct.previous_result = 'no'
GROUP BY 
    m."ID", m."NAME"
ORDER BY 
    m."ID";

 ----6. Получить для каждого менеджера первое принятое предложение.

   SELECT DISTINCT
    m."ID" AS manager_id,
    m."NAME" AS manager_name,
    FIRST_VALUE(u."ID") OVER (PARTITION BY u."Manager_ID" ORDER BY u."DT"::DATE ASC) AS first_offer_id
FROM 
    managers m
LEFT JOIN 
    upsale u ON m."ID" = u."Manager_ID" AND u."RESULT" = 'yes'
ORDER BY 
    m."ID";
   
--7 вывести общее количество предложений для каждого менеджера на каждый месяц

SELECT 
    m."ID" AS manager_id,
    m."NAME" AS manager_name,
    EXTRACT(YEAR FROM u."DT"::DATE) AS year,
    EXTRACT(MONTH FROM u."DT"::DATE) AS month,
    COUNT(u."ID") AS total_offers
FROM managers m
LEFT JOIN upsale u ON m."ID" = u."Manager_ID"
GROUP BY m."ID", m."NAME", year, month
ORDER BY year, month, m."ID";

SELECT 
    m."ID" AS manager_id, 
    m."NAME" AS manager_name, 
    EXTRACT(YEAR FROM u."DT"::DATE) AS year, 
    EXTRACT(MONTH FROM u."DT"::DATE) AS month, 
    COUNT(u."ID") AS total_offers 
FROM 
    managers m 
LEFT JOIN 
    upsale u ON m."ID" = u."Manager_ID" 
GROUP BY 
    m."ID", 
    m."NAME", 
    year, 
    month 
ORDER BY 
    year, 
    month, 
    m."ID";


--8 наиболее эффективные предложения
SELECT 
    u."FACTOR_ID",
    COUNT(u."FACTOR_ID") AS successful_conversions
FROM upsale u
WHERE u."RESULT"  = 'yes'
GROUP BY u."FACTOR_ID"
ORDER BY successful_conversions DESC;

SELECT 
    u."FACTOR_ID",
    COUNT(u."FACTOR_ID") AS successful_conversions
FROM 
    upsale u
WHERE 
    u."RESULT" = 'yes'
GROUP BY 
    u."FACTOR_ID"
ORDER BY 
    successful_conversions DESC;
