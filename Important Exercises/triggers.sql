/*1. Добавете Брус Уилис в базата. Направете
така, че при добавяне на филм, чието
заглавие съдържа “save” или “world”, Брус
Уилис автоматично да бъде добавен като
актьор, играл във филма. */
use movies

insert into moviestar(name)
values('Bruce Willis')

GO
create trigger tr1
on movie
after INSERT
AS
    insert into starsin(movietitle, movieyear, starname)
    select title, year, 'Bruce Willis'
    from inserted
    where title like '%save%' or title like '%world%'
GO

insert into movie(title, year)
values('World of pizza ', 2000)

select * from starsin

/*2. Да се направи така, че да не е възможно
средната стойност на Networth да е помалка от 500 000 (ако при промени в
таблицата MovieExec тази стойност стане
по-малка от 500 000, промените да бъдат
отхвърлени). */
drop trigger tr1

GO
create trigger tr1
on movieexec
after update, delete, insert
AS
    if(select avg(networth) from MOVIEEXEC) > 500000
    BEGIN
    RAISERROR('average networth cannot be over 500k', 16, 10)
    ROLLBACK
    END
GO
drop trigger tr1


/*3. MS SQL не поддържа ON DELETE SET
NULL. Да се реализира с тригер за
външния ключ Movie.producerc#. */
drop trigger tr1

GO
create trigger tr1
on movieexec
after DELETE
AS
    update movie
    set PRODUCERC# = null
    where PRODUCERC# in (select cert# from deleted)
GO

/*4. При добавяне на нов запис в StarsIn, ако
новият ред указва несъществуващ филм
или актьор, да се добавят липсващите
данни в съответната таблица
(неизвестните данни да бъдат NULL).
Внимание: има външни ключове! */
drop trigger tr1

GO
create trigger tr1
on starsin
instead of insert
AS
    insert into moviestar(name)
    select starname from inserted
    where starname not in (select name from moviestar)

    insert into movie(title, year)
    select movietitle, movieyear from inserted
    where movietitle not in (select title from movie)
        and movieyear not in (select year from movie)

    insert into starsin
    select * from inserted
GO

use pc
/*1. Да се направи така, че при изтриване на лаптоп на
производител D автоматично да се добавя PC със
същите параметри в таблицата с компютри. Моделът на
новите компютри да бъде ‘1121’, CD устройството да
бъде ‘52x’, а кодът - със 100 по-голям от кода на лаптопа. */
GO
create trigger tr1
on laptop
after DELETE
AS
    insert into pc
    select code + 100, '1211', speed, ram, hd, 'x52', price 
    from deleted 
    where model in (select model from product where maker = 'D')
GO

/*2. При промяна на цената на някой компютър се уверете, че
няма по-евтин компютър със същата честота на
процесора. */
GO
create trigger tr1
on pc 
after UPDATE
AS
    if exists(select * from pc where speed = (select speed from inserted)
              and price < (select price from inserted))
    BEGIN
    RAISERROR('cant have a cheaper pc', 16, 10)
    ROLLBACK
    END
GO

drop trigger tr1

/*3. Никой производител на компютри не може да произвежда
и принтери. */
GO
create trigger tr1
on product
after update, INSERT
AS
    if exists(select * from product p1
             join product p2 on p1.maker = p2.maker
             where p1.type = 'PC' and p2.type = 'Printer')
    BEGIN
    RAISERROR('cannot have a pc and printer from the same maker', 16, 10)
    ROLLBACK
    END
GO
drop trigger tr1

/*4. Всеки производител на компютър трябва да произвежда и
лаптоп, който да има същата или по-висока честота на
процесора. */
GO
create trigger tr1
on pc 
after update, INSERT
AS
    if exists(select * from pc p1
        where p1.speed < (select price from laptop l 
        where (select maker from product where model = p1.model) 
        = (select maker from product where model = l.model)))
    BEGIN
    RAISERROR('error', 16,10)
    ROLLBACK
    END
Go

/* 5. При промяна на данните в таблицата Laptop се уверете,
че средната цена на лаптопите за всеки производител е
поне 2000. */
GO
create trigger tr1
on laptop
after UPDATE
AS
    if exists(select * from laptop
            join product on product.model = laptop.model
            group by maker
            having avg(price) < 2000)
    begin 
    RAISERROR('cant have average price under 2000', 16, 10)
    ROLLBACK
    END
GO

select * from laptop

/*6. Ако някой лаптоп има повече памет от някой компютър,
трябва да бъде и по-скъп от него. */
drop trigger tr1

GO
CREATE TRIGGER tr1
on Laptop
after update, INSERT
as 
    if exists(select * from laptop l
             where l.price < any(select price from pc where l.ram > ram))
    BEGIN
    RAISERROR('cannot have a cheaper laptop with the same memory', 16,10)
    ROLLBACK
    END
GO

drop trigger tr1


/*7. Да приемем, че цветните матрични принтери (type =
'Matrix') са забранени за продажба. При добавяне на
принтери да се игнорират цветните матрични. Ако с една
заявка се добавят няколко принтера, да се добавят само
тези, които не са забранени, а другите да се игнорират. */
go 
create trigger tr1
on printer
instead of insert
AS
    insert into printer
    select * from inserted
    where color != 'y'
GO
drop trigger tr1

use ships

/*1. Ако бъде добавен нов клас с
водоизместимост по-голяма от 35000,
класът да бъде добавен в таблицата, но да
му се зададе водоизместимост 35000. */
GO
create trigger tr1
on classes
after insert
as
    if(select distinct displacement from inserted) > 35000
    BEGIN
    update CLASSES
    set DISPLACEMENT = 35000
    where class = (select class from inserted)
    end
GO
drop trigger tr1

/* 2. Създайте изглед, който показва за всеки
клас името му и броя кораби (евентуално
0). Направете така, че при изтриване на
ред да се изтрие класът и всички негови
кораби.*/
GO
create view ships_view
AS
select CLASSES.CLASS, count(name) as 'ships' from CLASSES
left join ships on CLASSES.CLASS = ships.CLASS
group by CLASSES.CLASS
GO

CREATE TRIGGER tr1
on ships_view
instead of DELETE
as 
    delete from CLASSES
    where class in (select class from deleted)

    delete from ships
    where class in (select class from deleted)
GO


/*3. Никой клас не може да има повече от два
кораба. */
GO
create trigger tr1
on ships
after insert,update
AS
    if exists(select class from ships
             group by CLASS
             having count(name) > 2)
    BEGIN
    RAISERROR('cant have a class with more than two ships', 16, 10)
    ROLLBACK
    END
GO

/*4. Кораб с повече от 9 оръдия не може да
участва в битка с кораб, който е с помалко от 9 оръдия. Напишете тригер за
Outcomes. */
GO
create trigger tr1
on outcomes
after update, insert
AS
    if exists(select s.ship from outcomes s
             join outcomes s2 on s.battle = s2.BATTLE
             where s.ship in 
             (select name from ships join classes on classes.class = ships.class
             where numguns > 9) and
             s2.ship in (select name from ships join classes on classes.class = ships.class
             where numguns < 9))
    BEGIN
    RAISERROR('there is an error', 16, 10)
    ROLLBACK
    END
GO
