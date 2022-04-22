-- CRIANDO O ESQUEMA ELMASRI
create schema elmasri
authorization "izadora";

alter user "izadora"
-- USUÁRIO QUE SERÁ ADMINISTRADOR DO BD
set search_path to elmsari, "&izadora", public;
-- TABELAS CRIADAS DENTRO DO ESQUEMA ELMASRI

/*AGORA TODAS AS TABELAS E RELAÇÕES IRÃO SER CRIADAS,
 DE ACORDO COM O PROJETO CONCEITUAL, DETALHES DE MAIOR IMPORTÂNCIA SERÃO COMENTADOS*/
 
 create table elmasri.departamento (
numero_departamento INTEGER NOT NULL,
nome_departamento VARCHAR(15) not null,
cpf_gerente char(11) not null,
data_inicio_gerente date,
PRIMARY KEY (numero_departamento)
); 
comment on table elmasri.departamento IS 'Tabela de armazenamento das informações dos departamentos';
comment on column elmasri.departamento.numero_departamento IS 'Número do departmento, sendo a Primary Key';
comment on column elmasri.departamento.nome_departamento IS 'Nome do Departamento';
comment on column elmasri.departamento.cpf_gerente IS 'CPF do gerente do departamento';
comment on column elmasri.departamento.data_inicio_gerente IS 'Data de início do gerente do departamento';

create unique index departamento_idx
-- CRIANDO A ALTERNATIVE KEY (ak)
on elmasri.departamento (nome_departamento);


create table elmasri.localizacoes_departamento (
numero_departamento integer not null,
local varchar(15) not null,
primary KEY (numero_departamento, local)
);
comment on table elmasri.localizacoes_departamento IS 'Tabela de armazenamento das localizações dos departamentos';
comment on column elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento, sendo uma das Primary Keys';
COMMENT on COLUMN elmasri.localizacoes_departamento.local IS 'Localização do departamento, compondo a Primary Key';

create table elmasri.projeto (
numero_projeto integer not null,
nome_projeto varchar(15) not null,
local_projeto varchar(15),
numero_departamento integer not null,
primary key (numero_projeto)
);
comment on table elmasri.projeto IS 'Tabela de armazenamento das informações sobre os projetos';
COMMENT on COLUMN elmasri.projeto.numero_projeto is 'Número do projeto';
COMMENT on COLUMN elmasri.projeto.nome_projeto is 'Nome do projeto';
COMMENT on COLUMN elmasri.projeto.local_projeto is 'Local do projeto';
COMMENT on COLUMN elmasri.projeto.numero_departamento is 'Número do departamento';
 create unique index projeto_idx 
 -- CRIANDO A ALTERNATIVE KEY (ak) DA TABELA PROJETO
 on elmasri.projeto 
 (nome_projeto);
 

 CREATE table elmasri.funcionario (
cpf char(11) not null,
primeiro_nome varchar(15) not null,
nome_meio char(1),
ultimo_nome varchar(15) not null,
data_nascimento date,
endereco varchar(50),
sexo char(1) check (sexo = 'F' or sexo = 'M'),
-- A CONSTRAINT CHECK IMPEDE TODO VALOR ALÉM DE 'M' e 'F'
salario numeric(10,2) check (salario>0),
-- A CONSTRAINT CHECK IMPEDE QUE O SALÁRIO SEJA UM VALOR NEGATIVO
cpf_supervisor char(11),
-- PODE TER VALOR NULO, POIS O FUNCIONÁRIO 'Jorge', RECEBE VALOR null NESSE CAMPO    
numero_departamento integer default 1 not null,
-- 1 É O NÚMERO DEPARTAMENTO PADRÃO POR SER A MATRIZ, E PARA PODER INSERIR OS DADOS INICIAIS DE DEPARTAMENTO E FUNCIONÁRIO
primary key (cpf)
 );
 COMMENT on table elmasri.funcionario is 'Tabela de armazenamento das informações dos funcionários';
 comment on COLUMN elmasri.funcionario.cpf is 'CPF do funcionário, sendo a Primary Key';
 comment on COLUMN elmasri.funcionario.primeiro_nome is 'Primeiro nome do funcionário';
 comment on COLUMN elmasri.funcionario.nome_meio is 'Inicial do nome do meio';
 comment on COLUMN elmasri.funcionario.ultimo_nome is 'Último nome do funcionário';
 comment on COLUMN elmasri.funcionario.endereco is 'Endereço do funcionário';
 comment on COLUMN elmasri.funcionario.sexo is 'Gênero do funcionário';
 comment on COLUMN elmasri.funcionario.salario is 'Salário do funcionário';
 comment on COLUMN elmasri.funcionario.cpf_supervisor is 'CPF do supervisor';
 comment on COLUMN elmasri.funcionario.numero_departamento is 'Número do departamento';

create table elmasri.trabalha_em (
cpf_funcionario char(11) not null,
numero_projeto integer not null,
horas DECIMAL(3,1) check (horas>0),
-- CONSTRAINT CHECK PARA SER MAIOR QUE 0, E PODENDO SER UM VALOR NULO, POIS 'Jorge' RECEBE null 
primary key (cpf_funcionario, numero_projeto)
);
comment on table elmasri.trabalha_em is 'Tabela para armazenar quais funcionários trabalham em quaiss projetos';
comment on COLUMN elmasri.trabalha_em.cpf_funcionario is 'CPF do funcionário, fazendo parte da Primary Key';
comment on COLUMN elmasri.trabalha_em.numero_projeto is 'Número do projeto, compondo a Primary Key';
comment on COLUMN elmasri.trabalha_em.horas is 'Horas trabalhadas';

create table elmasri.dependente (
cpf_funcionario char(11) not null,
nome_dependente varchar(15) not null,
sexo char(1) check (sexo = 'F' or sexo = 'M'),
-- A CONSTRAINT CHECK IMPEDE TODO VALOR ALÉM DE 'M' e 'F'
data_nascimento date,
parentesco varchar(15),
primary key (cpf_funcionario, nome_dependente)
);
comment on table elmasri.dependente is 'Tabela de armazenamento das informações dos dependentes dos funcinários';
COMMENT on COLUMN elmasri.dependente.cpf_funcionario is 'CPF do funcionário, faz parte da Primary Key';
COMMENT on COLUMN elmasri.dependente.nome_dependente is 'Nome do dependente';
COMMENT on COLUMN elmasri.dependente.sexo is 'Gênero do dependente';
COMMENT on COLUMN elmasri.dependente.data_nascimento is 'Data de nascimento do dependente';
COMMENT on COLUMN elmasri.dependente.parentesco is 'Parentesco do dependente e funcionário';

/* CRIAÇÃO DAS RELAÇÕES DE FOREIGN KEY ENTRE AS TABELAS */
alter table elmasri.departamento add constraint departamento_funcionario_fk
foreign key (cpf_gerente)
references elmasri.funcionario (cpf)
on delete no ACTION
on update no ACTION
not deferrable;

alter table elmasri.projeto add constraint departamento_projeto_fk
foreign key (numero_departamento)
references elmasri.departamento (numero_departamento)
on delete no ACTION
on update no ACTION
not deferrable;

alter table elmasri.trabalha_em add constraint projeto_trabalha_em_fk
foreign key (numero_projeto)
references elmasri.projeto (numero_projeto)
on delete no ACTION
on update no ACTION
not deferrable;

alter table elmasri.localizacoes_departamento add constraint departamento_localizacoes_departamento_fk
foreign key (numero_departamento)
references elmasri.departamento (numero_departamento)
on delete no ACTION
on update no ACTION
not deferrable; 

alter table elmasri.trabalha_em add CONSTRAINT funcionario_trabalha_em_fk
foreign key (cpf_funcionario)
references elmasri.funcionario (cpf)
on delete no ACTION
on update no ACTION
not deferrable; 

alter table elmasri.funcionario add constraint funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
on delete no ACTION
on update no ACTION
not deferrable; 

alter table elmasri.dependente add CONSTRAINT funcionario_dependente_fk
FOREIGN key (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
on delete no ACTION
on update no ACTION
not deferrable;
