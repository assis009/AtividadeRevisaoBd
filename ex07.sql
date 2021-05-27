create database ex07

go 

use ex07 

create table cliente (
rg varchar(11) not null,
cpf varchar(14) not null,
nome varchar(50) not null,
endereco varchar(100) not null

primary key(rg)

)

go 

create table pedido(

nota_fiscal int not null,
valor float not null,
data_pedido date not null,
rg_cliente varchar(11) not null

primary key(nota_fiscal) 
foreign key (rg_cliente) references cliente(rg)

)

go




create table fornecedor(

codigo int not null,
nome varchar(30) not null,
endereco varchar(100) not null,
telefone varchar(15) null,
cgc varchar (14) null,
cidade varchar (50) null,
transporte varchar(20) null,
pais varchar(20) null,
mode varchar(10) null

primary key(codigo)

)

go 

create table mercadoria (

codigo int not null,
descricao varchar(30),
preco float not null,
qtde int not null,
cod_fornecedor int not null

primary key(codigo)
foreign key(cod_fornecedor) references fornecedor(codigo)

)


-- Consultar 10% de desconto no pedido 1003

select p.valor, p.valor - (p.valor*0.10) as desconto
from pedido p
where p.nota_fiscal = 1003


-- Consultar 5% de desconto em pedidos com valor maior de R$700,00
select p.valor,
case when p.valor > 700 then 
	 p.valor - (p.valor*0.05)
else 
	p.valor
end as desconto
from pedido p

-- Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10
select m.descricao, m.preco, m.preco - (m.preco*0.20) as aumento 
from mercadoria m
where qtde<10

-- Data e valor dos pedidos do Luiz
select data_pedido, valor
from pedido
where rg_cliente in 
(
	select rg
	from cliente
	where nome like 'Luiz%'
)

-- CPF, Nome e endereço do cliente de nota 1004
select nome, endereco
from cliente 
where rg in
(
	select rg_cliente
	from pedido
	where nota_fiscal = 1004 

)

-- País e meio de transporte da Cx. De som
select pais, transporte 
from fornecedor
where codigo in 
(
	select m.cod_fornecedor
	from mercadoria m
	where m.descricao like 'Cx%'
)

-- Nome e Quantidade em estoque dos produtos fornecidos pela Clone

select descricao, qtde 
from mercadoria
where cod_fornecedor in 
(
	select codigo
	from fornecedor 
	where nome like 'Clone'

)

-- Endereço e telefone dos fornecedores do monitor
select endereco, telefone 
from fornecedor 
where codigo in (
	
	select cod_fornecedor 
	from mercadoria
	where descricao like 'Mouse'
)


-- Tipo de moeda que se compra o notebook

select mode
from fornecedor f
where codigo in (
	
	select cod_fornecedor 
	from mercadoria
	where descricao like 'notebook'
)

-- Há quantos dias foram feitos os pedidos e,
--criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses

select DATEDIFF(DAY,data_pedido, getdate()) as dias_passados_do_pedido,
case when DATEDIFF(DAY,data_pedido, getdate()) > 6 then
	'Pedido antigo'
else 
	'-'
end as pedidos_antigos
from pedido

-- Nome e Quantos pedidos foram feitos por cada cliente

select c.nome, count(nota_fiscal) as qtde_pedidos
from pedido p, cliente c 
where c.rg = p.rg_cliente
group by c.nome

-- RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos

select c.nome, c.rg, c.cpf, c.endereco
from cliente c left outer join pedido p
on c.rg = p.rg_cliente
	where p.nota_fiscal is null
