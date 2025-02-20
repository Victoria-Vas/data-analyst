--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select
	concat(last_name, ' ', first_name) Customer_name, 
	a.address, 
	c2.city, 
	c3.country 
from customer c
join address a on c.address_id = a.address_id
join city c2 on a.city_id = c2.city_id
join country c3 on c2.country_id = c3.country_id



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
select 
	s.store_id,
	count(*) 
from store s 
join customer c on s.store_id =c.store_id
group by s.store_id 


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.
--having
	
select 
	s.store_id, 
	count(c.customer_id) 
from store s 
join customer c on s.store_id =c.store_id
group by s.store_id
having count(c.customer_id)>300



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.
	
select 
	s.store_id, 
	count(c.customer_id), 
	concat(s2.last_name, ' ', s2.first_name),
	c2.city 
from store s 
join customer c on s.store_id =c.store_id
join staff s2 on s.store_id =s2.staff_id
join address a on s.address_id =a.address_id 
join city c2 on c2.city_id =a.city_id 
group by s.store_id, s2.staff_id, c2.city_id 
having count(c.customer_id)>300

--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select 
	concat(c.last_name, ' ', c.first_name) "Фамилия и имя покупателя",
	count(i.inventory_id) "Количество фильмов"
from customer c
join rental r on c.customer_id =r.customer_id
join inventory i on r.inventory_id =i.inventory_id 
group by c.customer_id 
order by count(i.inventory_id) desc
limit 5



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма
--customer, rental, inventory, payment

select
	concat(c.last_name, ' ', c.first_name) "Фамилия и имя покупателя",
	count(i.inventory_id) "Количество фильмов",
	sum(p.amount)::int "Общая стоимость платежей",
	min(p.amount) "Минимальный платеж",
	max(p.amount) "Максимальный платеж"
from customer c 
join rental r on c.customer_id = r.customer_id 
join payment p on r.rental_id  = p.rental_id
join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id


--ЗАДАНИЕ №5
--Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы 
--в результате не было пар с одинаковыми названиями городов. Решение должно быть через Декартово произведение.
	
 select 
 	distinct c1.city "Город 1", 
 	c2.city "Город 2" 
 from city c1, city c2
 where c1.city != c2.city and c1.city > c2.city

--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и 
--дате возврата (поле return_date), вычислите для каждого покупателя среднее количество 
--дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.

select 
	customer_id, 
	round(avg(return_date::date - rental_date::date), 2) 
from rental r 
group by r.customer_id 
order by r.customer_id 
