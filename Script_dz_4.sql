--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.
create schema vasilchenko
set search_path to vasilchenko


--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ
create table language (
	language_id serial primary key,
	language_name varchar (50) not null unique)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into language (language_name)
values ('Русский'), ('Французский'), ('Японский'),('Английский'),('Немецкий')

select * from "language" 



--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table nationality (
	nationality_id serial primary key,
	nationality_name varchar (80) not null unique )


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

insert into nationality (nationality_name)
values ('Славяне'), ('Романоязычные'), ('Японцы'),('Кельты'),('Германцы')

select * from nationality 


--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

create table country (
	country_id serial primary key,
	country_name varchar (50) not null unique )

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert into country (country_name)
values ('Россия'), ('Германия'), ('Япония'),('Шотландия'),('Франция')

select * from country 
--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ язык-народность

create table language_nationality (
	language_id int references language(language_id),
	nationality_id int references nationality(nationality_id),
	primary key (language_id, nationality_id))


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
INSERT INTO language_nationality (language_id, nationality_id)
values (1,1),
	(1,2),
	(2,1),
	(2,2),
	(2,4),
	(3,3),
	(3,2),
	(3,5),
	(1,5),
	(5,1)
	
select * from language_nationality

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ народность-страна

create table nationality_country (
	nationality_id int references nationality(nationality_id),
	country_id int references country(country_id),
	primary key (nationality_id, country_id))

	
--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

INSERT INTO nationality_country (nationality_id, country_id)
values (1,1),
	(1,2),
	(1,5),
	(2,1),
	(2,2),
	(2,4),
	(3,3),
	(3,2),
	(3,5),
	(5,1)
	
select * from nationality_country
