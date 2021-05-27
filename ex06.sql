CREATE DATABASE ex06
GO

USE ex06
GO

CREATE TABLE motorista(
    codigo INT NOT NULL,
    nome VARCHAR(20) NOT NULL,
    idade INT NOT NULL,
    naturalidade VARCHAR(30) NOT NULL
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE onibus(
    placa VARCHAR(20) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    ano INT NOT NULL,
    descricao VARCHAR(30) NOT NULL
    PRIMARY KEY(placa)
)
GO

CREATE TABLE viagem(
    codigo INT NOT NULL,
    onibus VARCHAR(20) NOT NULL,
    motorista INT NOT NULL,
    hora_saida INT,
    hora_chegada INT,
    destino VARCHAR(20)
    PRIMARY KEY(codigo)
    FOREIGN KEY(onibus) REFERENCES onibus(placa),
    FOREIGN KEY(motorista) REFERENCES motorista(codigo)
)
GO

-- Consultar, da tabela viagem, todas as horas de chegada e saída, convertidas em formato HH:mm (108) e seus destinos
SELECT CONVERT(CHAR(02), viagem.hora_chegada) + ' h' AS hora_chegada, CONVERT(CHAR(02), viagem.hora_saida) + ' h' AS hora_saida
FROM viagem

-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba
SELECT motorista.nome
FROM motorista
WHERE motorista.codigo IN (
    SELECT viagem.motorista
    FROM viagem
    WHERE viagem.destino LIKE 'Sorocaba'
)

-- Consultar, com subquery, a descrição do ônibus que vai para o Rio de Janeiro
SELECT onibus.descricao
FROM onibus
WHERE onibus.placa IN (
    SELECT viagem.onibus
    FROM viagem
    WHERE viagem.destino LIKE 'Rio de%'
)

--Consultar, com Subquery, a descrição, a marca e o ano do ônibus dirigido por Luiz Carlos
SELECT onibus.descricao, onibus.marca, onibus.ano
FROM onibus
WHERE onibus.placa IN (
    SELECT viagem.onibus
    FROM viagem
    WHERE viagem.motorista IN (
        SELECT motorista.codigo
        FROM motorista
        WHERE motorista.nome LIKE 'Luiz Carlos'
    )
)

-- Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos
SELECT motorista.nome, motorista.idade, motorista.naturalidade
FROM motorista
WHERE motorista.idade > 30
