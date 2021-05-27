create database ex04

go 

use ex04

create table cliente(

cpf varchar(11) not null,
nome varchar(30) not null, 
telefone varchar(9) not null

primary key(cpf) 
)

go 

create table fornecedor(

id int not null,
nome varchar(30) not null,
logradouro varchar(50) not null,
numero int not null,
complemento varchar(30) not null,
cidade varchar(30) not null

primary key(id)

)

create table produto(

codigo int not null,
descricao varchar(50) not null,
fornecedor_id int not null, 
preco float not null

primary key(codigo)
foreign key(fornecedor_id) references fornecedor (id)
)

go

create table venda (

codigo int not null,
produto_codigo int not null,
cliente_cpf varchar(11) not null,
qtde int not null, 
valor float not null,
data_venda date not null

primary key(codigo, produto_codigo, cliente_cpf)
foreign key(produto_codigo) references produto(codigo),
foreign key(cliente_cpf) references cliente(cpf)
)

-- Consultar no formato dd/mm/aaaa:
-- Data da Venda 4

select convert(char(10),data_venda,103) as data_de_venda
from venda
where codigo = 4

-- Inserir na tabela Fornecedor, a coluna Telefone
-- e os seguintes dados:
/*
1	7216-5371
2	8715-3738
4	3654-6289
*/

alter table fornecedor 
add  telefone varchar (9)  null

update fornecedor 
set telefone = '72165371'
where id = 1

update fornecedor 
set telefone = '87153738'
where id = 2

update fornecedor 
set telefone = '36546289'
where id = 4

-- Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores

select f.nome, f.logradouro +' - '+convert(char(10),f.numero) + ' '+ f.complemento
from fornecedor f
order by f.nome


-- Produto, quantidade e valor total do comprado por Julio Cesar
select v.produto_codigo, v.valor
from venda v
where v.cliente_cpf in 
(
	select cpf
	from cliente
	where nome like 'Julio%'
)

-- Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar

select convert(char(10),v.data_venda,103), v.valor
from venda v
where v.cliente_cpf in 
(
	select cpf
	from cliente
	where nome like 'Paulo%'
)


-- Consultar, em ordem decrescente, o nome e o preço de todos os produtos 
select descricao, preco 
from produto 
order by descricao desc