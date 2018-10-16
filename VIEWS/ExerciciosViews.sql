-- Crie uma visão que mostre apenas o código do cliente, a cidade e o estado dos clientes cadastrados.
create view questao1 as
(select CodCliente, cidade, uf from cliente);
select * from questao1;

-- Crie uma visão que mostre o salário fixo dos vendedores, de faixa de comissão “D”,
-- calculando com base no reajuste de 50% acrescido de R$ 100,00 de bonificação. Ordenar
-- pelo nome do vendedor.
create view questao2 as
(select ((SalarioFixo*1.50)+100) as NovoSalario from vendedor where FaixaComissao like '%D%' order by nome);
select * from questao2;

-- Crie uma visão que mostre o código do cliente, o nome e a cidade somente dos clientes
-- que moram no Rio Grande do Sul. A nova visão deve ser ordenada em ordem alfabética
-- primeiro pelo nome e depois pela cidade, também em ordem alfabética.
create view questao3 as
(select CodCliente, nome,cidade from cliente
where uf like '%RS%' order by nome,cidade asc);
select * from questao3;

-- Crie uma visão que mostre o código dos pedidos e a quantidade de produtos diferentes
-- dos pedidos que tenham mais que 10 produtos diferentes.
create view questao4 as
(select CodPedido, count(quantidade)
from itempedido
where 10 <any (select count(quantidade) from itempedido group by CodPedido) group by CodPedido);
select * from questao4;

-- Crie uma visão que mostre apenas os produtos que custam mais que R$ 1500,00. Os
-- campos que deveram ser mostrados são código, descrição e valor.
create view questao5 as
(select CodProduto,descricao, ValorUnitario
from produto
where ValorUnitario > 1500);
select * from questao5;

-- Crie uma visão que mostre apenas os produtos que custem menos que R$ 500,00 e mais
-- que R$ 2.500,00. Os campos que deveram ser mostrados são código, descrição e valor.

create view questao6 as
(select CodProduto,descricao,ValorUnitario
from produto 
where ValorUnitario <500 or ValorUnitario >2500);
select * from questao6;

-- Crie uma visão que mostre o estado e a quantidade de cidades em cada estado que a
-- empresa possui clientes.
create view questao7 as
(select uf,count(CodCliente) from cliente group by uf;);
select * from questao7;

-- Crie uma visão que será o ranking de vendas da empresa. Neste ranking deverá ser
-- exibido o código do vendedor, bem como a quantidade de vendas efetuadas por cada
-- vendedor. Lembre-se que em um ranking o vendedor que efetuou o maior número de
-- vendas (pedidos), deverá aparecer no topo da lista.
create view questao8 as
(select CodVendedor,count(CodPedido) as Pedidos
from pedido
group by CodVendedor
order by Pedidos desc);
select * from questao8;

-- Crie uma visão que será o ranking de pedidos da empresa. Neste ranking deverá ser
-- exibido o código do cliente, bem como a quantidade de pedidos efetuados por cada cliente.
-- Lembre-se que em um ranking o cliente que efetuou o maior número de pedidos, deverá aparecer no topo da lista.
create view questao9 as
(select CodCliente, count(CodPedido) as Pedidos
from pedido
group by CodCliente
order by Pedidos desc);
select * from questao9;

-- Crie uma visão que mostre o ano, o mês e a quantidade de pedidos em cada (ano/mês). A
-- visão deverá ser ordenada pela quantidade de pedidos em cada ano/mês
create view questao as
();
select * from questao;

create view questao as
();
select * from questao;

create view questao as
();
select * from questao;

create view questao as
();
select * from questao;
