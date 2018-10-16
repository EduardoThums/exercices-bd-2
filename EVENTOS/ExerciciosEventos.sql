-- Fazer um evento que executa 1 vez daqui a 3 dias, 4 horas, 25
-- minutos a partir de agora.
create event ex1
on schedule at now() + interval '3 4:25' day_minute
do insert into cliente values (null,'a','b','c','d','e','f');
drop event ex1;
-- Fazer um evento que executa repetidamente, a cada 5 minutos,
-- entre os dias 25 de outubro de 2014 e 05 de novembro de 2014.
create event ex2
on schedule every 5 minute
starts '2014:10:25'
ends '2014:11:05'
do insert into tlb_statusAluno values ('Eduardo',1.0,1,0,1,0);

-- Fazer um evento que executa todos os anos, no dia 1 de janeiro.
create event ex3
on schedule every 1 year 
starts makedate(year(now()),1)
do insert into tlb_statusAluno values ('Eduardo',1.0,1,0,1,0);

-- 1) O valor unitário dos produtos está em reais. Porém, a empresa utiliza o dólar como moeda-base.
-- O procedimento armazenado atualiza_preco() atualiza os valores unitários a partir do valor do dólar
-- do dia anterior. Faça um evento que executa o atualiza_preco(), de segunda a sexta, às 7h.
delimiter $$
create event lex1
on schedule every 1 day
starts curdate() + interval 1 day + interval 7 hour
do begin
if(dayofweek(curdate()) between 2 and 6) then
call atualiza_preco();
end if;
end$$;
delimiter ;
drop event lex1;
insert into cliente values (null,'a','b','c','d','e','f');

-- 2) Crie um evento que realiza o backup do compubrás, todo dia, às 0h, através do procedimento
-- armazenado backup_diário(), outro evento que realiza o backup todo domingo, às 0h, através do
-- procedimento backup_semanal().
create event lex2_1
on schedule every 1 day
starts curdate() + interval 24 hour
do -- backup_diario()
insert into cliente values (null,'a','b','c','d','e','f');

create event lex2_2
on schedule every 1 week
starts curdate() + interval 6 - weekday(curdate()) + 6 day + interval 24 hour
do -- backup_semanal()
insert into cliente values (null,'a','b','c','d','e','f');

-- 3) Existem algumas datas especiais para o compubrás, onde é dado um desconto nesse dia. Para
-- isso, crie um evento que executa o procedimento armazenado aplica_desconto(int desconto),
-- responsável por atualizar o preço dos produtos com o desconto na visão que disponibiliza os preços
-- com ou sem desconto. Este ano, será dado um desconto de 50% no black friday, 10% de desconto
-- no natal, e 20% de desconto no aniversário da empresa, que ocorre daqui a duas semanas. Crie um
-- evento para cada data.
create event lex3_1
on schedule at curdate() - interval month(curdate()) month + interval 11 month - interval day(curdate()) day + interval 23 day
do update produto set valorUnitario = aplica_desconto(50);

create event lex3_2
on schedule at curdate() - interval month(curdate()) month + interval 12 month - interval day(curdate()) day + interval 25 day
do update produto set ValorUnitario = aplica_desconto(10);

create event lex3_3
on schedule at now() + interval 2 week
do update produto set ValorUnitario = aplica_desconto(20);
-- 4) Todo dia 5 é realizado o pagamento dos vendedores. Realize um evento que execute o
-- procedimento pagar_vendedores().
create event lex4
on schedule every 1 month
starts curdate() - interval day(curdate()) day + interval 1 month + interval 5 day
do pagar_vendedores();

-- 5) Entre os dias 5 e 7 deste mês ocorre o dia do gamer, onde a cada dia o compubrás dará 30% de
-- desconto em um produto. A cada dia o produto muda. Crie um evento que executa diariamente, às
-- 00:01, o procedimento armazenado aplicar_desconto(), responsável por escolher um produto e
-- aplicar o desconto.
create event lex5 
on schedule every 1 day
starts curdate() - interval day(curdate()) day + interval 5 day + interval 1 minute
ends curdate() - interval day(curdate()) day + interval 7 day + interval 1 minute
do -- aplicar_desconto();
insert into cliente values (null,'a','b','c','d','e','f');

-- 6) Na última semana do ano ocorre o recesso da empresa, onde a empresa não realiza vendas. Crie
-- um evento que, durante a meia noite da segunda dessa semana, execute o procedimento armazenado
-- ativar_gatilho_recesso(), e crie outro evento que, às 23:59 do domingo dessa mesma semana,
-- execute o desativar_gatilho_recesso().
-- create event lex6
-- on schedule every 1 year