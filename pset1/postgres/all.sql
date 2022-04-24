/*
* 1. Criação do usuário e banco de dados com suas determinadas propriedades
*/

-- Criando o usuário com seus privilégios dentro do SGBD
CREATE ROLE izadora WITH
    LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD '123456';

-- Criando o Banco de dados UVV com todas as suas propriedades e permissões
CREATE DATABASE uvv -- cria o banco de dados
    WITH
    OWNER = "izadora" -- adiciona o usuário proprietário do banco de dados
    TEMPLATE = template0 -- usa um determinado template do banco de dados
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt-BR.UTF-8'
    CONNECTION LIMIT = -1;      

-- Alterando o modelo de visualização de data para dia-mês-ano
ALTER DATABASE uvv SET datestyle TO SQL, DMY;

-- Alterando a conexão com o banco de dados anteriormente criado
\connect uvv;

/*
* Em determinados sistemas, o usuário pode não conseguir fazer a transição direta, caso isso aconteça, é recomendável que entre no BD manualmente.
* Para isso, irá utilizar o comando " psql uvv -U izadora ", e caso não entre diretamente, digite ao lado do camando " -W " e insira a senha " 123456 ".
*/

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
* 2. Criando o esquema e suas tabelas
*/

-- Criando o esquema elmasri
CREATE SCHEMA IF NOT EXISTS elmasri
    AUTHORIZATION "izadora";

-- Criando o usuário que será administrador do Banco de Dados
ALTER USER "izadora"
-- Com as tabelas criadas dentro do esquema elmasri, precisamos alterar o SEARCH_PATH para nos certificar de que tudo ocorra da maneira correta 
SET SEARCH_PATH TO elmasri, "\user", public;

CREATE TABLE elmasri.departamento(
    numero_departamento INTEGER NOT NULL DEFAULT 1,
    cpf_gerente CHAR(11),
    nome_departamento VARCHAR(15) NOT NULL,
    data_inicio_gerente DATE,
    PRIMARY KEY (numero_departamento)
); 
-- Criando a alternative key (ak) no atributo nome_departamento
CREATE UNIQUE INDEX nome_departamento_idx ON elmasri.departamento (nome_departamento);

CREATE TABLE elmasri.funcionario(
    cpf CHAR(11) NOT NULL,
    primeiro_nome VARCHAR(15) NOT NULL,
    nome_meio CHAR(1),
    ultimo_nome VARCHAR(15) NOT NULL,
    data_nascimento DATE,
    endereco VARCHAR(50),
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')), -- a constraint 'check' impede todo valor além 'M' e 'F'
    salario DECIMAL(10, 2) CHECK (salario > 0), -- sálario só tem a possibilidade de ser positivo
    cpf_supervisor CHAR(11) REFERENCES elmasri.funcionario(cpf),
    numero_departamento INTEGER NOT NULL REFERENCES elmasri.departamento(numero_departamento),
    PRIMARY KEY (cpf)
);

CREATE TABLE elmasri.projeto(
    numero_projeto INTEGER NOT NULL,
    nome_projeto VARCHAR(15) NOT NULL,
    local_projeto VARCHAR(15),
    numero_departamento INTEGER NOT NULL REFERENCES elmasri.departamento(numero_departamento),
    PRIMARY KEY (numero_projeto)
);

CREATE UNIQUE INDEX nome_projeto_idx ON elmasri.projeto (nome_projeto);

CREATE TABLE elmasri.trabalha_em(
    cpf_funcionario CHAR(11) NOT NULL REFERENCES elmasri.funcionario(cpf),
    numero_projeto INTEGER NOT NULL REFERENCES elmasri.projeto(numero_projeto),
    horas DECIMAL (3,1) CHECK (horas > 0), -- número de horas de trabalho só tem a possibilidade de ser positivo
    PRIMARY KEY (cpf_funcionario, numero_projeto)
);

CREATE TABLE elmasri.dependente(
    cpf_funcionario CHAR(11) NOT NULL REFERENCES elmasri.funcionario(cpf),
    nome_dependente VARCHAR(15) NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    data_nascimento DATE,
    parentesco VARCHAR(15),
    PRIMARY KEY (cpf_funcionario, nome_dependente)
);

CREATE TABLE elmasri.localizacoes_departamento(
    numero_departamento INTEGER NOT NULL REFERENCES elmasri.departamento(numero_departamento),
    local VARCHAR(15) NOT NULL,
    PRIMARY KEY (numero_departamento, local)
);

-- Primeiro, foram inseridas as informações do departamento, por serem necessárias para inserir o restante dos dados
INSERT INTO elmasri.departamento (nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES
('Matriz', 1, '', '19-06-1981'),
('Pesquisa', 5, '', '22-05-1988'),
('Administracao', 4, '', '01-01-1995');

/* 
Criando a Foreign Key (fk) da tabela departamento referenciando a tabela funcionário.
Foreign Key criada somente agora, para desviar possíveis problemas de relacionamento entre as tabelas.
*/
ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk FOREIGN KEY (cpf_gerente) REFERENCES elmasri.funcionario (cpf) ON UPDATE NO ACTION;

-- Comentários de maior importância, a respeito do metadados do SGBD
COMMENT ON TABLE elmasri.departamento IS 'Tabela que armazena as informaçoẽs dos departamentos';
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Número do departmento, sendo a Primary Key';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do Departamento, podendo ser apenas único';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Data de início do gerente no departamento';

COMMENT ON TABLE elmasri.funcionario IS 'Tabela que armazena as informações dos funcionários';
COMMENT ON COLUMN elmasri.funcionario.cpf IS 'CPF do funcionário, sendo a Pimary Key da tabela';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Primeiro nome do funcionário';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Inicial do nome do meio';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Sobrenome do funcionário';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Endereço do funcionário';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Sexo do funcionário';
COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor IS 'CPF do supervisor. Será uma Foreign Key para a própria tabela';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Número do departamento do funcionário, sendo o valor padrão "0"';

COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela que armazena as possíveis localizações dos departamentos';
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento, sendo parte da Primary Key desta tabela e também uma Foreign Key para a tabela departamento';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Localização do departamento. Faz parte da Primary Key desta tabela';

COMMENT ON TABLE elmasri.projeto IS 'Tabela de armazenamento das informações sobre os projetos dos departamentos';
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto, sendo a Primary Key desta tabela';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto, podendo ser apenas único';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localização do projeto';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Número do departamento, sendo uma Foreign Key da tabela departamento';

COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela de armazenamento de quais funcionários trabalham em quais projetos';
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'CPF do funcionário, sendo parte da Primary Key desta tabela e também uma Foreign KEY para a tabela funcionário';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Número do projeto, sendo parte da Primary Key desta tabela e também uma Foreign KEY para a tabela projeto';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas trabalhadas pelo funcionário no respectivo projeto';

COMMENT ON TABLE elmasri.dependente IS 'Tabela de armazenamento das informações dos dependentes dos funcionários';
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'CPF do funcionário, sendo parte da Primary Key desta tabela e também uma Foreign KEY para a tabela funcionário';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente, sendo a Primary Key desta tabela.';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Descrição do parentesco do dependente com o funcionário';

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
* 3. Criando os relacionamentos entre as tabelas
*/

ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localiza__es_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
* 4. Inserindo os dados no banco de dados.
*/

-- Inserindo os dados dos funcionários
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES
 ('Jorge', 'E', 'Brito', '88866555576','10-11-1937', 'Rua do Horto, 35, Sao Paulo, SP', 'M', 55000, NULL, 1);


-- Depois de definir Jorge, outros dois gerentes foram inseridos
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES
 ('Fernando', 'T', 'Wong', '33344555587','08-12-1955', 'Rua da Lapa, 34, Sao Paulo, SP', 'M', 40000, '88866555576', 1),
 ('Jennifer', 'S', 'Souza', '98765432168','20-06-1941', 'Av. Arthur de Lima, 54, Santo Andre, SP', 'F', 43000, '88866555576', 1);

UPDATE elmasri.departamento SET cpf_gerente = '88866555576' WHERE numero_departamento = 1;
UPDATE elmasri.departamento SET cpf_gerente = '98765432168' WHERE numero_departamento = 4;
UPDATE elmasri.departamento SET cpf_gerente = '33344555587' WHERE numero_departamento = 5;


-- Inserindo dados dos demais funcionários
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) 
VALUES
 ('Joao', 'B', 'Silva', '12345678966', '09-01-1965', 'Rua das Flores, 751, Sao Paulo, SP', 'M', 30000, '33344555587', 5),
 ('Alice', 'J', 'Zelaya', '99988777767', '19-01-1968', 'Rua Souza Lima, 35, Curitiba, PR', 'F', 25000, '98765432168', 4),
 ('Ronaldo', 'K', 'Lima', '66688444476', '15-09-1962', 'Rua Reboucas, 65, Piracicaba, SP', 'M', 38000, '33344555587', 5),
 ('Joice', 'A', 'Leite', '45345345376', '31-07-1972', 'Av. Lucas Obes, 74, Sao Paulo, SP','F', 25000, '33344555587', 5),
 ('Andre', 'V', 'Pereira', '98798798733', '29-03-1969', 'Rua Timbira, 35, Sao Paulo, SP', 'M', 25000, '98765432168', 4);

-- Inserindo as informações de localizações dos departamentos
INSERT INTO elmasri.localizacoes_departamento (numero_departamento, local)
VALUES
 (1, 'Sao Paulo'),
 (4, 'Maua'),
 (5, 'Santo Andre'),
 (5, 'Itu'),
 (5, 'Sao Paulo');

-- Inserindo dados da tabela de PROJETOS
INSERT INTO elmasri.projeto (nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES
 ('ProdutoX', 1, 'Santo Andre', 5),
 ('ProdutoY', 2, 'Itu', 5),
 ('ProdutoZ', 3, 'Sao Paulo', 5),
 ('Informatizacao', 10, 'Maua', 4),
 ('Reorganizacao', 20, 'Sao Paulo', 1),
 ('NovosBeneficios', 30, 'Maua', 4);

-- Inserindo dados da tabela DEPENDENTE
INSERT INTO elmasri.dependente (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES
 ('33344555587', 'Alicia', 'F', '05-04-1986', 'Filha'),
 ('33344555587', 'Tiago', 'M', '25-10-1983', 'Filho'),
 ('33344555587', 'Janaina', 'F', '03-05-1958', 'Esposa'),
 ('98765432168', 'Antonio', 'M', '28-02-1942', 'Marido'),
 ('12345678966', 'Michael', 'M', '04-01-1988', 'Filho'),
 ('12345678966', 'Alicia', 'F', '30-12-1988', 'Filha'),
 ('12345678966', 'Elizabeth', 'F', '05-05-1967', 'Esposa');

-- Inserindo dados da tabela TRABALHA EM
INSERT INTO elmasri.trabalha_em (cpf_funcionario, numero_projeto, horas)
VALUES
 ('12345678966', 1, 32.5),
 ('12345678966', 2, 7.5),
 ('66688444476', 3, 40.0),
 ('45345345376', 1, 20.0),
 ('45345345376', 2, 20.0),
 ('33344555587', 2, 10.0),
 ('33344555587', 3, 10.0),
 ('33344555587', 10, 10.0),
 ('33344555587', 20, 10.0),
 ('99988777767', 30, 30.0),
 ('99988777767', 10, 10.0),
 ('98798798733', 10, 10.0),
 ('98798798733', 30, 5.0),
 ('98765432168', 30, 20.0),
 ('98765432168', 20, 15.0),
 ('88866555576', 20, NULL);