use compubras;
-- Retorne o número mais o nome do mês em português (1 - Janeiro) de acordo com o parâmetro
-- informado que deve ser uma data. Para testar, crie uma consulta que retorne o cliente e mês de
-- venda (número e nome do mês).
delimiter $$
create function ex1(vdata date) returns varchar(255)
deterministic
begin
declare resposta varchar(255);
case month(vdata)
when 1 then set resposta = "1 - Janeiro";
when 2 then set resposta = "2 - Fevereiro";
when 3 then set resposta = "3 - Março";
when 4 then set resposta = "4 - Abril";
when 5 then set resposta = "5 - Maio";
when 6 then set resposta = "6 - Junho";
when 7 then set resposta = "7 - Julho";
when 8 then set resposta = "8 - Agosto";
when 9 then set resposta = "9 - Setembro";
when 10 then set resposta = "10 - Outubro";
when 11 then set resposta = "11 - Novembro";
when 12 then set resposta = "12 - Dezembro";
end case;
return resposta;
end$$
delimiter ;

drop function ex1;
select CodCliente, ex1(DataPedido) from pedido;

-- Retorne o número mais o nome do dia da semana (0 - Segunda) em português, como parâmetro de
-- entrada receba uma data. Para testar, crie uma consulta que retorne o número do pedido, nome do
-- cliente e dia da semana para entrega (função criada).
delimiter $$
create function ex2(datav date) returns varchar(255)
deterministic
begin
declare resposta varchar(255);
case weekday(datav)
when 0 then set resposta = "0 - Segunda";
when 1 then set resposta = "1 - Terça";
when 2 then set resposta = "2 - Quarta";
when 3 then set resposta = "3 - Quinta";
when 4 then set resposta = "4 - Sexta";
when 5 then set resposta = "5 - Sabado";
when 6 then set resposta = "6 - Domingo";
end case;
return resposta;
end$$;
delimiter ;

select pd.CodPedido,cl.nome,ex2(PrazoEntrega)
from pedido pd inner join cliente cl
on pd.CodCliente = cl.CodCliente;

-- Crie uma função para retornar o gentílico dos clientes de acordo com o estado onde moram
-- (gaúcho, catarinense ou paranaense), o parâmetro de entrada deve ser a sigla do estado. Para
-- testar a função crie uma consulta que liste o nome do cliente e gentílico (função criada).
delimiter $$
create function ex3(uf char(2)) returns varchar(255)
deterministic
begin
declare resposta varchar(255);
case uf
when "RS" then set resposta = "gaúcho";
when "SC" then set resposta = "catarinense";
when "PR" then set resposta = "paranaense";
else set resposta = "Outro estado";
end case;
return resposta;
end$$
delimiter ;

select nome, ex3(uf) as gentílico from cliente order by gentílico;

-- Crie uma função que retorne a Inscrição Estadual no formato #######-##. Para testar a função
-- criada exiba os dados do cliente com a IE formatada corretamente utilizando a função criada.
delimiter $$
create function ex4(ie varchar(20)) returns varchar(20)
not deterministic
begin
declare resposta varchar(20);
declare aux1 varchar(20);
set aux1 = substring(ie,length(ie)-2,2);
set resposta = concat(substring(ie,1,length(ie)-2),"-",aux1);
return resposta;
end$$
delimiter ;

select ex4(ie) from cliente;

-- Crie uma função que retorne o tipo de envio do pedido, se for até 3 dias será enviado por SEDEX,
-- se for entre 3 e 7 dias deverá ser enviado como encomenda normal, caso seja maior que este prazo
-- deverá ser utilizado uma encomenda não prioritária. Como dados de entrada recebe a data do
-- pedido e o prazo de entrega e o retorno será um varchar. Note que para criar esta função você
-- deverá utilizar a cláusula IF.
delimiter $$
create function ex5(datap date,datae date) returns varchar(255)
not deterministic
begin
declare resposta varchar(255);
declare aux int;
set aux = datediff(datae,datap);
if (aux < 3) then set resposta = "SEDEX.";
elseif (aux >=3 and aux <=7) then set resposta = "Encomenda normal.";
else set resposta = "Encomenda não prioritária.";
end if;
return resposta;
end$$
delimiter ;
drop function ex5;
select ex5(DataPedido,PrazoEntrega) as Tipo from pedido order by Tipo asc;

-- Crie uma função que faça a comparação entre dois números inteiros. Caso os dois números sejam
-- iguais a saída deverá ser “x é igual a y”, no qual x é o primeiro parâmetro e y o segundo parâmetro.
-- Se x for maior, deverá ser exibido “x é maior que y”. Se x for menor, deverá ser exibido “x é menor que y”.
delimiter $$
create function ex6(x int,y int) returns varchar(255)
deterministic
begin
declare resposta varchar(255);
if (x = y) then set resposta = "x é igual a y";
elseif (x > y) then set resposta = "x é maior que y";
else set resposta = "x é menor que y";
end if;
return resposta;
end$$
delimiter ;

select ex6(0,1);

-- Crie uma função que calcule a fórmula de bhaskara. Como parâmetro de entrada devem ser
-- recebidos 3 valores (a, b e c). Ao final a função deve retornar “Os resultados calculados são x e y”,
-- no qual x e y são os valores calculados.
delimiter $$
create function ex7(a int,b int,c int) returns varchar(255)
not deterministic
begin
declare resposta varchar(255);
declare r1 double;
declare r2 double;
if ((b*b-4*a*c) >= 0) then
set r1 = (-b+sqrt(b*b-4*a*c))/2;
set r2 = (-b-sqrt(b*b-4*a*c))/2;
set resposta = concat("Os resultados calculados são ",r1," e ",r2);
else set resposta = "As raizes não sao reais.";
end if;
return resposta;
end$$
delimiter ;
drop function ex7;

select ex7(1,-4,-5);

-- Crie uma função que retorne o valor total do salário de um vendedor (salário fixo + comissão
-- calculada). Note que esta função deve receber 3 valores de entrada, salário fixo, faixa de comissão
-- e o valor total vendido. Para testar essa função crie uma consulta que exiba o nome do vendedor e
-- o salário total. A - 20%, B - 15%, C - 10%, D - 5%.
delimiter $$
create function ex8(salario double, faixa varchar(2),valort double) returns double
not deterministic
begin
declare resposta double;
case faixa
when 'A' then set resposta = salario + (0.20*valort);
when 'B' then set resposta = salario + (0.15*valort);
when 'C' then set resposta = salario + (0.10*valort);
when 'D' then set resposta = salario + (0.05*valort);
end case;
set resposta = round(resposta,2);
return resposta;
end$$
delimiter ;

select ex8(SalarioFixo,FaixaComissao,total) as NovoSalario
from vendedor vd inner join pedido pd on vd.CodVendedor = pd.CodVendedor
inner join temp2 on pd.CodPedido = aux group by aux,pd.CodVendedor;

create view temp2 as (
select sum(valor) as total,aux from (select sum(quantidade)*ValorUnitario as Valor,CodPedido as aux from itempedido ip inner join produto pr
on pr.CodProduto = ip.CodProduto group by pr.CodProduto,ip.CodPedido order by aux) as temp group by aux);
select * from total;

-- Crie uma função para calcular um aumento de 10% no salário dos vendedores de faixa de comissão
-- 'A’. Considere o valor do salário fixo para calcular este aumento. Faça uma consulta select
-- utilizando essa função.
delimiter $$
create function ex9 (salario double, faixa varchar(1)) returns double
not deterministic
begin
declare resposta double;
if faixa like 'A' then set resposta = salario+salario*0.10;
end if;
return resposta;
end$$
delimiter ;
drop function ex9;

select ex9(SalarioFixo,FaixaComissao) as NovoSalario from vendedor order by NovoSalario desc;

-- Crie uma função que retorne o código do produto com maior valor unitário.
delimiter $$
create function ex10() returns int
deterministic
begin
declare resposta int;
set resposta = (select CodProduto from produto where ValorUnitario = any(select max(ValorUnitario) from produto));
return resposta;
end$$
delimiter ;

select ex10() as Produto;

-- Crie uma função que retorne o código, a descrição e o valor do produto com maior valor unitário. Os
-- valores devem ser retornados em uma expressão: “O produto com código XXX – XXXXXXXXX
-- (descrição) possui o maior valor unitário R$XXXX,XX”. Crie um select que utiliza esta função.
delimiter $$
create function ex11() returns varchar (255)
deterministic
begin
declare resposta varchar(255);
declare codigo int;
declare info varchar(255);
declare valor double;
select CodProduto, descricao, valorUnitario into codigo,info,valor from produto where valorUnitario = any(select max(valorUnitario) from produto);
set resposta = concat("O produto com código ",codigo," - ",info," possui o maior valor unitário R$",valor);
return resposta;
end$$
delimiter ;
use compubras;
select ex11();

-- Crie uma função que receba como parâmetros o código do produto com maior valor unitário e o
-- código do prod525uto com menor valor unitário. Utilize as funções dos exercícios 2 e 3. Retorne a
-- soma dos dois.
delimiter $$
create function ex12(codm int, codn int) returns int
deterministic
begin
declare resposta int;
set resposta  = codm + codn;
return resposta;
end$$
delimiter ;

select ex12((select CodProduto from produto where ValorUnitario = any(select max(ValorUnitario) from produto)),
(select CodProduto from produto where ValorUnitario = any(select min(ValorUnitario) from produto))
) as soma;


-- Crie uma função que retorne a média do valor unitário dos produtos. Crie uma consulta que utilize esta função.
delimiter $$
create function ex13() returns double
deterministic
begin
declare resposta double;
set resposta = (select avg(ValorUnitario) from produto);
set resposta = round(resposta,2);
return resposta;
end$$
delimiter ;

drop function ex13;
select ex13();

-- Faça uma função que retorna o código do cliente com a maior quantidade de pedidos um ano/mês.
-- Observe que a função deverá receber como parâmetros um ano e um mês. Deve ser exibido a
-- seguinte expressão: “O cliente XXXXXXX (cód) – XXXXXXX (nome) foi o cliente que fez a maior
-- quantidade de pedidos no ano XXXX mês XX com um total de XXX pedidos”
delimiter $$
create function ex14(ano int, mes int) returns varchar(255)
not deterministic
begin
declare resposta varchar(255);
declare cod int;
declare nomee varchar(255);
declare npedidos int;
select pd.CodCliente ,nome ,count(pd.CodPedido) as pedidos into cod, nomee, npedidos
from pedido pd inner join cliente cl on pd.CodCliente = cl.CodCliente
where month(DataPedido) = mes and year(DataPedido) = ano group by pd.CodCliente order by pedidos desc limit 1;
set resposta = concat("O cliente ",cod," - ",nomee," foi o cliente que fez a maior quantidade de pedidos no ano ",ano," mês ",mes," com um total de ",npedidos);
return resposta;
end$$
delimiter ;

drop function ex14;
select ex14(2015,08);

-- Faça uma função que retorna a soma dos valores dos pedidos feitos por um determinado cliente.
-- Note que a função recebe por parâmetro o código de uma cliente e retorna o valor total dos pedidos
-- deste cliente. Faça a consulta utilizando Joins.
delimiter $$
create function ex15(cod int) returns double
deterministic
begin
declare resposta double;
declare soma double;
select sum(valor) into soma from
(select ip.CodPedido as aux,(sum(quantidade)*ValorUnitario) as valor from itempedido ip inner join produto pr
on ip.CodProduto = pr.CodProduto group by pr.CodProduto,ip.CodPedido) as temp
inner join pedido pd on pd.CodPedido = aux  where pd.CodCliente = cod group by cod;
set resposta = soma;
return resposta;
end$$;
delimiter ;

drop function ex15;
select ex15(112) as soma;

-- Crie 3 funções. A primeira deve retornar a soma da quantidade de produtos de todos os pedidos. A
-- segunda, deve retornar o número total de pedidos e a terceira a média dos dois valores. Por fim,
-- crie uma quarta função que chama as outras três e exibe todos os resultados concatenados.
delimiter $$
create function ex16n1() returns int
deterministic
begin
declare somaq int;
set somaq = (select sum(quantidade) from itempedido);
return somaq;
end$$
delimiter ;
select ex16n1();

delimiter $$
create function ex16n2() returns int
deterministic
begin
declare totalp int;
set totalp = (select count(CodPedido) from pedido);
return totalp;
end$$
delimiter ;
select ex16n2(); 

delimiter $$
create function ex16n3() returns double
deterministic
begin
declare media double;
set media = ((ex16n1() + ex16n2())/2);
return media;
end$$
delimiter ;
select ex16n3();

delimiter $$
create function ex16() returns varchar(255)
deterministic
begin
declare resposta varchar(255);
set resposta = concat(ex16n1(),",",ex16n2(),",",ex16n3());
return resposta;
end$$
delimiter ;
select ex16();

-- Crie uma função que retorna o código do vendedor com maior número de pedidos para um
-- determinado ano/mês. Observe que a função deverá receber como parâmetros um ano e um mês.
-- Deve ser exibido a seguinte expressão: “O vendedor XXXXXXX (cód) – XXXXXXX (nome) foi o
-- vendedor que efetuou a maior quantidade de vendas no ano XXXX mês XX com um total de XXX pedidos”.
delimiter $$
create function ex17(ano int, mes int) returns varchar(255)
not deterministic
begin
declare resposta varchar(255);
declare cod int;
declare nomee varchar(255);
declare npedido int;
select pd.CodVendedor, nome, count(CodPedido) as pedidos into cod,nomee,npedido
from vendedor vd inner join pedido pd on vd.CodVendedor = pd.CodVendedor
where year(DataPedido) = 2015 and month(DataPedido) = 8
group by pd.CodVendedor order by pedidos desc limit 1;
set resposta = concat("O vendedor ",cod," - ",nomee," foi o vendedor que efetuou a maior quantidade de vendas no ano ",ano," mês ",mes," com um total de ",npedido," pedidos.");
return resposta;
end$$
delimiter ;

select ex17(2015,08);

-- Crie uma função que retorne o nome e o endereço completo do cliente que fez o último
-- pedido na loja. (Pedido com a data mais recente).
delimiter $$
create function ex18() returns varchar(255)
not deterministic
begin
declare resposta varchar(255);
declare nomee varchar(255);
declare enderecoo  varchar(255);
select nome, Endereco into nomee,enderecoo from cliente where CodCliente = any
(select CodCliente from pedido where DataPedido = any 
(select max(DataPedido) from pedido));
set resposta = concat("Nome: ",nomee," Endereço: ",enderecoo);
return resposta;
end$$
delimiter ;

select ex18();

-- Crie uma função que retorne a quantidade de pedidos realizados para clientes do Estado informado
-- (receber o estado como parâmetro).
delimiter $$
create function ex19(estado varchar(2)) returns int
not deterministic
begin
declare resposta int;
select count(pd.CodPedido) into resposta from cliente cl inner join pedido pd
on cl.CodCliente = pd.CodCliente where uf like estado;
return resposta;
end$$
delimiter ;
select ex19('RS');

-- Crie uma função que retorne o valor total que é gasto com os salários dos vendedores de certa faixa
-- de comissão. (Receber a faixa de comissão por parâmetro). Note que deve ser considerado o valor
-- total dos salários, incluindo a comissão.
delimiter $$
create function ex20(faixa varchar(1)) returns double
not deterministic
begin
declare resposta double;
select sum(SalarioFixo) into resposta from vendedor where FaixaComissao like faixa;
return resposta;
end$$
delimiter ;

select ex20('A');

-- Crie uma função que mostre o cliente que fez o pedido mais caro da loja. O retorno da função
-- deverá ser: “O cliente XXXXXX efetuou o pedido XXXX (cód) em XXXX (data), o qual é o mais caro
-- registrado até o momento no valor total de R$XXXX,XX”.
delimiter $$
create function ex21() returns varchar(255)
deterministic
begin
declare resposta varchar(255);
declare codc int;
declare codp int;
declare dataa date;
declare total double;
select cl.CodCliente,pd.CodPedido, DataPedido ,sum(totalproduto) as totalpedido into codc,codp,dataa,total from
(select ip.CodPedido as npedido,(sum(quantidade)*ValorUnitario) as totalproduto from itempedido ip inner join produto pr
on ip.CodProduto = pr.CodProduto group by pr.CodProduto,npedido) as temp
inner join pedido pd on pd.CodPedido = npedido
inner join cliente cl on cl.CodCliente = pd.CodCliente
group by npedido order by totalpedido desc limit 1;
set resposta = concat("O cliente ",codc," efetuou o pedido ",codp," em ",dataa,", o qual é o mais caro registrado até o momento no valor total de R$",total);
return resposta;
end$$
delimiter ;

select ex21();

-- Crie uma função que mostre o valor total arrecadado com apenas um determinado produto em toda
-- a história da loja. Esta função deverá receber como parâmetro o código do produto e retornar a
-- seguinte expressão: “O valor total arrecadado com o produto XXXXXX (descrição) foi de R$XXXX,XX”.
delimiter $$
create function ex22(codp int) returns varchar(255)
not deterministic
begin
declare resposta varchar(255);
declare descri varchar(255);
declare total double;
select descricao,(sum(quantidade)*ValorUnitario) as totalp into descri,total
from itempedido ip inner join produto pr
on ip.CodProduto = pr.CodProduto where pr.CodProduto = codp group by pr.CodProduto;
set resposta = concat("O valor total arrecadado com o produto ",descri," foi de R$",total);
return resposta;
end$$
delimiter ;

select ex22(121);

-- Crie uma função que mostre a quantidade total vendida para um determinado produto. A função
-- deverá receber como parâmetro o código do produto e retornar a quantidade total de itens que
-- foram vendidos para este produto.
delimiter $$
create function ex23(codp int) returns int
not deterministic
begin
declare resposta int;
select sum(quantidade) into resposta from itempedido where CodProduto = codp group by CodProduto;
return resposta;
end$$
delimiter ;

select ex23(121);
