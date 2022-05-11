DROP FUNCTION IF EXISTS CommentsFilter;
DROP FUNCTION IF EXISTS SelectFilter;
DROP FUNCTION IF EXISTS FromFilter;
DROP FUNCTION IF EXISTS WhiteSpaceFilter;
DROP FUNCTION IF EXISTS AdminFilter;
DROP FUNCTION IF EXISTS EqualFilter;
DROP FUNCTION IF EXISTS QuotesFilter;
DROP FUNCTION IF EXISTS NullFilter;
DROP FUNCTION IF EXISTS FilterFunc;

DROP TABLE IF EXISTS users_OUEthG;
DROP TABLE IF EXISTS roles_OUEthG;
DROP TABLE IF EXISTS passwords_OUEthG;

DROP PROCEDURE IF EXISTS GetUserInfo;
DROP PROCEDURE IF EXISTS GetBalance;
DROP PROCEDURE IF EXISTS HasAccess;
DROP PROCEDURE IF EXISTS CheckPasswordExpired;

-- simple filter to remove /**/
CREATE FUNCTION CommentsFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, '/**/', ''));
END;$$;


-- simple filter to remove select (case insensitive)
CREATE FUNCTION SelectFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, 'select', ''));
END;$$;


-- simple filter to remove from (case insensitive)
CREATE FUNCTION FromFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, 'from', ''));
END;$$;


-- simple filter to remove whitespaces
CREATE FUNCTION WhiteSpaceFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	-- remove spaces
	q = (SELECT REPLACE(q, ' ', ''));
	-- remove tabs
	RETURN (SELECT REPLACE(q, '	', ''));
END;$$;

-- filter admin word
CREATE FUNCTION AdminFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, 'admin', ''));
END;$$;


-- filter = symbol
CREATE FUNCTION EqualFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, '=', ''));
END;$$;


-- filter quotes
CREATE FUNCTION QuotesFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, '''', ''));
END;$$;


-- filter = symbol
CREATE FUNCTION NullFilter(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	RETURN (SELECT REPLACE(q, 'NULL', ''));
END;$$;


CREATE FUNCTION FilterFunc(q varchar(300))
RETURNS varchar(300)
language plpgsql as $$
BEGIN
	q = CommentsFilter(q);
	q = SelectFilter(q);
	q = FromFilter(q);
	q = WhiteSpaceFilter(q);
	q = AdminFilter(q);
	q = EqualFilter(q);
	q = QuotesFilter(q);
	q = NullFilter(q);
	RETURN q;
END;$$;


------------------------- TABLES ------------------------------------------
create table users_OUEthG(
	username varchar(300) UNIQUE,
	balance int,
	magic varchar(300) UNIQUE,
	visible bit,
	tIPgfllFCC varchar(300),
	ESAxWUeHrW varchar(300)
);

create table roles_OUEthG(
	mHash varchar(300),
	role varchar(300)
);

create table passwords_OUEthG(
	username varchar(300),
	password varchar(50),
	expired bit
);

--------------------- PROCEDURES --------------------------------------
CREATE PROCEDURE GetUserInfo (u varchar(300))
language plpgsql 
as $$
begin
	EXECUTE('select * from users_OUEthG where username = ' || u || ' and visible = 1::bit');
end;$$;


CREATE PROCEDURE GetBalance (u varchar(300))
language plpgsql
AS $$
BEGIN
	drop table if exists tmp;
	create TEMP table tmp(
		username varchar(300),
		balance int,
		magic varchar(300),
		visible bit,
		tIPgfllFCC varchar(300),
		ESAxWUeHrW varchar(300)
	);
	-- special filter to disallow JOIN
	u = REPLACE(u, 'j', '');
	u = FilterFunc(u);

	INSERT INTO tmp select * from GetUserInfo (''''||u||'''');
	SELECT balance from tmp;
END;$$;


CREATE PROCEDURE HasAccess (u varchar(300))
language plpgsql
AS $$
BEGIN
	u = FilterFunc(u);

	drop table tmp;
	create TEMP table tmp(b varchar(300)); 
	INSERT INTO tmp values( EXECUTE('select top(1) username from users_OUEthG JOIN roles_OUEthG
	on (CONVERT(NVARCHAR(32), HashBytes(''MD5'', users_OUEthG.username),2)) = roles_OUEthG.mHash
	WHERE (users_OUEthG.balance % 2 = 1 AND users_OUEthG.username = ' || u || ') OR roles_OUEthG.role = ''admin'')'));
	SELECT COUNT(*) FROM tmp;
END;$$;


CREATE PROCEDURE CheckPasswordExpired (u varchar(300))
language plpgsql
AS $$
BEGIN
	u = FilterFunc(u);

	DROP table if exists tmp;
	CREATE TEMP TABLE tmp (b bit);

	INSERT INTO tmp values( EXECUTE('SELECT expired from passwords_OUEthG where username = ' || u));
	SELECT * FROM tmp;
END;$$;


Create or replace function random_string(length integer) returns text as
$$
declare
  chars text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
begin
  if length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$ language plpgsql;


DO $$
DECLARE username varchar(300);
DECLARE magic varchar(300);
DECLARE balance int;
DECLARE password varchar(300);
DECLARE hMagic varchar(300);
DECLARE role varchar(300);


DECLARE tIPgfllFCC int;
DECLARE ESAxWUeHrW varchar(300);

-- THIS IS THE ANSWER
DECLARE adminPass varchar(50) default 'Danilov';
-- Where to place admin record
DECLARE adminIdx int default 457;

DECLARE i int default 0;

BEGIN
WHILE i < 1000 LOOP
	-- generating random parameters
	username = random_string(15);
	magic = random_string(15);
	balance=((random()*1000)::int);
	password = random_string(15);
	hMagic= md5(username);
	role=random_string(15);


	tIPgfllFCC = ((random()*1000)::int);
	ESAxWUeHrW = random_string(15);
	

	-- Place key in table when index of record selected for admin
	-- Also change role
	IF i = adminIdx then
		password = adminPass;
		role = 'admin';
	END IF;

	INSERT INTO users_OUEthG VALUES (username, balance, magic, ROUND(random())::int::bit , tIPgfllFCC, ESAxWUeHrW);
	INSERT INTO roles_OUEthG VALUES (hMagic, role);
	INSERT INTO passwords_OUEthG VALUES (username, password, ROUND(random())::int::bit);

	i = i + 1;
END LOOP;
END $$;