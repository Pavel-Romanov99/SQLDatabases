use movies

/* 1. Добавете Брус Уилис в базата. Направете
така, че при добавяне на филм, чието
заглавие съдържа “save” или “world”, Брус
Уилис автоматично да бъде добавен като
актьор, играл във филма. */

insert into moviestar(name, address, gender, birthdate)
values('Bruce Willis', 'Los angeles', 'm', getdate())

GO
create trigger tr1 
on movie 
after insert 
as
	insert into starsin(movietitle, movieyear, starname)
	select title, year, 'Bruce Willis'
	from inserted
	where title like '%save%' or title like '%world%'
GO

insert into movie(title, year)
values('Save the world', 1999)

select * from starsin

drop trigger tr1

/* 2. Да се направи така, че да не е възможно
средната стойност на Networth да е помалка от 500 000 (ако при промени в
таблицата MovieExec тази стойност стане
по-малка от 500 000, промените да бъдат
отхвърлени). */
use movies

GO
create trigger t1
on movieexec
after update, insert, delete
as
	if(select avg(networth) from movieexec ) < 500000
	begin
		raiserror('Error: Average networth cannot be < 500000', 16, 10);
        rollback;
    end;
GO

drop trigger t1

/* 3. MS SQL не поддържа ON DELETE SET
NULL. Да се реализира с тригер за
външния ключ Movie.producerc#. */
GO
create trigger t2
on movieexec
instead of delete /*not after because of foreign key */
as
	update movie
	set PRODUCERC# = null
	where PRODUCERC# in (select cert# from deleted)
GO

drop trigger t2
/* 4. При добавяне на нов запис в StarsIn, ако
новият ред указва несъществуващ филм
или актьор, да се добавят липсващите
данни в съответната таблица
(неизвестните данни да бъдат NULL).
Внимание: има външни ключове! */
GO
create trigger tr1
on starsin
instead of insert
as
	insert into moviestar(name)
	select distinct starname 
	from inserted
	where starname not in (select name from moviestar)

	insert into movie(title, year)
	select movietitle, movieyear
	from inserted
	where movietitle not in (select title from movie where movietitle = title and movieyear = year)

	insert into starsin
	select * from inserted
GO

insert into starsin(movietitle, movieyear, starname)
values('American Pie 2', 2001, 'Slaveiko')

drop trigger tr1

use pc

/* 1. Да се направи така, че при изтриване на лаптоп на
производител D автоматично да се добавя PC със
същите параметри в таблицата с компютри. Моделът на
новите компютри да бъде ‘1121’, CD устройството да
бъде ‘52x’, а кодът - със 100 по-голям от кода на лаптопа. */

GO
create trigger tr1
on laptop
after delete
as
	insert into pc
	select code + 100, '1121', speed, ram, hd, '52x', price
	from deleted
	where model in (select model from product where maker = 'D')
GO
		

/* 2. При промяна на цената на някой компютър се уверете, че
няма по-евтин компютър със същата честота на
процесора. ---------------------------------------------------------------------------*/
GO
create trigger tr1
on pc
instead of update
as
	if(select price from inserted) <= all(select p.price from pc p where p.speed = speed)
	begin
		update pc
		set price = (select distinct price from inserted)
		where model = (select distinct model from inserted)
	end
GO
drop trigger tr1

/* 3. Никой производител на компютри не може да произвежда
и принтери. */

use pc;
GO
create trigger t
on product
after insert, update
as
if exists  (select *  
            from Product p1
            join Product p2 on p1.maker = p2.maker
            where p1.type = 'PC' and p2.type = 'Printer')
begin
    raiserror('...', 16, 10);
    rollback;
end;
GO

drop trigger t2

/* 4. Всеки производител на компютър трябва да произвежда и
лаптоп, който да има същата или по-висока честота на
процесора. */
GO
create trigger t
on pc
instead of insert, update
as
	if exists(select p.model from pc p
			 where p.speed < any(select l.speed from laptop l where 
				(select distinct maker from product where model = p.model) = (select distinct maker from product where model = l.model)))
		begin
		raiserror('---', 16,10)
		rollback
end 
GO

/* 5. При промяна на данните в таблицата Laptop се уверете,
че средната цена на лаптопите за всеки производител е
поне 2000. */
GO
create trigger tr
on laptop
instead of update
as
	if exists(select maker from (
					select maker
					from product 
					join pc on product.model = pc.model
					group by maker
					having avg(price) < 2000) t)
	begin
		raiserror('---',16,10)
		rollback
end
GO


/* 6. Ако някой лаптоп има повече памет от някой компютър,
трябва да бъде и по-скъп от него. */
GO
create trigger tr12
on laptop
instead of update, delete
as
	if exists(select * from laptop l where l.price < any(select price from pc where l.ram > ram))
	begin
		raiserror('a laptop cannot be cheaper than a pc with the same memory',16,10)
		rollback
	end
GO


/* 7. Да приемем, че цветните матрични принтери (type =
'Matrix') са забранени за продажба. При добавяне на
принтери да се игнорират цветните матрични. Ако с една
заявка се добавят няколко принтера, да се добавят само
тези, които не са забранени, а другите да се игнорират. */
Go
create trigger t27
on printer
instead of insert  
AS  
    insert into printer 
    select *
    from inserted
    where color != 'y' or type != 'Matrix';
Go

use ships
/* 1. Ако бъде добавен нов клас с
водоизместимост по-голяма от 35000,
класът да бъде добавен в таблицата, но да
му се зададе водоизместимост 35000. */
GO
create trigger tr1
on classes
instead of insert
as
	if(select distinct displacement from inserted) > 35000
	begin
		insert into classes
		select class, type, country, numguns, bore, 35000
		from inserted
	end
GO

insert into classes
values('LOL', 'bb', 'Bulgaria', 10, 12, 80000)

select * from classes

/* 2. Създайте изглед, който показва за всеки
клас името му и броя кораби (евентуално
0). Направете така, че при изтриване на
ред да се изтрие класът и всички негови
кораби. */
GO
create view sh
as
select classes.class, count(ships.name) as 'number of ships'
from classes
left join ships on classes.class = ships.class
group by classes.class
GO

create trigger tr1
on sh
instead of delete
as
	delete from classes 
	where class = (select distinct class from deleted)

	delete from ships
	where class = (select distinct class from deleted)
GO

delete from sh where class = 'LOL'

select * from classes

/* 3. Никой клас не може да има повече от два
кораба. */
drop trigger tr1
GO
create trigger tr1
on ships
instead of update, insert
as
	if exists(select class from ships 
			  group by class
			  having count(name) > 2)
	begin
		raiserror('Cant have more than two ships', 16, 10)
		rollback
	end
GO

select * from ships

insert into ships(name, class, launched)
values('Bulgaria', 'Kongo', 2021)

/* 4. Кораб с повече от 9 оръдия не може да
участва в битка с кораб, който е с помалко от 9 оръдия. Напишете тригер за
Outcomes. */
drop trigger tr1
Go
create trigger tr1
on outcomes
instead of insert, update
as
	if exists(select * from outcomes p1 where p1.ship in (select name from ships 
														 join classes on classes.class = ships.class
														 where numguns > 9)
											  and p1.battle = (select p2.battle from outcomes p2 
															  where p1.ship in (select name from ships 
															  join classes on classes.class = ships.class
														      where numguns < 9)))
		begin
		raiserror('Cant have these two ships in the same battle', 16, 10)
		rollback
		end
GO

