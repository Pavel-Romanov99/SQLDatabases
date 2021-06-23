use movies

/* 1. Без повторение заглавията и годините на всички филми, заснети преди 1982, в които е играл
поне един актьор (актриса), чието име не съдържа нито буквата 'k', нито 'b'. Първо да се изведат
най-старите филми. */
select distinct movietitle, movieyear, starname
from starsin
where starname in (select distinct name from starsin
					 join moviestar on starname = name
			    	 where name not like '%k%' and name not like '%b%' and gender = 'm')
	  and movieyear < 1982
order by movieyear asc


/* 2. Заглавията и дължините в часове (length е в минути) на всички филми, които са от същата
година, от която е и филмът Terms of Endearment, но дължината им е по-малка или неизвестна. */
select title, (length / 60) as 'hours'
from movie
where year in (select year from movie where title = 'Terms of Endearment')
	  and length < any(select length from movie where title = 'Terms of Endearment')

/*3. Имената на всички продуценти, които са и филмови звезди и са играли в поне един филм
преди 1980 г. и поне един след 1985 г. */
select name from movieexec
where name in (select starname from starsin)
	  and name in (select starname from starsin where movieyear < 1980)
	  and name in (select starname from starsin where movieyear > 1985)

/*4. Всички черно-бели филми, записани преди най-стария цветен филм (InColor='y'/'n') на същото
студио. */

select m1.studioname, m1.year 
from movie m1, (select studioname, min(year) as 'year' from movie 
				where incolor = 'y'
				group by studioname) old
where m1.year < old.year and m1.STUDIONAME = old.STUDIONAME and m1.incolor = 'n'


/*5. Имената и адресите на студиата, които са работили с по-малко от 5 различни филмови звезди.
Студиа, за които няма посочени филми или има, но не се знае кои актьори са играли в тях, също
да бъдат изведени. Първо да се изведат студиата, работили с най-много звезди.
напр. ако студиото има два филма, като в първия са играли A, B и C, а във втория - C, D и Е, то
студиото е работило с 5 звезди общо */
select distinct name, count(distinct p.starname) + count(distinct case when p.starname is null then 1 end) as 'stars' from movie
join starsin p on title = p.movietitle
right join studio on name = studioname
group by name, studioname
having count(Distinct p.starname) < 5

use ships
/*6. За всеки кораб, който е от клас с име, несъдържащо буквите i и k, да се изведе името
на кораба и през коя година е пуснат на вода (launched). Резултатът да бъде сортиран
така, че първо да се извеждат най-скоро пуснатите кораби */
select name, launched 
from ships
where class not like '%i%' and class  not like '%k%'
order by launched desc


/*7. Да се изведат имената на всички битки, в които е повреден (damaged) поне един
японски кораб. */
select battle, count(*) as 'damaged ships'
from outcomes 
join ships on ship = name
join classes on	ships.class = classes.class
where result = 'damaged' and country = 'Japan'
group by battle

/* 8. Да се изведат имената и класовете на всички кораби, пуснати на вода една година след
кораба 'Rodney' и броят на оръдията им е по-голям от средния брой оръдия на
класовете, произвеждани от тяхната страна. */
select ships.class, name, p.numguns 
from ships
join classes p on ships.class = p.class
where launched + 1 in (select launched from ships where name = 'Rodney')
	and p.numguns > all (select avg(numguns) from classes where country = p.COUNTRY)

/* 9. Да се изведат американските класове, за които всички техни кораби са пуснати на вода
в рамките на поне 10 години (например кораби от клас North Carolina са пускани в
периода от 1911 до 1941, което е повече от 10 години, докато кораби от клас Tennessee
са пуснати само през 1920 и 1921 г.). */

select ships.class from classes
join ships on classes.class = ships.class
where country = 'USA'
group by ships.class
having max(launched) - min(launched) > 10

select * from classes
join ships on classes.class = ships.class

/*10. За всяка битка да се изведе средният брой кораби от една и съща държава (например в
битката при Guadalcanal са участвали 3 американски и един японски кораб, т.е.
средният брой е 2). */
select battle, avg(ships) as 'average ships'
from (select battle, country, count(*) as 'ships'
		from outcomes 
		join ships on ship = name
		join classes on classes.class = ships.class
		group by battle, country) t
group by battle


/*11. За всяка държава да се изведе: броят на корабите от тази държава; броя на битките, в
които е участвала; броя на битките, в които неин кораб е потънал ('sunk') (ако някоя от
бройките е 0 – да се извежда 0).*/


/*12. За всеки актьор/актриса изведете броя на различните студиа, с които са записвали филми. */
use movies

select starname, count(distinct studioname) as 'unique studios'
from starsin
join movie on title = movietitle
where starname in (select name from moviestar where gender = 'm')
group by starname

/*13. За всеки актьор/актриса изведете броя на различните студиа, с които са записвали филми,
включително и за тези, за които нямаме информация в какви филми са играли. */
select starname, count(distinct studioname)
from starsin
left join movie on title = movietitle and year = movieyear
where starname in (select name from moviestar where gender = 'f')
group by starname

/* 14. Изведете имената на актьорите, участвали в поне 3 филма след 1990 г */
select starname, count(*) as 'unique movies'
from starsin 
join movie on title = movietitle
where movieyear > 1990
group by starname
having count(*) >= 3

use pc
/*15. Да се изведат различните модели компютри, подредени по цена на най-скъпия конкретен
компютър от даден модел. */
select model, max(price) as 'prices'
from pc
group by model
order by 'prices' desc

use ships
/* 16. Изведете броя на потъналите американски кораби за всяка проведена битка с поне един
потънал американски кораб.*/
select battle, count(*) as 'sunk american ships'
from outcomes
where ship in (select name from ships join classes on classes.class = ships.class where country = 'USA')
	  and result = 'sunk'
group by battle
having count(*) >= 1

/* 17. Битките, в които са участвали поне 3 кораба на една и съща страна */
select battle, count(*) as 'ships same country' 
from outcomes
join ships on ship = name
join classes on classes.class = ships.class
group by battle, country
having count(*) >= 3

/*18. Имената на класовете, за които няма кораб, пуснат на вода след 1921 г., но имат пуснат поне
един кораб. */
select ships.class
from classes
join ships on classes.class = ships.class
where ships.class not in (select ships.class from classes join ships on classes.class = ships.class where launched > 1921)
group by ships.class
having count(*) >= 1

/*19. (*) За всеки кораб намерете броя на битките, в които е бил увреден. Ако корабът не е
участвал в битки или пък никога не е бил увреждан, в резултата да се вписва 0. */
select name, count(battle)
from ships
left join outcomes on name = ship and result = 'damaged'
group by name;

/* 20. (*) Намерете за всеки клас с поне 3 кораба броя на корабите от този клас, които са победили
в битка. result = ok*/
select class, count(distinct ship) -- повторения има, ако даден кораб е бил ok в няколко битки
from ships
left join outcomes on name = ship and result = 'ok'
group by class
having count(distinct name) >= 3; -- повторения има, ако даден кораб е бил ok в няколко битки
