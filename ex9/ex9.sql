/* 1. Създайте БД “test”.test”. */

create database test
use test
/* 2. Създайте следните таблици в нея:*/

create table product(
	model char(4),
	maker char(1),
	type varchar(7)
)

create table printer(
	code integer,
	color char(1) default 'n',
	price decimal(6,2),
	model char(4)
)

create table classes(
	class varchar(50),
	type char(2)
)

/* 3. Добавете редове с примерни данни към
новосъздадените таблици. Добавете информация
за принтер, за който знаем само кода и модела. */
insert into printer(code, model)
values(1, '1100')

/* 4. Добавете към Classes колона bore - число с
плаваща запетая. */
alter table classes
add bore decimal(4,2)

/* 5. Напишете заявка, която премахва колоната price от Printer. */
alter table printer
drop column price

/* 6. Изтрийте всички таблици и БД, които сте създали в
това упражнение. */

use master
drop database test
