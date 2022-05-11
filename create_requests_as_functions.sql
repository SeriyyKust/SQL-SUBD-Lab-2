drop function if exists BigStavki;
drop function if exists DepartmentNumber;
drop function if exists AllDepartmentAndNotBoss;
/*1*/
create function BigStavki() 
	returns table(fio_employee text, job_title text) as
	'
	select fio_employee, job_title from table2 t1
	where (select sum(share_occupied_stavki) from table2 t2
	where t1.fio_employee = t2.fio_employee) > 1
	group by fio_employee, job_title;
	' language sql;


/*2*/
create function DepartmentNumber(int, int) 
	returns table(department_number int) as
	'select department_number
	from table1
	where (number_of_employed_stavok < $1 or number_of_employed_stavok > $2);'
	language sql;


/*3*/
create function AllDepartmentAndNotBoss() 
	returns table(name text) as
	'select fio_employee from table2
	where fio_employee not in (select fio_boss from table1)
	union
	select fio_employee from table2 t2
	group by fio_employee
	having not exists(select department_number from table1
				  where department_number not in
				 (select department_number from table2
				 where t2.fio_employee = fio_employee));'
	language sql;