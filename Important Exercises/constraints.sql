use movies

/*1. 
а) Да се направи така,
че да не може два
филма да имат
еднаква дължина. 
б) Да се направи така,
че да не може едно
студио да има два
филма с еднаква
дължина. */

begin TRANSACTION

alter table movie
add constraint unique_lenght unique(length)

ROLLBACK

alter table movie
add constraint unique_studio_length UNIQUE(studioname, lenght)


/* Зад. 3.
а) За всеки студент се съхранява следната
информация:
- факултетен номер - от 0 до 99999, първичен ключ;
- име - до 100 символа;
- ЕГН - точно 10 символа, уникално;
- e-mail - до 100 символа, уникален;
- рождена дата;
- дата на приемане в университета - трябва да бъде
поне 18 години след рождената;
За всички атрибути задължително трябва да има
зададена стойност (PRIMARY KEY)не може NULL) */

/* б) добавете валидация за e-mail адреса - да бъде във
формат <низ>@<низ>.<низ> */

create table students(
    fn int constraint pk_constraint primary key,
    check(fn between 1 and 99999),
    name varchar(100) not null,
    eng char(10) not null,
    email varchar(100) not null,
    birthdate date not null,
    a_date date not null,
    check(email like '%@%.%')
)

/* в) създайте таблица за университетски курсове -
уникален номер и име.
Всеки студент може да се запише в много курсове и
във всеки курс може да има записани много студенти.
При изтриване на даден курс автоматично да се
отписват всички студенти от него. */

create table uni_courses(
    id int constraint course_id_pk primary key,
    course_name varchar(100) unique not null
)

create table list(
    student_number int ,
    course_id int ,
    CONSTRAINT list_constraints
    FOREIGN KEY (student_number)
    REFERENCES students(fn)
    ON DELETE CASCADE
    ON UPDATE SET NULL,
    CONSTRAINT list_constraints2
    FOREIGN KEY (course_id)
    REFERENCES uni_courses(id)
    ON DELETE CASCADE
    ON UPDATE SET NULL
)
drop table list

insert into students
values('81762', 'Pavel Romanov', 9906144004, 'pavel@gmail.com', '1999-06-14', '2018-08-1')

insert into students
values('81788', 'Yavor', 9905211323, 'yavor@gmail.com', '1999-06-14', '2018-08-1')

insert into uni_courses
values(1, 'Databases'),
      (2, 'Logic Programming'),
      (3, 'OOP')

insert into list
values('81762', 2)

insert into list
values('81762', 1)

select * from uni_courses

delete from uni_courses
where id = 2



