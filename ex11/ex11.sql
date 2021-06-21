use movies
/* 1. Създайте изглед, който
извежда имената и
рождените дати на всички
актриси. */
GO
CREATE VIEW birthdays 
as 
	select name, birthdate from moviestar
	where gender = 'f'
GO

/*2. Създайте изглед, който за
всяка филмова звезда
извежда броя на филмите,
в които се е снимала. Ако
за дадена звезда не знаем
какви филми има, за нея да
се изведе 0. */

GO
create view actors as
select name, count(*) - count(distinct case when movietitle is null then 1 end)  as 'movies' from moviestar
left join starsin on name = starname
group by name
GO


use pc

/* 1. Създайте изглед, който
показва кодовете, моделите
и цените на всички лаптопи,
PC-та и принтери. Не
премахвайте повторенията. */GOcreate view tech as	select code, model, price from pc	union all	select code, model, price from printer	union all	select code, model, price from laptopGO/* 2. Променете изгледа, като
добавите и колона type (PC,
Laptop, Printer) */

GO 
alter view tech as
	select code, model, price, 'PC' as type from pc
	union all
	select code, model, price, 'Printer' as type from printer
	union all
	select code, model, price, 'Laptop' as type from laptop
GO

/* 3. Променете изгледа, като
добавите и колона speed,
която е NULL за принтерите */
GO 
alter view tech as
	select code, model, price, speed,  'PC' as type from pc
	union all
	select code, model, price, null as speed, 'Printer' as type from printer
	union all
	select code, model, price, speed, 'Laptop' as type from laptop
GO

use ships

/* 1. Дефинирайте изглед BritishShips, който извежда за всеки
британски кораб неговия клас, тип, брой оръдия, калибър,
водоизместимост и годината, в която е пуснат на вода. */

Go
create view BritishShips as
	select classes.class, type, numguns, bore, displacement, launched from classes
	join ships on classes.class = ships.class
GO

/* 2. Напишете заявка, която използва изгледа от предната
задача, за да покаже броя оръдия и водоизместимост на
британските бойни кораби (type = 'BB'), пуснати на вода
преди 1919. */
select numguns, displacement from BritishShips
where type = 'bb' and launched < 1919


/* 3. Напишете съответната SQL заявка, реализираща задача 2,
но без да използвате изглед. */
select numguns, displacement from classes
join ships on classes.class = ships.class
where type = 'bb' and LAUNCHED < 1919

/* 4. Средната стойност на displacement за най-тежките класове
кораби от всяка страна. */
GO
create view heaviest_ships as
select country, classes.class, avg(displacement) as 'displacement'
from classes
join ships on classes.class = ships.class
group by country, classes.class
GO

select country, max(displacement)
from heaviest_ships
group by country


/* 5. Създайте изглед за всички потънали кораби по битки */
Go
create view sunk_ships as
select count(*) as 'sunk' from outcomes
where result = 'sunk'
group by BATTLE
GO

select * from sunk_ships

/* 6. Въведете кораба California като потънал в битката при
Guadalcanal чрез изгледа от задача 5. За целта задайте
подходяща стойност по премълчаване на колоната result от
таблицата Outcomes. */

insert into sunk_ships(battle, ship)
values('Guadalcanal', 'California');
-- горното ще мине, ако няма ограничение NOT NULL за колоната result в Outcomes
select * from outcomes where result is null;
-- в условието на задачата се иска да зададем DEFAULT стойност на колоната
-- result, но ние няма да го правим - ще видим по-хубав начин с тригери :)

/* 7. Създайте изглед за всички класове с поне 9 оръдия.
Използвайте WITH CHECK OPTION. Опитайте се да
промените през изгледа броя оръдия на класа Iowa
последователно на 15 и на 5. */

Go
create view guns as 
	select class, numguns from classes
	where numguns > 9
	with check option
GO

select * from guns
/* при 5 гърми понеже не срещаме check option-a */
update guns
set numguns = 15
where class = 'Tennessee'

/* 8. Променете изгледа от задача 7, така че броят оръдия да
може да се променя без ограничения. */
drop view guns

Go
create view guns as 
	select class, numguns from classes
	where numguns > 9
GO

/*9. Създайте изглед с имената на битките, в които са участвали
поне 3 кораба с под 9 оръдия и от тях поне един е бил
увреден. */

GO
create view damaged_ships as
select ships.class, count(*) as 'num ships' 
from ships 
join classes on classes.class = ships.class 
where numguns < 9 and ships.class in (select class from ships where name in (select ship from outcomes where result = 'damaged'))
group by ships.class
having count(*) >= 3
GO








