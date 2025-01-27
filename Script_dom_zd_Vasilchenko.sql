--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.
select distinct city
from city

select count(distinct country_id)
from city

--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.
select distinct city
from city
where city ilike 'L%a' and not city like '% %'





--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.
select payment_id, payment_date, amount  
from payment p 
where payment_date::date between '17-06-2005' and '19-06-2005' and amount > 1.00
order by payment_date desc



--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.
select payment_id, payment_date, amount  
from payment p 
order by payment_date desc
limit 10



--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.
select concat(last_name, ' ', first_name) "Фамилия и имя",
	email "Электронная почта",
	character_length(email) "Длина Email", 
	last_update::DATE "Дата"
from customer




--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.
select lower(last_name), lower(first_name), active
from customer
where (first_name = 'KELLY' or first_name ='WILLIE') and active =1



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите информацию о фильмах, у которых рейтинг “R” и стоимость аренды указана от 
--0.00 до 3.00 включительно, а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.
select film_id, title, description, rating, rental_rate
from film
where (rating='R' and rental_rate between 0.00 and 3.00) or (rating='PG-13' and rental_rate>=4.00)




--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.
select film_id , title, description
from film
order by char_length(description) desc 
limit 3



--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.
select customer_id, email,
	split_part(email, '@',1) "Email Before @",
	split_part(email, '@',2) "Email After @"
from customer




--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква строки должна быть заглавной, остальные строчными.
--select customer_id, 
	--upper(substring(email from 1 for 1))||lower(substring(email from 2 for length(email)))
--from customer

select customer_id, 
	upper(substring((split_part(email, '@',1)) from 1 for 1))||lower(substring((split_part(email, '@',1)) from 2 for length((split_part(email, '@',1)))))  "Email Before @",
	upper(substring((split_part(email, '@',2)) from 1 for 1))||lower(substring((split_part(email, '@',2)) from 2 for length((split_part(email, '@',2)))))  "Email After @"
from customer

