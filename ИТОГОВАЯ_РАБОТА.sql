
--1 Выведите название самолетов, которые имеют менее 50 посадочных мест

select a.aircraft_code, count(s.seat_no) 
from aircrafts a 
join seats s on a.aircraft_code = s.aircraft_code
group by a.aircraft_code
having count(s.seat_no) < 50

--2 Выведите процентное изменение ежемесячной суммы бронирования билетов, округленной до сотых.


select date_trunc('month', book_date), sum(total_amount),
	   round(((sum(total_amount) - lag(sum(total_amount), 1) over (order by date_trunc('month', book_date))) / 
	   lag(sum(total_amount), 1) over (order by date_trunc('month', book_date)) * 100),2) 
from bookings 
group by date_trunc('month', book_date)
order by date_trunc('month', book_date)

--3. Выведите названия самолетов не имеющих бизнес - класс. Решение должно быть через функцию array_agg.
--можно использовать условие неравенства или отрицание NOT. неравно all


select a.aircraft_code, a.model
from (
	select aircraft_code, array_agg(fare_conditions order by aircraft_code)
		from seats
		group by aircraft_code
	 ) t1
join aircrafts a on a.aircraft_code=t1.aircraft_code
where 'Business' !=  all(t1.array_agg)


--5. Найдите процентное соотношение перелетов по маршрутам от общего количества перелетов.
 --Выведите в результат названия аэропортов и процентное отношение.
 --Решение должно быть через оконную функцию.

select  a.airport_name, a2.airport_name, count (*) / sum(count(*)) over () * 100 percent_ratio
from flights f  
	join airports a on a.airport_code = f.departure_airport
	join airports a2 on a2.airport_code =  f.arrival_airport
	group by a.airport_name, a2.airport_name	
		
--6. Выведите количество пассажиров по каждому коду сотового оператора, если учесть, что код оператора - это три символа после +7

select substring(contact_data->>'phone', 3, 3), count(passenger_id) 
from tickets
group by substring(contact_data->>'phone', 3, 3)
order by substring(contact_data->>'phone', 3, 3)


--7. Классифицируйте финансовые обороты (сумма стоимости перелетов) по маршрутам:
 --До 50 млн - low
 --От 50 млн включительно до 150 млн - middle
 --От 150 млн включительно - high
 --Выведите в результат количество маршрутов в каждом полученном классе


select amount_case, count(*)
from 
	( select
			case 
				when sum(tf.amount) < 50000000 then 'low'
				when sum(tf.amount) >= 50000000 and sum(tf.amount) < 150000000 then 'middle'
				else 'high'
			end	amount_case	
	from flights f 
	join ticket_flights tf on tf.flight_id =f.flight_id
	group by f.flight_no
		) t
group by amount_case



--8. Вычислите медиану стоимости перелетов, медиану размера бронирования и отношение медианы бронирования к медиане стоимости перелетов, округленной до сотых

--select * from bookings b 
--select * from ticket_flights tf 

select
  tf.tf_mediana,
  b.b_mediana,
  round(b.b_mediana ::numeric / tf.tf_mediana ::numeric, 2)
from 
  ( select PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) tf_mediana
    from ticket_flights 
  ) tf,
  ( select PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_amount) b_mediana
    from bookings
  ) b
