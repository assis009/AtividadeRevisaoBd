create database  ex03

go 

use ex03

create table paciente(

cpf varchar(11) not null,
nome varchar(30) not null, 
rua varchar (35) not null,
numero int not null,
bairro varchar(30) not null,
telefone varchar(9) null

primary key (cpf)

)

go 

create table medico(

codigo int not null,
nome varchar(30) not null,
especialidade varchar(20) not null

primary key(codigo)

)

go 

create table prontuario(

data_prontuario date not null,
cpf_paciente varchar(11) not null,
codigo_medico int not null,
diagnostico varchar(50) not null,
medicamento varchar(50) not null

primary key(data_prontuario, cpf_paciente, codigo_medico)
foreign key(cpf_paciente) references paciente(cpf),
foreign key(codigo_medico) references medico(codigo)


)


-- Nome e Endereço (concatenado) dos pacientes com mais de 50 anos
select p.nome, p.rua +'-'+convert(char(10),p.numero)+ ' '+p.bairro As endereco_completo
from paciente p


-- Qual a especialidade de Carolina Oliveira
select especialidade
from medico
where nome like 'Carolina%'

-- Qual medicamento receitado para reumatismo
select p.medicamento 
from prontuario p
where p.diagnostico like 'reumatismo'

-- Diagnóstico e Medicamento do paciente José Rubens em suas consultas

select pro.diagnostico, pro.medicamento 
from prontuario pro
where pro.cpf_paciente in 
(
	select cpf
	from paciente
	where nome like 'José%'
)

-- Nome e especialidade do(s) Médico(s) que atenderam José Rubens.
--Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)

select nome,
case when len(especialidade) > 3 then 
	SUBSTRING(especialidade, 1, 3) + '.'
else 
	especialidade
end as especialidade 
from medico 
where codigo in 
(
	select codigo_medico
	from prontuario
	where cpf_paciente in
	(
		select cpf 
		from paciente
		where nome like 'José%'
	)
)

-- CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo (Rua, nº - Bairro), 
--Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius

select SUBSTRING(cpf, 1,3) + '.'+ SUBSTRING(cpf, 4,6)+'.'+SUBSTRING(cpf, 7,9)+ ''+SUBSTRING(cpf, 10,11) as cpf,
nome, 
rua + ' n°'+ CONVERT(char(10), numero) +''+ bairro as endereco,
case when telefone = '' then	
	'-'
else 
	telefone
end as telefone
from paciente 
where cpf in 
(
	select cpf_paciente
	from prontuario
	where codigo_medico in
	(
		select codigo
		from medico 
		where nome like 'Vinicius%'
	)
)

-- Quantos dias fazem da consulta de Maria Rita até hoje

select data_prontuario, DATEDIFF(day,data_prontuario, getdate()) as dias_de_diferenca
from prontuario
where cpf_paciente in 
(
	select cpf
	from paciente
	where nome like	'Maria%'
)


-- Alterar o telefone da paciente Maria Rita, para 98345621
update paciente
set telefone = '98345621'
where nome = 'Maria Rita'

-- Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto
update paciente 
set rua = 'Voluntários da Pátria'
where nome = 'Joana de Souza'

update paciente 
set numero = 1980
where nome = 'Joana de Souza'

update paciente 
set bairro = 'Jd. Aeroporto'
where nome = 'Joana de Souza'


