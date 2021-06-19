use movies

/* 1. Напишете заявка, която
извежда имената на
актрисите, които са
също и продуценти с
нетна стойност, поголяма от 10 милиона.*/
select name from moviestar
where name in (select name from movieexec where NETWORTH > 10000000)

/*2. Напишете заявка, която
извежда имената на
тези филмови звезди,
които не са продуценти */
select name from moviestar 
where name not in (select name from MOVIEEXEC)

use pc

/*1. Напишете заявка, която извежда
производителите на персонални компютри с
честота на процесора поне 500 MHz.*/
select distinct maker from product 
join pc on product.model = pc.model
where pc.speed >= 500

/*2. Напишете заявка, която извежда лаптопите,
чиято честота на CPU е по-ниска от
честотата на който и да е персонален
компютър.*/
select * from laptop
where speed > any(select speed from pc)

/*3. Напишете заявка, която извежда модела на
продукта (PC, лаптоп или принтер) с найвисока цена. */
select model 
from (select model, price from pc
		union all
	  select model, price from printer
	    union all
	  select model, price from laptop) allproducts
where price >= all (select price from pc
		union all
	  select price from printer
	    union all
	  select price from laptop)

/*4. Напишете заявка, която извежда
производителите на цветните принтери с
най-ниска цена */
select * from printer
where color = 'y' and price <= all(select price from printer where color = 'y')

/* 5. Напишете заявка, която извежда
производителите на тези персонални
компютри с най-малко RAM памет, които
имат най-бързи процесори.*/
select distinct maker from product 
where model in (select model from pc pc1
				where pc1.ram <= all(select ram from pc)
				and pc1.speed >= all(select speed from pc pc2 where pc2.ram = pc1.ram)) 

use ships

/* 1. Напишете заявка, която извежда
страните, чиито класове кораби са с
най-голям брой оръдия*/
select distinct country from classes 
where numguns >= all(select numguns from classes)


/*2. Напишете заявка, която извежда
имената на корабите с 16-инчови
оръдия (bore). */
select name from ships
where name in (select name from ships
			   join classes on ships.class = classes.class
			   where bore = 16)

/* 3. Напишете заявка, която извежда
имената на битките, в които са
участвали кораби от клас ‘Kongo’.*/
select battle from outcomes
where ship in (select name from ships 
				where class = 'Kongo')

/* 4. Напишете заявка, която извежда
имената на корабите, чиито брой
оръдия е най-голям в сравнение с
корабите със същия калибър оръдия
(bore).*/
select name from ships
where name in (select name from ships 
				join classes p1 on ships.class = p1.class
				where p1.numguns >= all(select numguns from classes p2 where p1.bore = p2.bore)) 