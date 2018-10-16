create database ExerciciosBasicos;
use ExerciciosBasicos;

create table produto(
id int,
nome varchar(20),
preco float
);
insert into produto values
(1,'chocolate',4.0),
(2,'oleo',2.15),
(3,'catchup',3.60),
(4,'erva mate',8.0),
(5,'salame',4.60);

-- exibir todos os dados do produto com maior preço
select * from produto where preco = any(select max(preco) from produto);

-- produtos com preço acima da média dos preços
select * from produto where preco > any(select avg(preco) from produto);

create table cliente(
codigo int,
nome varchar(20),
cidade varchar(20),
estado varchar(2)
);

insert into cliente values
(10,'joao','mossoro','RN'),
(16,'maria','fortaleza','CE'),
(25,'carlos','niteroi','RJ');

create table estado(
codigo int,
regiao varchar(20),
sigla varchar(2),
estado varchar(20)
);

insert into estado values
(1,'nordeste','RN','Rio Grande do Norte'),
(2,'sudeste','SP','São Paulo');

-- listar os dados dos clientes da região nordeste
select * from cliente where estado = any(select sigla from estado where regiao like 'nordeste');

create table filial(
numero int,
local_ varchar(10),
data_abertura date
);

insert into filial values
(1,'Recife','2011-04-10'),
(2,'São Carlos','2010-05-24'),
(3,'Recife','2009-10-01'),
(4,'São Carlos','2013-01-01'),
(5,'Recife','2014-03-26');

-- Liste os números das filiais localizadas em Recife que têm
-- data de abertura posterior à data de abertura de alguma filial localizada em São Carlos
select numero from filial
where local_ like 'Recife'
and data_abertura > any(select data_abertura from filial where local_ like '%São Carlos%');

-- Liste os números das filiais localizadas em Recife que têm
-- data de abertura posterior às datas de abertura de todas as
-- filiais localizadas em São Carlos.
select numero from filial
where local_ like '%Recife%'
and data_abertura > all
(select data_abertura from filial where local_ like 'São Carlos');

create table pedido (
codigo int,
produto int,
desconto float
);

insert into pedido values
(1,1,0.10),
(1,2,0),
(1,4,0.4);

-- Listar o nome de todos os produtos que possuem um
-- desconto de mais de 25% no pedido de código 1.
select nome from produto where id = any(select produto from pedido where desconto > 0.25);
