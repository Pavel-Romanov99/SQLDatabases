/* 1. 
а) Да се направи така,
че да не може два
филма да имат
еднаква дължина.

б) Да се направи така,
че да не може едно
студио да има два
филма с еднаква
дължина. */use moviesalter table movieadd constraint unique_length unique(length)alter table movieadd constraint studio_unique_length unique(length, studioname)/* 2. Изтрийте
ограниченията,
създадени в зад. 1. */
alter table movie
drop constraint unique_length, studio_unique_length


/* 3. */
create database students

use students

create table student1(
	fn int check(fn > 0 and fn < 99999) not null primary key,
	name varchar(100) not null,
	egn char(10) unique not null, 
	email varchar(100) unique not null,
	birthdate date not null,
	admission_date date not null,
	constraint at_least_18yrs check(year(admission_date) - year(birthdate) >= 18)
)

alter table student1
add constraint email_val check(email like '%@%.%')

create table courses(
	id int identity primary key,
	name varchar(50) not null
)

insert into courses(name) values('DB');
insert into courses(name) values('OOP');
insert into courses(name) values('Android');
insert into courses(name) values('iOS');
select * from courses;

-- всеки студент може да се запише в много курсове и във всеки курс
-- може да има записани много студенти.
-- При изтриване на даден курс автоматично да се отписват всички студенти от него.
create table StudentsIn
(
	student_fn int references student1(fn),
	course_id int references courses(id) on delete cascade,
	primary key(student_fn, course_id)
);

insert into StudentsIn values(81888, 2);
insert into StudentsIn values(81888, 3);
insert into StudentsIn values(81888, 4);
select * from StudentsIn;
-- id-тата на всички курсове, в които се е записал студент 81888:
select course_id
from StudentsIn
where student_fn = 81888;
-- факултетните номера на всички студенти, записали се в курс с id=3 (Android):
select student_fn
from StudentsIn
where course_id = 3;

delete from courses
where name = 'iOS';
select * from StudentsIn;
-- виждаме, че вече няма студенти, записани в курс с id = 4

use master

drop database students
