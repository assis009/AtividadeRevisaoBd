create database ex02

go 

use ex02

create table carro(
placa varchar(7) not null,
modelo varchar(30) not null,
marca varchar(10) not null,
cor varchar(10) not null, 
ano int not null

primary key(placa)

)

go 


create table cliente(

nome varchar(30) not null, 
logradouro varchar(50) not null, 
numero int not null, 
bairro varchar (50),
telefone varchar(9) not null,
carro varchar(7) not null

primary key(carro)
foreign key (carro) references carro(placa)
)

go 


create table pecas(

codigo int not null,
nome varchar(30) not null,
valor int not null,

primary key(codigo)
)

go 

create table servico(

carro_placa varchar(7) not null,
codigo_peca int not null,
quantidade int not null,
valor int not null,
data datetime not null

primary key(carro_placa, codigo_peca, data)
foreign key(carro_placa) references carro(placa),
foreign key(codigo_peca) references pecas(codigo)

)

-- Telefone do dono do carro Ka, Azul
select telefone 
from cliente
where carro in (
	select placa 
	from carro
	where cor like 'Azul'
)

-- Endereço concatenado do cliente que fez o serviço do dia 02/08/2009
select c.bairro+ ' '+ c.logradouro+ ' '+ convert(char(10), c.numero) as endereco
from cliente c 
where c.carro in 
(
	select carro_placa
	from servico 
	where data = '02/08/2009'

)


--Placas dos carros de anos anteriores a 2001

select placa
from carro 
where ano<2001

-- Marca, modelo e cor, concatenado dos carros posteriores a 2005

select marca + ' '+modelo+' '+cor as marca_modelo_cor
from carro
where ano > 2006


-- Código e nome das peças que custam menos de R$80,00

select codigo, nome 
from pecas
where valor > 80