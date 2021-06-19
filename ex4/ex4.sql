use movies

/*1. Напишете заявка, която за всеки филм,
по-дълъг от 120 минути, извежда
заглавие, година, име и адрес на студио. */
select title, year, name, address
from movie
join studio on studioname = name 
where length > 120

/*2. Напишете заявка, която извежда името
на студиото и имената на актьорите,
участвали във филми, произведени от
това студио, подредени по име на студио. */
select studioname, starname from movie
join starsin on title = movietitle
order by studioname

/*3. Напишете заявка, която извежда имената
на продуцентите на филмите, в които е
играл Harrison Ford. */
select distinct name from MOVIEEXEC
join movie on CERT# = PRODUCERC#
where title in (select movietitle from starsin where starname = 'Harrison Ford')

/* 4. Напишете заявка, която извежда имената
на актрисите, играли във филми на MGM.*/
select name from moviestar
where gender = 'f' and name in (select starname from starsin 
								where movietitle in (select title from movie where studioname = 'MGM'))

/* 5. Напишете заявка, която извежда името
на продуцента и имената на филмите,
продуцирани от продуцента на ‘Star
Wars’ */
select name, title from movie
join movieexec on PRODUCERC# = CERT#
where name in (select name from movieexec
				join movie on CERT# = PRODUCERC#
				where title = 'Star Wars')

/* 6. Напишете заявка, която извежда имената
на актьорите, които не са участвали в
нито един филм. */
select name from moviestar
left join starsin on name = starname
where movietitle is null

use pc

/* 1. За всеки модел компютри да се
изведат цените на различните
конфигурации от този модел.
Ако няма конфигурации за
даден модел, да се изведе
NULL. Резултатът да има две
колони: model и price.*/
select distinct product.model, price from product
left join pc on product.model = pc.model
where product.type = 'PC';

/*2. Напишете заявка, която извежда
производител, модел и тип на
продукт за тези производители,
за които съответният продукт не
се продава (няма го в таблиците
PC, Laptop или Printer). */
select product.model, maker, type from product 
left join (select model from pc
			union all
			select model from laptop
			union all
			select model from printer) t
	on product.model = t.model
where t.model is null

use ships
/* 1. Напишете заявка, която
за всеки кораб извежда
името му, държавата,
броя оръдия и годината
на пускане (launched).*/
select name, country, numguns, launched from ships
full join classes on ships.class = classes.class

/* 2. Напишете заявка, която
извежда имената на
корабите, участвали в
битка от 1942 г. */
select ship from outcomes
join battles on name = battle
where year(date) = 1942
