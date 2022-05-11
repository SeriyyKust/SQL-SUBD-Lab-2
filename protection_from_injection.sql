/*Добавление фильтра*/
CREATE or replace function GetUserInfo (u varchar(300))
returns table ( username varchar(300),
				balance int,
				magic varchar(300),
				visible bit,
				tIPgfllFCC varchar(300),
				ESAxWUeHrW varchar(300))
language plpgsql 
as $$
begin
	u = FilterFunc(u);
	return query
	EXECUTE('select * from users_OUEthG where username = ' || u || ' and visible = 1::bit');
end;$$;


/*Изменеия порядка фильтров внутри главного фильтра, для второго типа инъекций*/
CREATE or replace FUNCTION FilterFunc(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	q = EqualFilter(q);
	q = CommentsFilter(q);
	q = WhiteSpaceFilter(q);
	q = QuotesFilter(q);
	q = NullFilter(q);

	q = SelectFilter(q);
	q = FromFilter(q);
	q = AdminFilter(q);
	RETURN q;
END;$$;


/*Изменеия фильтров для предотвращения прохождения ключевых слов в верхнем регистре*/
-- simple filter to remove select (case insensitive)
CREATE or replace FUNCTION SelectFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE((SELECT REPLACE(q,'SELECT','')), 'select', ''));
END;$$;


-- simple filter to remove from (case insensitive)
CREATE or replace FUNCTION FromFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE((SELECT REPLACE(q, 'FROM','')), 'from', ''));
END;$$;