use movies

/*1. Да се добави информация за
актрисата Nicole Kidman. За
нея знаем само, че е родена
на 20-и юни 1967.*/
begin transaction

insert into moviestar(name, BIRTHDATE)
values('Nicole Kidman', '06-20-1967')

select * from moviestar

rollback transaction


/* 2. Да се изтрият всички
продуценти с печалба
(networth) под 10 милиона.) под 10 милиона. */
begin transaction

delete from movieexec
where NETWORTH < 10000000

rollback transaction

/*3. Да се изтрие информацията
за всички филмови звезди, за
които не се знае адресът. */
begin transaction

delete from moviestar 
where address is null

rollback transaction

/*4. Да се добави титлата „Pres.“ Pres.“
пред името на всеки
продуцент, който е и
президент на студио.  */
begin transaction

update MOVIEEXEC
set name = 'Pres.' + name
where cert# in (select presc# from studio)

rollback transaction

use pc
/* 1. Използвайки две INSERT заявки, съхранете в базата от данни
факта, че персонален компютър модел 1100 е направен от
производителя C, има процесор 2400 MHz, RAM 2048 MB,
твърд диск 500 GB, 52x DVD устройство и струва $299. Нека
новият компютър има код 12. Забележка: моделът и CD са от
тип низ.
Упътване: самото вмъкване на данни е очевидно как ще стане, помислете в какъв ред е пологично да са двете заявки. */
begin transaction

insert into product
values('C', '1100', 'PC')

insert into pc
values(12, '1100', 2400, 2048, 5, '52x', 299)

rollback transaction

/*2. Да се изтрие всичката налична информация за компютри
модел 1100. */
begin transaction 

delete from pc
where model = '1100'

rollback transaction

/*3. За всеки персонален компютър се продава и 15-инчов лаптоп
със същите параметри, но с $500 по-скъп. Кодът на такъв
лаптоп е със 100 по-голям от кода на съответния компютър.
Добавете тази информация в базата.*/
begin transaction

insert into product (model, maker, type)
select distinct model, 'Z', 'Laptop'
from pc;

-- ето това е очакваното решение на задачата:
insert into laptop(code, model, speed, ram, hd, price, screen)
select code+100, model, speed, ram, hd, price+500, 15
from pc;

rollback transaction

/*4. Да се изтрият всички лаптопи, направени от производител,
който не произвежда принтери. */
begin transaction

delete from laptop
where model in (select model from product where type = 'Laptop' and type not in (select type from product where type = 'Printer'))


rollback transaction


/*5. Производител А купува производител B. На всички продукти
на В променете производителя да бъде А. */
begin transaction

update product
set maker = 'A'
where maker = 'B'

select * from product

rollback

/* 6. Да се намали два пъти цената на всеки компютър и да се
добавят по 20 GB към всеки твърд диск. Упътване: няма нужда
от две отделни заявки. */
begin transaction

update pc
set price = price / 2 , hd = hd + 20

rollback transaction

/* 7. За всеки лаптоп от производител B добавете по един инч към
диагонала на екрана. */
begin transaction

update laptop
set screen = screen + 1
where model in (select model from product where maker = 'B')

rollback transaction

use ships
/*1. Два британски бойни кораба (type = 'bb') от
класа Nelson - Nelson и Rodney - са били
пуснати на вода едновременно през 1927 г.
Имали са девет 16-инчови оръдия (bore) и
водоизместимост от 34 000 тона
(displacement). Добавете тези факти към
базата от данни. */
insert into CLASSES
values ('Nelson', 'bb', 'Gt.Britain', 9, 16, 34000),
	   ('Rodney', 'bb', 'Gt.Britain', 9, 16, 34000)


/* 2. Изтрийте от Ships всички кораби, които са
потънали в битка. */
begin transaction

delete from ships
where name in (select ship from outcomes where result = 'sunk')

rollback transaction

/*3. Променете данните в релацията Classes така,
че калибърът (bore) да се измерва в
сантиметри (в момента е в инчове, 1 инч ~
2.54 см) и водоизместимостта да се измерва в
метрични тонове (1 м.т. = 1.1 т.) */
begin transaction 

update classes
set bore = bore * 2.54, displacement = displacement * 1.1

rollback

/*4. Изтрийте всички класове, от които има помалко от три кораба. */
begin transaction

delete from classes
where class in (select class from ships group by class having count(*) < 3)

rollback
	
/* 5. Променете калибъра на оръдията и
водоизместимостта на класа Iowa, така че да
са същите като тези на класа Bismarck. */
begin transaction

update classes
set bore = (select bore from classes where class = 'Bismarck'), 
	displacement = (select displacement from classes where class = 'Bismarck')
where class = 'Iowa'

select * from classes

rollback
