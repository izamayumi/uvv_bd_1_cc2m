-- INSERINDO OS DADOS DOS FUNCIONÁRIOS
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES
 ('Jorge', 'E', 'Brito', '88866555576','10-11-1937', 'Rua do Horto, 35, Sao Paulo, SP', 'M', 55000, NULL, 1);


-- DEPOIS DE DEFINIR JORGE, OUTROS DOIS GERENTES FORAM INSERIDOS 
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES
 ('Fernando', 'T', 'Wong', '33344555587','08-12-1955', 'Rua da Lapa, 34, Sao Paulo, SP', 'M', 40000, '88866555576', 1),
 ('Jennifer', 'S', 'Souza', '98765432168','20-06-1941', 'Av. Arthur de Lima, 54, Santo Andre, SP', 'F', 43000, '88866555576', 1);

UPDATE elmasri.departamento SET cpf_gerente = '88866555576' WHERE numero_departamento = 1;
UPDATE elmasri.departamento SET cpf_gerente = '98765432168' WHERE numero_departamento = 4;
UPDATE elmasri.departamento SET cpf_gerente = '33344555587' WHERE numero_departamento = 5;


-- INSERINDO DADOS DOS DEMAIS FUNCIONÁRIOS
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) 
VALUES
 ('Joao', 'B', 'Silva', '12345678966', '09-01-1965', 'Rua das Flores, 751, Sao Paulo, SP', 'M', 30000, '33344555587', 5),
 ('Alice', 'J', 'Zelaya', '99988777767', '19-01-1968', 'Rua Souza Lima, 35, Curitiba, PR', 'F', 25000, '98765432168', 4),
 ('Ronaldo', 'K', 'Lima', '66688444476', '15-09-1962', 'Rua Reboucas, 65, Piracicaba, SP', 'M', 38000, '33344555587', 5),
 ('Joice', 'A', 'Leite', '45345345376', '31-07-1972', 'Av. Lucas Obes, 74, Sao Paulo, SP','F', 25000, '33344555587', 5),
 ('Andre', 'V', 'Pereira', '98798798733', '29-03-1969', 'Rua Timbira, 35, Sao Paulo, SP', 'M', 25000, '98765432168', 4);

-- INSERINDO AS INFORMAÇÕES DE LOCALIZAÇÕES DOS DEPARTAMENTOS
INSERT INTO elmasri.localizacoes_departamento (numero_departamento, local)
VALUES
 (1, 'Sao Paulo'),
 (4, 'Maua'),
 (5, 'Santo Andre'),
 (5, 'Itu'),
 (5, 'Sao Paulo');

-- INSERINDO DADOS DA TABELA DE PROJETOS
INSERT INTO elmasri.projeto (nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES
 ('ProdutoX', 1, 'Santo Andre', 5),
 ('ProdutoY', 2, 'Itu', 5),
 ('ProdutoZ', 3, 'Sao Paulo', 5),
 ('Informatizacao', 10, 'Maua', 4),
 ('Reorganizacao', 20, 'Sao Paulo', 1),
 ('NovosBeneficios', 30, 'Maua', 4);

-- INSERINDO DADOS DA TABELA DEPENDENTE
INSERT INTO elmasri.dependente (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES
 ('33344555587', 'Alicia', 'F', '05-04-1986', 'Filha'),
 ('33344555587', 'Tiago', 'M', '25-10-1983', 'Filho'),
 ('33344555587', 'Janaina', 'F', '03-05-1958', 'Esposa'),
 ('98765432168', 'Antonio', 'M', '28-02-1942', 'Marido'),
 ('12345678966', 'Michael', 'M', '04-01-1988', 'Filho'),
 ('12345678966', 'Alicia', 'F', '30-12-1988', 'Filha'),
 ('12345678966', 'Elizabeth', 'F', '05-05-1967', 'Esposa');

-- INSERINDO DADOS DA TABELA TRABALHA EM
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