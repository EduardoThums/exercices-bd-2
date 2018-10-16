-- Mostrar a quantidade pedida para um determinado produto com um determinado
-- código a partir da tabela item de pedido.
select pr.CodProduto,sum(quantidade) from itempedido ip right join produto pr on pr.CodProduto = ip.CodProduto group by pr.CodProduto; 

-- Listar a quantidade de produtos que cada pedido contém
select count(quantidade),pd.CodPedido from itempedido ip
left join pedido pd on pd.CodPedido = ip.CodPedido group by ip.CodPedido;

-- Ver os pedidos de cada cliente, listando nome do cliente e número do pedido.
select pd.CodPedido,cl.nome from pedido pd right join cliente cl on pd.CodCliente = cl.CodCLiente;

-- Listar todos os clientes com seus respectivos pedidos. Os clientes que não têm
-- pedidos também devem ser apresentados.
select cl.CodCLiente,pd.CodPedido from pedido pd right join cliente cl on cl.CodCliente = pd.CodCliente order by pd.CodPedido;

-- Clientes com prazo de entrega superior a 10 dias e que pertençam aos estados do
-- Rio Grande do Sul ou Santa Catarina.
select cl.CodCliente from pedido pd inner join cliente cl where PrazoEntrega > 10 and Uf like '%RS%' or '%SC%';

-- Mostrar os clientes e seus respectivos prazos de entrega, ordenando do maior para o menor
select cl.CodCliente,PrazoEntrega from cliente cl right join pedido pd on cl.CodCliente  = pd.CodCliente order by PrazoEntrega desc;

-- Apresentar os vendedores, em ordem alfabética, que emitiram pedidos com prazos
-- de entrega superiores a 15 dias e que tenham salários fixos iguais ou superiores a R$ 1.000,00
select vd.nome,pd.CodVendedor from vendedor vd join pedido pd on pd.CodVendedor = vd.CodVendedor
where PrazoEntrega > 15 and SalarioFixo >= 1.000 group by pd.CodVendedor order by vd.nome asc;

-- Os vendedores têm seu salário fixo acrescido de 20% da soma dos valores dos
-- pedidos. Faça uma consulta que retorne o nome dos funcionários e o total de comissão, desses funcionários.
select vd.nome,SalarioFixo+0.2*sum(quantidade*ValorUnitario) as Comissao
from itempedido ip inner join produto pr 
on ip.CodProduto = pr.CodProduto
inner join pedido pd 
on pd.CodPedido = ip.CodPedido
inner join vendedor vd 
on vd.CodVendedor = pd.CodVendedor
group by pd.CodVendedor;

-- Os clientes e os respectivos vendedores que fizeram algum pedido para esse
-- cliente, juntamente com a data do pedido.
select vd.CodVendedor,cl.CodCliente, DataPedido
from pedido pd 
left join vendedor vd
on vd.CodVendedor = pd.CodVendedor
inner join cliente cl
on cl.CodCliente  = pd.CodCliente order by pd.CodVendedor;

-- Liste o nome do cliente e a quantidade de pedidos de cada cliente.
select cl.nome,count(pd.CodPedido) as NumeroDePedidos
from cliente cl left join pedido pd
on cl.CodCLiente = pd.CodCliente
group by cl.CodCLiente;

-- Liste o nome do cliente, o código do pedido e a quantidade total de produtos por pedido.
select cl.nome,pd.CodPedido,quantidade
from cliente cl inner join pedido pd
on pd.CodCliente = cl.CodCliente
right join itempedido ip
on pd.CodPedido = ip.CodPedido;

-- Liste o nome do cliente, o código do pedido e o valor total do pedido.
select cl.nome,ip.CodPedido,sum(ValorUnitario*quantidade) as ValorDoPedido
from cliente cl
inner join pedido pd
on cl.CodCliente  = pd.CodCliente
right join itempedido ip
on pd.CodPedido = ip.CodPedido
right join produto pr
on ip.CodProduto = pr.CodProduto
group by ip.CodPedido;

-- Liste os produtos, a quantidade vendida e a data dos pedidos realizados no mês de
-- maio de 2015, começando pelos mais vendidos.
select pr.descricao,sum(quantidade) as TotalDeVendas,DataPedido
from pedido pd
right join itempedido ip
on pd.CodPedido = ip.CodPedido
right join produto pr
on ip.CodProduto = pr.CodProduto
where month(DataPedido) = 5 and year(DataPedido) = 2015
group by ip.CodPedido, pr.CodProduto
order by TotalDeVendas desc;

-- Liste os produtos, do mais caro para o mais barato, dos pedidos no mês de junho
-- (considerando todos os anos).
select pr.descricao
from pedido pd
inner join itempedido ip
on pd.CodPedido = ip.CodPedido
right join produto pr
on ip.CodProduto = pr.CodProduto
where month(DataPedido) = 6
order by ValorUnitario desc;

-- Exiba a relação dos pedidos mais caros de todos os tempos. Esta relação deve
-- conter o nome do cliente, do vendedor, o código do pedido e o valor total do pedido.
select cl.nome as Cliente,vd.nome as Vendedor,ip.CodPedido,sum(quantidade*ValorUnitario) as ValorDoPedido
from cliente cl
left join pedido pd
on cl.CodCliente = pd.CodCliente
right join vendedor vd
on vd.CodVendedor = pd.CodVendedor
inner join itempedido ip
on pd.CodPedido = ip.CodPedido
right join produto pr
on ip.CodProduto = pr.CodProduto
group by ip.CodPedido,pd.CodCliente,pd.CodVendedor
order by ValorDoPedido desc;

-- Exiba a relação com os melhores vendedores (considerando apenas a quantidade
-- de pedidos) para o mês de setembro (incluindo todos os anos). Exiba o nome do
-- vendedor, o ano e o número total de pedidos daquele ano.
select vd.nome as Vendedor,year(DataPedido) Ano,count(pd.CodPedido) as NumDePedidos
from vendedor vd
right join pedido pd
on vd.CodVendedor = pd.CodVendedor
where month(DataPedido) = 9
group by Ano,pd.CodVendedor
order by NumDePedidos desc;

-- Liste o nome dos clientes e o total de pedidos de cada cliente, em ordem crescente
-- de pedidos. Os clientes sem pedidos também devem ser listados.
select cl.nome,count(pd.CodPedido) Pedidos
from cliente cl
left join pedido pd
on cl.CodCliente = pd.CodCliente
group by cl.CodCliente
order by Pedidos asc;

-- Exiba uma relação em ordem alfabética do código do cliente e nome dos clientes
-- que nunca fizeram nenhum pedido.
select cl.nome as Cliente,cl.CodCliente
from cliente cl left join pedido pd
on cl.CodCliente = pd.CodCliente
where pd.CodPedido is null;

-- Mostre o código do produto, a descrição e o valor total obtido por cada produto ao
-- longo da história da loja. Ordene a lista pelo valor total dos produtos. Observe que
-- mesmo os produtos que nunca foram vendidos devem ser exibidos.
select pr.CodProduto,pr.descricao,sum(quantidade*ValorUnitario) as ValorTotal
from itempedido ip
right join produto pr
on ip.CodProduto = pr.CodProduto
group by pr.CodProduto 
order by ValorTotal desc;

-- Mostre todos os dados dos vendedores e a quantidade total de pedidos efetuados
-- por cada vendedor. A relação deve contar apenas os vendedores de faixa de
-- comissão “A” e ordenados pela quantidade total de pedidos. Mesmo os vendedores
-- sem pedidos devem ser listados.
select vd.*,count(pd.CodPedido) as TotalDePedidos
from vendedor vd
left join pedido pd
on vd.CodVendedor = pd.CodVendedor
where FaixaComissao like '%A%'
group by vd.CodVendedor
order by TotalDePedidos asc;