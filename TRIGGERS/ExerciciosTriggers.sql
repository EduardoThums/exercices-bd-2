-- Objetiva validar se os dados foram passados em uma
-- declaração INSERT antes (BEFORE) que sejam cadastrados na tabela de
-- exemplo. Valida o nome com quantidade de caracteres maior ou igual a 4.
delimiter $$
create trigger ex1 before insert
on tbl_cliente
for each row
begin
set @nome = new.cliente_nome;
if char_length(@nome) >=4 or @nome = '' then
	set @nome = null;
end if;
end$$
delimiter ;

CREATE TABLE Produtos
(
Referencia VARCHAR(3) PRIMARY KEY,
Descricao VARCHAR(50) UNIQUE,
Estoque INT NOT NULL DEFAULT 0
);

INSERT INTO Produtos VALUES ('001', 'Feijão', 10);
INSERT INTO Produtos VALUES ('002', 'Arroz', 5);
INSERT INTO Produtos VALUES ('003', 'Farinha', 15);

CREATE TABLE ItensVenda
(
Venda INT,
Produto VARCHAR(3),
Quantidade INT
);

-- Ao inserir e remover registro da tabela ItensVenda, o estoque do produto
-- referenciado deve ser alterado na tabela Produtos.
-- Para isso, serão criados dois triggers: um AFTER INSERT para dar baixa no
-- estoque e um AFTER DELETE para fazer a devolução da quantidade do produto.

delimiter $$
create trigger ex2_tgr1 before insert
on ItensVenda
for each row
begin
update Produtos set Estoque = Estoque - new.Quantidade
where Referencia = new.Produto;
end$$
delimiter ;

delimiter $$
create trigger ex2_tgr2 after delete
on ItensVenda
for each row
begin
update Produtos set Estoque = Estoque + old.Quantidade
where Referencia = old.Produto;
end$$
delimiter ;

-- No primeiro gatilho, foi utilizado o registro NEW para obter as informações
-- da linha que está sendo inserida na tabela.
-- O mesmo é feito no segundo gatilho, onde se obtém os dados que estão
-- sendo apagados da tabela através do registro OLD.
-- Tendo criado os triggers, podemos testá-los inserindo dados na tabela
-- ItensVenda. Nesse caso, vamos simular uma venda de número 1 que
-- contem três unidades do produto 001, uma unidade do produto 002 e
-- cinco unidades do produto 003.
create database exercicios;
use exercicios;
drop database exercicios;

insert into ItensVenda values(1,'001',3);
insert into ItensVenda values(1,'002',1);
insert into ItensVenda values(1,'003',5);

-- Agora para testar o trigger da exclusão, removeremos o produto 001 dos
-- itens vendidos. Com isso, o seu estoque deve ser alterado para o valor
-- inicial, ou seja, 10
delete from ItensVenda where Venda = 1 and Produto = '001';

-- O preço desses produtos sofrerão reajustes ao longo do tempo e deverão
-- ser mantidos históricos para a possibilidade da emissão de relatórios
-- futuros.
CREATE TABLE produtos (
ID int NOT NULL primary key AUTO_INCREMENT,
NOME varchar(255) NOT NULL,
VALOR decimal(10,2) NOT NULL
);

-- Mas e agora, como faço para que após toda atualização na tabela de
-- produtos seja salvo o valor antigo daquele produto?
CREATE TABLE produtos_historico (
ID int NOT NULL,
DATA_HORA datetime NOT NULL,
VALOR decimal(10,2) NOT NULL,
PRIMARY KEY (ID,DATA_HORA)
);

delimiter $$
create trigger ex3 after update
on produtos
for each row begin
insert into produtos_historico set
ID = old.ID, DATA_HORA = NOW(), VALOR = old.VALOR;
end$$
delimiter ;

-- Objetiva validar se os dados foram passados em uma
-- declaração INSERT antes (BEFORE) que sejam cadastrados na tabela de
-- exemplo.
-- Valida o nome com quantidade de caracteres maior ou igual a 4
-- (quatro).
delimiter $$
create trigger validarNome before insert on tbl_cliente
for each row
begin
if(character_length(NEW.cliente_nome) < 4 || new.cliente_nome = '') then
	set new.cliente_nome = null;
end if;
end$$
delimiter ;

-- Imagine uma tabela com os seguintes campos:
-- Nome (varchar(255))
-- Trim1 (decimal(3,1))
-- Trim2 (decimal(3,1))
-- Trim3 (decimal(3,1))
-- Status (aprovado ou reprovado)
-- Ao cadastrar um aluno e as notas, calcule se o aluno está aprovado ou
-- reprovado (<6.0 reprovado)
-- Ao atualizar as notas, calcule novamente e atualize o status.
create table tlb_statusAluno (
Nome varchar (255),
Trim1 decimal(3,1),
Trim2 decimal(3,1),
Trim3 decimal(3,1),
Status_ enum('aprovado', 'reprovado')
);

delimiter $$
create trigger cadastraStatus before insert
on tlb_statusAluno
for each row begin
if(((new.Trim1 + new.Trim2 + new.Trim3) / 3) < 6.0) then
set new.Status_ = "reprovado";
else set new.Status_ = "aprovado";
end if;
end$$
delimiter ;

delimiter $$
create trigger atualizaStatus before update
on tlb_statusAluno
for each row begin
if(((new.Trim1 + new.Trim2 + new.Trim3) / 3) < 6.0) then
set new.Status_ = "reprovado";
else set new.Status_ = "aprovado";
end if;
end$$
delimiter ;

drop trigger cadastraStatus;
insert into tlb_statusAluno (Nome,Trim1,Trim2,Trim3) values ('Luis',0.0,5.0,10.0);
update tlb_statusAluno set Trim1 = 6.0, Trim2 = 6.0, Trim3 = 10.0 where Nome = 'Luis';

use compubras;
-- 1) Faça um gatilho que só permita cadastrar clientes onde a UF seja válida.
delimiter $$
create trigger lex1 before insert on cliente
for each row begin
if(new.Uf not like 'AC' and new.Uf not like 'AL') then
set new.Uf = null;
end if;
end$$
delimiter ;
drop trigger lex1;
insert into cliente values (null,'a','b','c','d','df','e');
select * from cliente where Nome = 'a';

-- 2) Faça um gatilho que não permita atualizar a UF do cliente, caso a UF não seja válida.
delimiter $$
create trigger lex2 before update on cliente
for each row begin
if(new.Uf != 'AC' and new.Uf != 'AL') then
set new.Uf = null;
end if;
end$$
delimiter ;
update cliente set Uf = 'al' where CodCliente = 1577;
drop trigger lex2;

-- 3) Faça um gatilho que, durante o cadastro de um cliente, se a UF estiver em minúsculo, passe a UF
-- para maiúsculo.
delimiter $$
create trigger lex3 before insert on cliente
for each row begin
set new.Uf = upper(new.Uf);
end$$
delimiter ;
select * from cliente where Nome = 'aa';
insert into cliente values (null,'aa','bb','cc','dd','al','dd');
drop trigger lex3;

-- 4) Faça um gatilho que somente permita cadastrar ie de clientes com 9 a 11 caracteres.
delimiter $$
create trigger lex4 before insert on cliente
for each row begin
if (character_length(new.Ie) < 9 or character_length(new.Ie) > 11) then
set new.Ie = null;
end if;
end$$
delimiter ;
drop trigger lex4;
insert into cliente values (null,'aa','bb','cc','dd','al','ddaaaaaaaaaa');
select * from cliente where Nome = 'a';
-- 5) Faça um gatilho que só permita que o cliente se cadastre caso o cliente tenha nascido no estado
-- que está cadastrando. Para isso verifique o nono dígito do ie e a UF, da seguinte forma: 1 (DF-GOMS-MT-TO),
-- 2 (AC-AM-AP-PA-RO-RR), 3 (CE-MA-PI), 4 (AL-PB-PE-RN), 5 (BA-SE), 6
-- (MG), 7 (ES-RJ), 8 (SP), 9 (PR-SC) e 0 (RS).
delimiter $$
create trigger lex5 before insert on cliente
for each row begin
case substring(new.Ie,9,1)
when '1' then if(new.Uf != 'DF' and new.Uf != 'GO' and new.Uf != 'MS' and new.Uf != 'MT' and new.Uf != 'TO')
then set new.Ie = null; end if;

when '2' then if(new.Uf != 'AC' and new.Uf != 'AM' and new.Uf != 'AP' and new.Uf != 'PA' and new.Uf != 'RO' and new.Uf != 'RR')
then set new.Ie = null; end if;

when '3' then if(new.Uf != 'CE' and new.Uf != 'MA' and new.Uf != 'PI')
then set new.Ie = null; end if;

when '4' then if(new.Uf != 'AL' and new.Uf != 'PB' and new.Uf != 'PE' and new.Uf != 'RN')
then set new.Ie = null; end if;

when '5' then if(new.Uf != 'BA' and new.Uf != 'SE')
then set new.Ie = null; end if;

when '6' then if(new.Uf != 'MG')
then set new.Ie = null; end if;

when '7' then if(new.Uf != 'ES' and new.Uf != 'RJ')
then set new.Ie = null; end if;

when '8' then if(new.Uf != 'SP')
then set new.Ie = null; end if;

when '9' then if(new.Uf != 'PR' and new.Uf != 'SC')
then set new.Ie = null; end if;

when '0' then if(new.Uf != 'RS')
then set new.Ie = null; end if;

end case;
end$$
delimiter ;
drop trigger lex5;
insert into cliente values (null,'a','b','c','d','RS','1234567804');
-- 6) Faça um gatilho que só permita que o vendedor tenha uma faixa de comissão entre A e D.
delimiter $$
create trigger lex6 before insert on vendedor
for each row begin
if(ascii(new.FaixaComissao) < 65 and ascii(new.FaixaComissao) > 68)
then set new.FaixaComissao = null;
end if;
end$$
delimiter ;
drop trigger lex6;
insert into vendedor values (null,'a',1000,'f');

-- 7) Faça um gatilho que não permita cadastrar um prazo de entrega com data menor que a data do
-- pedido.
delimiter $$
create trigger lex7 before insert on pedido
for each row begin
if(new.DataPedido > new.PrazoEntrega) then
set new.PrazoEntrega = null;
end if;
end$$
delimiter ;
drop trigger lex7;
insert into pedido values (null,'2013-04-03','2013-04-15',1,1);

-- 8) Faça um gatilho que não permita criar um itempedido com quantidade igual ou menor que zero.
delimiter $$
create trigger lex8 before insert on itempedido
for each row begin
if(new.quantidade <= 0) then
set new.quantidade = null;
end if;
end$$
delimiter ;
insert into itempedido values (null,4906,2592,-1);

-- 9) Faça um gatilho que não permita criar um produto com valor unitário negativo.
delimiter $$
create trigger lex9  before insert on produto
for each row begin
if(new.ValorUnitario < 0) then
set new.ValorUnitario = null;
end if;
end$$
delimiter ;
drop trigger lex9;
insert into produto values (null,'Caixa de Som',-1);
select * from produto where descricao like 'Caixa de Som';

-- 10) Faça um gatilho que não permita que a descrição de um produto seja somente um espaço.
delimiter $$
create trigger lex10 before insert on produto
for each row begin
if(new.descricao like ' ' or new.descricao like '') then
set new.descricao = null;
end if;
end$$
delimiter ;
drop trigger lex10;
insert into produto values (null,' 5',100);














