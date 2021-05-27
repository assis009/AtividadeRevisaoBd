create database ex01
go 
use ex01

go 

create table aluno(

ra int not null,
nome varchar(30) not null,
sobrenome varchar(30) not null,
rua varchar(35) not null,
numero int not null,
bairro varchar(35) not null,
cep varchar(8) not null,
telefone varchar(9) null

primary key(ra)
)

go 

create table cursos(

codigo int not null, 
nome varchar(30) not null,
carga_horaria int not null,
turno varchar(10) not null


primary key(codigo)
)

go 

create table disciplinas(

codigo int not null,
nome  varchar(30) not null, 
carga_horaria int not null, 
turno varchar(10) not null,
semestre int not null

primary key (codigo)

)

-- Nome e sobrenome, como nome completo dos Alunos Matriculados

select nome + ' '+sobrenome as nome_completo
from aluno

--Rua, nº , Bairro e CEP como Endereço do aluno que não tem telefone

select a.rua+' '+ a.bairro +' ' + a.cep as endereco
from aluno a
where telefone = ''

-- Telefone do aluno com RA 12348
select telefone 
from aluno 
where ra = 12348


--Nome e Turno dos cursos com 2800 horas

select nome, turno
from cursos
where carga_horaria>=2800

--O semestre do curso de Banco de Dados I noite
select semestre
from disciplinas
where nome like 'Banco%' and turno like 'Noite'
