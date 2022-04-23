-- CRIANDO O ESQUEMA ELMASRI
CREATE SCHEMA IF NOT EXISTS elmasri
    AUTHORIZATION "izadora";

-- CRIANDO O USUÁRIO QUE SERÁ ADMINISTRADOR DO BANCO DE DADOS
ALTER USER "izadora"
-- TABELAS CRIADAS DENTRO DO ESQUEMA ELMASRI. PARA QUE TUDO OCORRA DA MANEIRA CORRETA, PRECISAMOS ALTERAR O SEARCH_PATH. 
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

-- COMENTÁRIOS DE MAIOR IMPORTÂNCIA, A RESPEITO DOS METADADOS DO SGBD
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

