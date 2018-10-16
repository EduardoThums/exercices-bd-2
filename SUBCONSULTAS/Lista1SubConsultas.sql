-- Mostre o nome dos Clientes e seu endereço completo, dos clientes que realizaram um pedido
-- no ano de 2015. ordene pela ordem alfabética.
select cl.nome, cl.endereco from cliente cl
where cl.CodCliente = any(select pd.CodCliente from pedido pd where year(DataPedido) = 2015) order by cl.nome asc;

-- Mostre o nome do produto e seu valor unitário. Somente devem ser exibidos os produtos que
-- tiveram pelo menos 5 e no máximo 7 itens em um único pedido. Ordene em ordem
-- decrescente pelo valor unitário dos produtos.
select pr.nome,pr.ValorUnitario
from produto pr where pr.CodProduto = any
(select ip.CodProduto from itempedido ip
where (select sum(quantidade) from itempedido ip group by ip.CodProduto) as t1 >);

-- Mostre a quantidade de pedidos dos clientes que moram no RS ou em SC.
select count(pd.CodPedido) from pedido pd
where pd.CodCliente = any(select cl.CodCliente from cliente cl where Uf like '%RS%' or '%SC%') group by pd.CodCliente;

-- Mostre o código do produto, o nome e o valor unitário dos produtos que possuam pedidos para
-- serem entregues entre os dias 01/12/2014 e 31/01/2015. Ordene a lista pelo valor unitário decrescente dos produtos. 
select pr.CodProduto,descricao,ValorUnitario from produto pr
where pr.CodProduto = any(select ip.CodProduto from itempedido ip
where ip.CodPedido = any(select pd.CodPedido from pedido pd
where PrazoEntrega between "2014/12/01" and "2015/01/31")) order by ValorUnitario desc;

-- Exiba os dados dos clientes que fizeram pedidos com mais de 60 itens, observe que esta é a
-- quantidade total de itens, independentemente de serem produtos iguais ou diferentes.
select cl.* from cliente cl
where cl.CodCliente = any(select pd.CodCliente from pedido pd
where pd.CodPedido = any(select ip.CodPedido from itempedido ip
where (select sum(quantidade) from itempedido) > 60 group by ip.CodPedido));

-- Crie uma consulta que exiba o código do cliente, o nome do cliente e o número dos seus
-- pedidos ordenados pelo nome e posteriormente pelo código do pedido. Somente devem ser
-- exibidos os pedidos dos vendedores que possuem a faixa de comissão “A”.
select cl.CodCliente,cl.nome,pd.CodPedido from
cliente cl right join pedido pd
on cl.CodCliente = pd.CodCliente
where pd.CodVendedor = any(select vd.CodVendedor from vendedor vd
where FaixaComissao like '%A%')
order by cl.nome,pd.CodPedido;

-- Crie uma consulta que exiba o nome do cliente, endereço, cidade, UF, CEP, código do pedido
-- e prazo de entrega dos pedidos que NÃO sejam de vendedores que ganham menos de R$ 1500,00.
select cl.nome, cl.endereco, cl.cidade, cl.uf, cl.cep, pd.CodPedido, pd.PrazoEntrega
from cliente cl right join pedido pd
on cl.CodCliente = pd.CodCliente
where pd.CodVendedor != any(select vd.CodVendedor from vendedor vd where SalarioFixo < 1500);

-- Crie uma consulta que exiba o nome do cliente, cidade e estado, dos clientes que fizeram
-- algum pedido no ano de 2015. Ordene os resultados pelos nomes dos clientes em ordem alfabética.
select cl.nome, cl.cidade, cl.uf
from cliente cl
where cl.CodCliente = any(select pd.CodCliente from pedido pd
where year(DataPedido) = 2015) order by cl.nome asc;

-- Crie uma consulta que exiba o código do pedido e o somatório da quantidade de itens desse
-- pedido. Devem ser exibidos somente os pedidos em que o somatório das quantidades de itens
-- de um pedido seja maior que a média da quantidade de itens de todos os pedidos.
select ip.CodPedido, quantidade
from itempedido ip where quantidade > (select avg(quantidade) from itempedido);

-- Crie uma consulta que exiba o nome do cliente, o nome do vendedor de seu último pedido e o
-- estado do cliente. Devem ser exibidos apenas os clientes do Rio Grande do Sul e apenas o último vendedor.
select cl.nome, vd.nome as vendedor, cl.uf, DataPedido
from cliente cl right join pedido pd
on pd.CodCliente = cl.CodCliente
right join vendedor vd
on pd.CodVendedor = vd.CodVendedor
where uf like '%RS%' and DataPedido = any(select max(DataPedido) from pedido pd group by pd.CodVendedor);
;									

-- Selecione o nome do produto e o valor unitário dos produtos que possuem o valor unitário
-- maior que todos os produtos que comecem com a letra L. A lista deve ser ordenada em ordem alfabética.
select pr.descricao, pr.ValorUnitario as VALOR
from produto pr
where pr.ValorUnitario > all(Select count(CodProduto) from produto where descricao like 'L%' group by CodProduto)
order by descricao asc;

-- Selecione o código do produto, o nome do produto e o valor unitário dos produtos que
-- possuam pelo menos um pedido com mais de 9 itens em sua quantidade. A lista deve ser
-- ordenada pelo valor unitário em ordem decrescente.
select pr.CodProduto,pr.descricao
from produto pr inner join itempedido ip
on pr.CodProduto = ip.CodProduto
where 9 > any(select sum(quantidade) from itempedido group by CodPedido,CodProduto)
order by pr.ValorUnitario desc;

-- Selecione o código do vendedor e o nome dos vendedores que não tenham vendido nenhum
-- pedido com prazo de entrega em Agosto de 2015. A lista deve ser ordenada pelo nome dos vendedores em ordem alfabética.
select pd.CodVendedor, vd.nome as Vendedor
from vendedor vd inner join pedido pd
on vd.CodVendedor = pd.CodVendedor
where  pd.CodPedido != any(select CodPedido from pedido where year(PrazoEntrega) = 2015 and month(PrazoEntrega) = 8)
group by CodVendedor
order by Vendedor asc;

-- Selecione o código do cliente e o nome dos clientes que tenham feitos pedidos em Abril de
-- 2014. A lista deve ser ordenada pelo nome dos clientes em ordem alfabética 
select pd.CodCliente, cl.nome as Cliente
from cliente cl inner join pedido pd
on cl.CodCliente = pd.CodCliente
where pd.CodPedido = any(select CodPedido from pedido where month(DataPedido) = 4 and year(DataPedido) = 2014)
group by cl.CodCliente
order by Cliente asc;

