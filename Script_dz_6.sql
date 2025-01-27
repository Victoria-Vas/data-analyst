--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes". 

select film_id, title, special_features
from film
where special_features @> array['Behind the Scenes']


--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.
--2.1
select film_id, title, special_features
from film
where 'Behind the Scenes' = any(special_features) 

--2.2
select film_id, title, special_features
from film
where special_features && array['Behind the Scenes']

--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes. -Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания. 

with cte as (
	select film_id, title, special_features
	from film f
	where special_features @> array['Behind the Scenes']
	)
select  
	r.customer_id, count(*) 
from rental r 
join inventory i ON i.inventory_id = r.inventory_id
join cte on cte.film_id  = i.film_id 
group by r.customer_id 
order by r.customer_id


--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".
--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

select  
	r.customer_id, count(*) 
from rental r 
join inventory i ON i.inventory_id = r.inventory_id
join 
	(
		select film_id, title, special_features
		from film f
		where special_features @> array['Behind the Scenes']
	) t on t.film_id  = i.film_id 
group by r.customer_id 
order by r.customer_id



--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view task_5 as 
	select  
		r.customer_id, count(*) 
	from rental r 
	join inventory i ON i.inventory_id = r.inventory_id
	join 
		(
			select film_id, title, special_features
			from film f
			where special_features @> array['Behind the Scenes']
		) t on t.film_id  = i.film_id 
	group by r.customer_id 
	order by r.customer_id
with no data

refresh materialized view task_5

select * from task_5

--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания:  
--поиск значения в массиве затрачивает меньше ресурсов системы; Ответ:@>,&& -меньше ресурсов.
--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.

Ответ:@>,&& -меньше ресурсов.


--6.1.1 --Seq Scan on film  (cost=0.00..67.50 rows=538 width=78) (actual time=0.058..2.232 rows=538 loops=1)
explain analyze
select film_id, title, special_features
from film
where special_features @> array['Behind the Scenes']


--6.2.1 --Seq Scan on film  (cost=0.00..77.50 rows=538 width=78) (actual time=0.049..1.254 rows=538 loops=1)
explain analyze
select film_id, title, special_features
from film
where 'Behind the Scenes' = any(special_features) 

--6.2.2 Seq Scan on film  (cost=0.00..67.50 rows=538 width=78) (actual time=0.041..1.552 rows=538 loops=1)
explain analyze
select film_id, title, special_features
from film
where special_features && array['Behind the Scenes']




--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.


Ответ: с использованием СТЕ меньше ресурсов


explain analyze --Sort  (cost=673.97..675.47 rows=599 width=10) (actual time=10.101..10.126 rows=599 loops=1)
with cte as (
	select film_id, title, special_features
	from film f
	where special_features @> array['Behind the Scenes']
	)
select  
	r.customer_id, count(*) 
from rental r 
join inventory i ON i.inventory_id = r.inventory_id
join cte on cte.film_id  = i.film_id 
group by r.customer_id 
order by r.customer_id

 --Sort  (cost=673.97..675.47 rows=599 width=10) (actual time=10.431..10.457 rows=599 loops=1)
explain analyze
select  
	r.customer_id, count(*) 
from rental r 
join inventory i ON i.inventory_id = r.inventory_id
join 
	(
		select film_id, title, special_features
		from film f
		where special_features @> array['Behind the Scenes']
	) t on t.film_id  = i.film_id 
group by r.customer_id 
order by r.customer_id
