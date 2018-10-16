create user 'eduardo'@localhost identified by 'password';
grant select on compubras.* to 'eduardo'@localhost;
grant all privileges on compubras.* to 'eduardo'@localhost;

grant create routine on compubras.* to 'eduardo'@localhost;
grant execute on function compubras.ex22 to 'eduardo'@localhost;