-- Desabilita a checagem das ForeignKeys pra fazer atualização do Banco de Dados
SET FOREIGN_KEY_CHECKS=0; -- to disable them

-- Drop Table departamento
DROP TABLE IF EXISTS uvv.departamento CASCADE;

-- Create Table departamento
CREATE TABLE IF NOT EXISTS uvv.departamento (
	numero_departamento INTEGER 	NOT NULL 	COMMENT 'Número do departamento. É a PK desta tabela.' 
		CHECK (numero_departamento > 0 AND numero_departamento < 21),
	nome_departamento 	VARCHAR(15) NOT NULL 	COMMENT 'Nome do departamento. Deve ser único.',
	cpf_gerente 		CHAR(11) 	NOT NULL 	COMMENT 'CPF do gerente do departamento. É uma ForeignKey para a tabela funcionários.',
	data_inicio_gerente DATE 		NOT NULL	COMMENT 'Data do início do gerente no departamento.',
	CONSTRAINT pk_departamento
		PRIMARY KEY (numero_departamento)
);

-- Table comments
ALTER TABLE uvv.departamento COMMENT 'Tabela que armazena as informaçoẽs dos departamentos.';

-- Cria Chave Alternativa
CREATE UNIQUE INDEX ak_departamento
ON uvv.departamento
( nome_departamento )
;
-- End departamento


-- Drop Table dependente
DROP TABLE IF EXISTS uvv.dependente CASCADE;

-- Create Table dependente
CREATE TABLE IF NOT EXISTS uvv.dependente (
	cpf_funcionario     CHAR(11)    NOT NULL	COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.',
	nome_dependente     VARCHAR(15) NOT NULL	COMMENT 'Nome do dependente. Faz parte da PK desta tabela.',
	sexo                CHAR(1)					COMMENT 'Sexo do dependente.' 	
		CHECK (sexo = 'm' OR sexo = 'f' OR sexo = 'M' OR sexo = 'F'),
	data_nascimento     DATE					COMMENT 'Data de nascimento do dependente.',
    	parentesco      VARCHAR(15)				COMMENT 'Descrição do parentesco do dependente com o funcionário.' ,
	CONSTRAINT pk_dependente 
        PRIMARY KEY (cpf_funcionario, nome_dependente)
);

-- Table comments
ALTER TABLE uvv.dependente COMMENT 'Tabela que armazena as informações dos dependentes dos funcionários.';
-- End Table dependente


-- Drop Table funcionario
DROP TABLE IF EXISTS uvv.funcionario CASCADE;

-- Create Table funcionarios
CREATE TABLE IF NOT EXISTS uvv.funcionario (
	cpf 				CHAR(11) 		NOT NULL	COMMENT 'CPF do funcionário. Será a PK da tabela.',
	primeiro_nome 		VARCHAR(15) 	NOT NULL	COMMENT 'Primeiro nome do funcionário.',
	nome_meio 			CHAR(1)						COMMENT 'Inicial do nome do meio.',
	ultimo_nome 		VARCHAR(15) 	NOT NULL	COMMENT 'Sobrenome do funcionário.',
	data_nascimento 	DATE						COMMENT 'Data de nascimento do funcionário.',
	endereco 			VARCHAR(100)				COMMENT 'Endereço do funcionário.',
	sexo 				CHAR(1)						COMMENT 'Sexo do funcionário'		
		CHECK (sexo = 'm' OR sexo = 'f' OR sexo = 'M' OR sexo = 'F'),
	salario 			DECIMAL(10,2) 				COMMENT 'Salário do funcionário'
		CHECK (salario > 0),
	cpf_supervisor 		CHAR(11) 					COMMENT 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).'
		CHECK (cpf_supervisor != cpf),
	numero_departamento INTEGER 		NOT NULL	COMMENT 'Número do departamento do funcionário.',
	CONSTRAINT pk_funcionario 
		PRIMARY KEY (cpf)
);

-- Table comments
ALTER TABLE uvv.funcionario COMMENT 'Tabela que armazena as informações dos funcionários.';
-- End Table Funcionario


-- Drop Table localizacoes_departamento
DROP TABLE IF EXISTS uvv.localizacoes_departamento CASCADE;

-- Create Table localizacoes_departamento
CREATE TABLE IF NOT EXISTS uvv.localizacoes_departamento (
	numero_departamento INTEGER     NOT NULL	COMMENT 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.',
	local               VARCHAR(15) NOT NULL	COMMENT 'Localização do departamento. Faz parte da PK desta tabela.',
	CONSTRAINT pk_localizacoes_departamento 
        PRIMARY KEY (numero_departamento,local)
);

-- Table comments
ALTER TABLE uvv.localizacoes_departamento COMMENT 'Tabela que armazena as possíveis localizações dos departamentos.';
-- End Table localizacoes_departamento


-- Drop Table projeto
DROP TABLE IF EXISTS uvv.projeto CASCADE;

-- Create Table projeto
CREATE TABLE IF NOT EXISTS uvv.projeto (
	numero_projeto      	INTEGER     NOT NULL	COMMENT 'Número do projeto. É a PK desta tabela.'
		CHECK (numero_projeto > 0),
    nome_projeto        	VARCHAR(15) NOT NULL	COMMENT 'Nome do projeto. Deve ser único.',
	local_projeto       	VARCHAR(15)				COMMENT 'Localização do projeto.',
    numero_departamento 	INTEGER     NOT NULL 	COMMENT 'Número do departamento. É uma FK para a tabela departamento.',
	CONSTRAINT pk_projeto 
        PRIMARY KEY (numero_projeto)
);

-- Table comments
ALTER TABLE uvv.projeto COMMENT 'Tabela que armazena as informações sobre os projetos dos departamentos.';

-- Cria Chave Alternativa
CREATE UNIQUE INDEX ak_projeto
ON uvv.projeto
( nome_projeto )
;
-- End Table projeto


-- Drop Table trabalha_em
DROP TABLE IF EXISTS uvv.trabalha_em CASCADE;

-- Create Table trabalha_em
CREATE TABLE IF NOT EXISTS uvv.trabalha_em (
	cpf_funcionario 	CHAR(11) 	NOT NULL	COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.',
	numero_projeto 		INTEGER 	NOT NULL	COMMENT 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.',
	horas				DECIMAL(10,2)			COMMENT 'Horas trabalhadas pelo funcionário neste projeto.'
		CHECK (horas > 0),
	CONSTRAINT pk_trabalha_em 
		PRIMARY KEY (cpf_funcionario, numero_projeto)
);