use movies

/*1. Напишете заявка,
която извежда имената
на актрисите,
участвали в Terms of
Endearment.*/
select starname from starsin
where movietitle = 'Terms of Endearment'

/*2. Напишете заявка,
която извежда имената
на филмовите звезди,
участвали във филми
на студио MGM през
1995 г. */
select starname from starsin
join movie on movietitle = title and movieyear = year
where studioname = 'MGM' and year = 1995

use pc 
/*1. Напишете заявка, която извежда производителя и
честотата на процесора на лаптопите с размер на
харддиска поне 9 GB */
select maker, speed from laptop
join product on product.model = laptop.model
where hd > 9

/* 2. Напишете заявка, която извежда номер на модел
и цена на всички продукти, произведени от
производител с име ‘B’. Сортирайте резултата
така, че първо да се изведат най-скъпите
продукти. */
select laptop.model, price from laptop
join product on product.model = laptop.model
where maker = 'B'
union
select pc.model, price from pc
join product on product.model = pc.model
where maker = 'B'
union
select printer.model, price from printer
join product on product.model = printer.model
where maker = 'B'

/*3. Напишете заявка, която извежда размерите на
тези харддискове, които се предлагат в поне два
компютъра. */
select distinct p1.hd from pc p1
join pc p2 on p1.hd = p2.hd
where p1.hd = p2.hd and p1.code != p2.code

/*4. Напишете заявка, която извежда всички двойки
модели на компютри, които имат еднаква честота
на процесора и памет. Двойките трябва да се
показват само по веднъж, например ако вече е
изведена двойката (i, j), не трябва да се извежда
(j, i)*/
select distinct pc1.model, pc2.model from pc pc1
join pc pc2 on pc1.speed = pc2.speed and pc1.ram = pc2.ram
where pc1.code < pc2.code

/*5. Напишете заявка, която извежда производителите
на поне два различни компютъра с честота на
процесора поне 1000 MHz.*/
select distinct maker from product 
join pc pc1 on product.model = pc1.model
join pc pc2 on product.model = pc2.model
where pc1.speed > 500 and pc1.code != pc2.code

use ships 

/*1. Напишете заявка, която извежда името
на корабите, по-тежки (displacement) от
35000.*/
select distinct name from ships
join classes on ships.class = classes.class
where DISPLACEMENT > 35000

/* 2. Напишете заявка, която извежда
имената, водоизместимостта и броя
оръдия на всички кораби, участвали в
битката при Guadalcanal.*/
select name, classes.displacement, classes.numguns from ships
join outcomes on ship = name
join classes on classes.class = ships.class
where battle = 'Guadalcanal'

/*3. Напишете заявка, която извежда
имената на тези държави, които имат
класове кораби от тип ‘bb’ и ‘bc’
едновременно. */
select p1.country from classes p1 
join classes p2 on p1.country = p2.country
where p1.type = 'bb' and p2.type = 'bc'

/*4. Напишете заявка, която извежда
имената на тези кораби, които са били
повредени в една битка, но по-късно са
участвали в друга битка. */
select distinct o1.ship
from outcomes o1 
join battles b1 on o1.battle = b1.name
join outcomes o2 on o1.ship = o2.ship
join battles b2 on o2.battle = b2.name
where o1.result = 'damaged' and b1.date < b2.date;
