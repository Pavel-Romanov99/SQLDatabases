use pc

/* 1. Напишете заявка, която извежда средната честота на процесорите на
компютрите.*/
select avg(speed) as 'average speed'
from pc

/*2. Напишете заявка, която за всеки производител извежда средния
размер на екраните на неговите лаптопи. */
select maker,  avg(screen) as 'screen size'
from product 
join laptop on product.model = laptop.model
group by maker

/* 3. Напишете заявка, която извежда средната честота на лаптопите с
цена над 1000.*/
select avg(speed) as 'speed'
from laptop
where price > 1000

/*4. Напишете заявка, която извежда средната цена на компютрите,
произведени от производител ‘A’. */
select avg(price) as 'price'
from pc 
join product on pc.model = product.model
where maker = 'A'

/*5. Напишете заявка, която извежда средната цена на компютрите и
лаптопите на производител ‘B’ (едно число). */ 
select avg(price)
from  (
select price from pc 
join product on pc.model = product.model
where maker = 'B'
		union all 
select price from laptop
join product on laptop.model = product.model
where maker = 'B') 
allprices;

/* 6. Напишете заявка, която извежда средната цена на компютрите
според различните им честоти на процесорите.*/
select speed, avg(price)
from pc
group by speed

/*7. Напишете заявка, която извежда производителите, които са
произвели поне по 3 различни модела компютъра. */
select maker 
from product 
where type = 'PC'
group by maker
having count(product.model) > 2

/*8. Напишете заявка, която извежда производителите на компютрите с
най-висока цена. */
select maker
from product 
join pc on product.model = pc.model
where price >= all(select price from pc)


/*9. Напишете заявка, която извежда средната цена на компютрите за
всяка честота, по-голяма от 800 MHz. */
select speed, avg(price) as 'price'
from pc 
where speed > 800
group by speed

/* 10. Напишете заявка, която извежда средния размер на диска на тези
компютри, произведени от производители, които произвеждат и
принтери.*/
select avg(hd) as 'disk'
from pc
join product on pc.model = product.model
where product.maker in (select distinct maker from product
where type = 'PC') and product.maker in (select distinct maker from product where type = 'Printer')

/*11. Напишете заявка, която за всеки размер на лаптоп намира
разликата в цената на най-скъпия и най-евтиния лаптоп със същия
размер. */
select screen, MAX(price) - MIN(price) as diff
from laptop
group by screen

use ships
/*1. Напишете заявка, която извежда броя на
класовете кораби*/
select count(*) from classes


/* 2. Напишете заявка, която извежда средния
брой на оръдията (numguns) за всички
кораби, пуснати на вода (т.е. изброени са в
таблицата Ships).*/
select avg(numguns)
from classes
join ships on classes.class = ships.class

/* 3. Напишете заявка, която извежда за всеки
клас първата и последната година, в която
кораб от съответния клас е пуснат на вода.*/
select ships.class, max(year(launched)), min(year(launched))
from ships
group by class

/*4. Напишете заявка, която за всеки клас
извежда броя на корабите, потънали в
битка.*/
select class, count(*) as 'sunk ships'
from ships 
join outcomes on name = ship
where result = 'sunk'
group by class

/*5. Напишете заявка, която за всеки клас с
над 4 пуснати на вода кораба извежда
броя на корабите, потънали в битка. */
select class
from ships 
join outcomes on ship = name
group by class
having count(*) >= 4

select class, count(*) as 'sunk'
from ships 
join outcomes on ship = name
where class in (select class
					from ships 
					group by class
					having count(*) > 4) and result = 'sunk'
group by class

/* 6. Напишете заявка, която извежда средното
тегло на корабите (displacement) за всяка
страна. */
select country, avg(displacement) as 'average displacement'
from classes
group by country


use movies
/*За всеки актьор/актриса изведете броя на различните студиа, с които са записвали филми.
Включете и тези, за които няма информация в кои филми са играли. */



/* */
/* */
/* */
/* */
/* */
/* */
/* */
/* */

/* */