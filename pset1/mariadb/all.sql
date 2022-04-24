/*
* 1. Criando usuário e banco de dados.
*/

-- Criando o usuário do SGBD
CREATE USER IF NOT EXISTS izadora 
    IDENTIFIED BY '123456';

-- Cria Banco de dados UVV com suas propriedades e permissões
CREATE DATABASE IF NOT EXISTS uvv;

-- Concede todos privilégios de administrador ao usuário
GRANT ALL PRIVILEGES ON uvv.* TO izadora; 

-- Entra com o usuário criado no SGBD
SYSTEM mysql -u izadora -p;

-- Entra no Bando de Dados criado
use uvv;

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
* 2. Criando tabelas do Banco de Dados.
*/

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


-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
* 3. Crindo os relacionamentos entre as tabelas
*/


-- Table comments
ALTER TABLE uvv.trabalha_em COMMENT 'Tabela que armazena quais funcionários trabalham em quais projetos.';
-- End Table trabalha_em

ALTER TABLE uvv.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES uvv.funcionario (cpf)
ON UPDATE CASCADE 
ON DELETE SET DEFAULT ;

ALTER TABLE uvv.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES uvv.funcionario (cpf)
ON UPDATE CASCADE 
ON DELETE RESTRICT;

ALTER TABLE uvv.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES uvv.funcionario (cpf)
ON UPDATE CASCADE 
ON DELETE SET DEFAULT ;

ALTER TABLE uvv.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES uvv.funcionario (cpf)
ON UPDATE CASCADE 
ON DELETE SET DEFAULT ;

ALTER TABLE uvv.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES uvv.departamento (numero_departamento)
ON UPDATE CASCADE 
ON DELETE SET DEFAULT ;

ALTER TABLE uvv.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES uvv.departamento (numero_departamento)
ON UPDATE CASCADE 
ON DELETE SET DEFAULT ;

ALTER TABLE uvv.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES uvv.projeto (numero_projeto)
ON UPDATE CASCADE 
ON DELETE SET DEFAULT ;

SET FOREIGN_KEY_CHECKS=1; -- to re-enable them

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
* 4. Inserindo dados nos arquivos do banco de dados.
*/

INSERT INTO uvv.funcionario
    (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) VALUES
        ('Jorge'    , 'E'   , 'Brito'    , '88866555576'    , '1937-11-10'  , 'R.do Horto,35,São Paulo,SP'            , 'M' , 55000 , NULL          , 1),
        ('Fernando' , 'T'   , 'Wong'     , '33344555587'    , '1955-12-08'  , 'R.da Lapa,34,São Paulo,SP'             , 'M' , 40000 , '88866555576' , 5),
        ('João'     , 'B'   , 'Silva'    , '12345678966'    , '1965-01-09'  , 'R.das Flores,751,São Paulo,SP'         , 'M' , 30000 , '33344555587' , 5),
        ('Jennifer' , 'S'   , 'Souza'    , '98765432168'    , '1941-06-20'  , 'Av. Arthur de Lima,54,Santo André,SP'  , 'F' , 43000 , '88866555576' , 4),
        ('Ronaldo'  , 'K'   , 'Lima'     , '66688444476'    , '1962-09-15'  , 'R.Rebouças,65,Piracicaba,SP'           , 'M' , 38000 , '33344555587' , 5),
        ('Joice'    , 'A'   , 'Leite'    , '45345345376'    , '1972-07-31'  , 'Av.Lucas Obes,74,São Paulo,SP'         , 'F' , 25000 , '33344555587' , 5),
        ('André'    , 'V'   , 'Perreira' , '98798798733'    , '1969-03-29'  , 'R.Timbira,35,São Paulo,SP'             , 'M' , 25000 , '98765432168' , 4),
        ('Alice'    , 'J'   , 'Zelaya'   , '99988777767'    , '1968-01-19'  , 'R.Souza Lima,35,Curitiba,PR'           , 'F' , 25000 , '98765432168' , 4)
;


-- Inserindo valores para a tabela dependente
INSERT INTO uvv.dependente 
    (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco) VALUES
        ('33344555587'  , 'Alicia'    , 'F', '1986-04-05', 'Filha'),
        ('33344555587'  , 'Tiago'     , 'M', '1983-10-25', 'Filho'),
        ('33344555587'  , 'Janaína'   , 'F', '1958-05-03', 'Esposa'),
        ('98765432168'  , 'Antonio'   , 'M', '1942-02-28', 'Marido'),
        ('12345678966'  , 'Michael'   , 'M', '1988-01-04', 'Filho'),
        ('12345678966'  , 'Alicia'    , 'F', '1988-12-30', 'Filha'),
        ('12345678966'  , 'Elizabeth' , 'F', '1967-05-05', 'Esposa')
;


-- Inserindo valor para a tabela departamento
INSERT INTO uvv.departamento
    (nome_departamento,numero_departamento,cpf_gerente,data_inicio_gerente) VALUES
        ('Pesquisa'     , 5, '33344555587', '1988-05-22'),
        ('Administração', 4, '98765432168', '1995-01-01'),
        ('Matriz'       , 1, '88866555576', '1981-06-19')
;


-- Inserindo valores para a tabela localizacoes_departamento
INSERT INTO uvv.localizacoes_departamento
    (numero_departamento,local) VALUES
        (1  , 'São Paulo'),
        (4  , 'Mauá'),
        (5  , 'Santo André'),
        (5  , 'Itu'),
        (5  , 'São Paulo')
;


-- Inserindo valores para a tabela projeto
INSERT INTO uvv.projeto 
    (nome_projeto, numero_projeto, local_projeto, numero_departamento) VALUES
        ('ProdutoX'         , 1     , 'Santo André' , 5),
        ('ProdutoY'         , 2     , 'Itu'         , 5),
        ('ProdutoZ'         , 3     , 'São Paulo'   , 5),
        ('Informatização'   , 10    , 'Maué'        , 4),
        ('Reorganização'    , 20    , 'São Paulo'   , 1),
        ('Novosbenefícios'  , 30    , 'Mauá'        , 4)
;


-- Inserindo valores para a tabela trabalha_em
INSERT INTO uvv.trabalha_em 
    (cpf_funcionario,numero_projeto,horas) VALUES
        ('12345678966'  , 1   , 32.5),
        ('12345678966'  , 2   , 7.5),
        ('66688444476'  , 3   , 40.0),
        ('45345345376'  , 1   , 20.0),
        ('45345345376'  , 2   , 20.0),
        ('33344555587'  , 2   , 10.0),
        ('33344555587'  , 3   , 10.0),
        ('33344555587'  , 10  , 10.0),
        ('33344555587'  , 20  , 10.0),
        ('99988777767'  , 30  , 30.0),
        ('99988777767'  , 10  , 10.0),
        ('98798798733'  , 10  , 35.0),
        ('98798798733'  , 30  , 5.0),
        ('98765432168'  , 30  , 20.0),
        ('98765432168'  , 20  , 15.0),
        ('88866555576'  , 20  , null)
;