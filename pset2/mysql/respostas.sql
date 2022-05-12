/*
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
 Aluna: Izadora Mayumi Goto Bomfim
 Professor: Abrantes Araújo Silva Filho  

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
*/

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 01: prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
*/

SELECT d.nome_departamento AS departamento, CAST(AVG(f.salario) AS DECIMAL (10, 2)) AS média_salarial
FROM funcionario AS f, departamento AS d
WHERE (f.numero_departamento = d.numero_departamento)
GROUP BY d.nome_departamento;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 02: prepare um relatório que mostre a média salarial dos homens e das mulheres.
*/

SELECT (case when (f.sexo='M') then 'Masculino' when (f.sexo='F') then 'Feminino' end) AS sexo, CAST(AVG(salario) AS DECIMAL (10, 2)) AS média_salarial
FROM funcionario AS f
WHERE (sexo = 'M')
GROUP BY f.sexo
UNION 
SELECT (case when (f.sexo='M') then 'Masculino' when (f.sexo='F') then 'Feminino' end) AS sexo, CAST(AVG(salario) AS DECIMAL (10, 2)) 
FROM funcionario AS f
WHERE (sexo = 'F')
GROUP BY f.sexo;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 03: prepare um relatório que liste o nome dos departamentos e, para
cada departamento, inclua as seguintes informações de seus funcionários: o nome
completo, a data de nascimento, a idade em anos completos e o salário.
*/

SELECT departamento.nome_departamento AS departamento, (funcionario.primeiro_nome||' '|| funcionario.nome_meio||' '|| funcionario.ultimo_nome) AS nome, funcionario.data_nascimento, DATE_PART('year', AGE(funcionario.data_nascimento)) AS idade, funcionario.salario
FROM departamento 
INNER JOIN funcionario ON (departamento.numero_departamento = funcionario.numero_departamento);

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 04: prepare um relatório que mostre o nome completo dos funcionários, 
a idade em anos completos, o salário atual e o salário com um reajuste que 
obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o
reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a
35.000 o reajuste deve ser de 15%.
*/

SELECT (primeiro_nome||' '|| nome_meio||' '|| ultimo_nome) AS nome, DATE_PART('year', AGE(data_nascimento))AS idade, CAST(salario AS DECIMAL (10, 2)), CAST(salario*1.2 AS DECIMAL (10,2)) AS salario_reajustado 
FROM funcionario 
WHERE (salario < 35000) 
UNION 
SELECT DISTINCT (primeiro_nome||' '|| nome_meio||' '|| ultimo_nome) AS nome, DATE_PART('year', AGE(data_nascimento)) AS idade, CAST(salario AS DECIMAL (10, 2)), CAST(salario*1.15 AS DECIMAL (10, 2)) AS salario_reajustado 
FROM funcionario 
WHERE (salario >= 35000);

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 05: prepare um relatório que liste, para cada departamento, o nome
do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento
(em ordem crescente) e por salário dos funcionários (em ordem decrescente).
*/

SELECT d.nome_departamento as departamento, (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome, f.salario, (CASE WHEN(d.numero_departamento = f.numero_departamento AND d.cpf_gerente=f.cpf) THEN '*' END) AS gerente
FROM funcionario AS f, departamento AS d 
WHERE (d.numero_departamento = f.numero_departamento)
ORDER BY d.nome_departamento ASC, f.salario DESC;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 06: prepare um relatório que mostre o nome completo dos funcionários que têm dependentes, 
o departamento onde eles trabalham e, para cada funcionário, 
também liste o nome completo dos dependentes, a idade em anos de cada
dependente e o sexo (o sexo NÃO DEVE aparecer como M ou F, deve aparecer
como “Masculino” ou “Feminino”).
*/

SELECT (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome_funcionario, d.nome_departamento as departamentos, dp.nome_dependente, (CASE WHEN(dp.sexo = 'M')THEN 'Masculino' WHEN(dp.sexo = 'F')THEN 'Feminino'END) AS sexo, DATE_PART('year', AGE(dp.data_nascimento)) AS idade
FROM funcionario AS f, dependente AS dp, departamento AS d
WHERE (f.cpf = dp.cpf_funcionario AND f.numero_departamento = d.numero_departamento);

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 07: prepare um relatório que mostre, para cada funcionário que NÃO
TEM dependente, seu nome completo, departamento e salário.
*/

SELECT (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome, d.nome_departamento AS departamento, f.salario
FROM funcionario AS f, departamento AS d
WHERE f.cpf NOT IN (SELECT d.cpf_funcionario FROM dependente AS d) AND (d.numero_departamento= f.numero_departamento);

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 08: prepare um relatório que mostre, para cada departamento, os projetos desse departamento 
e o nome completo dos funcionários que estão alocados em cada projeto. Além disso inclua o 
número de horas trabalhadas por cada funcionário, em cada projeto.
*/

SELECT d.nome_departamento AS departamento, p.nome_projeto as projeto, (f.primeiro_nome||' '|| f.nome_meio||' ' ||f.ultimo_nome) AS nome, t.horas
FROM funcionario AS f
INNER JOIN trabalha_em AS t
ON (f.cpf = t.cpf_funcionario)
INNER JOIN projeto AS p
ON (t.numero_projeto = p.numero_projeto)
INNER JOIN departamento AS d
ON (p.numero_departamento = d.numero_departamento)
ORDER BY d.nome_departamento ASC, p.nome_projeto ASC;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 09: prepare um relatório que mostre a soma total das horas de cada
projeto em cada departamento. Obs: o relatório deve exibir o nome do
departamento, o nome do projeto e a soma total das horas.
*/

SELECT d.nome_departamento AS departamento, p.nome_projeto AS projeto, SUM(t.horas) AS total_horas
FROM funcionario AS f
INNER JOIN trabalha_em AS t
ON (f.cpf = t.cpf_funcionario)
INNER JOIN projeto AS p
ON (t.numero_projeto = p.numero_projeto)
INNER JOIN departamento AS d
ON (p.numero_departamento = d.numero_departamento)
GROUP BY d.nome_departamento, p.nome_projeto
ORDER BY d.nome_departamento;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 10: prepare um relatório que mostre a média salarial dos
funcionários de cada departamento.
*/

SELECT d.nome_departamento AS departamento, CAST(AVG(f.salario) AS DECIMAL (10, 2)) AS média_salarial
FROM funcionario AS f, departamento AS d
WHERE (f.numero_departamento = d.numero_departamento)
GROUP BY d.nome_departamento;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 11: considerando que o valor pago por hora trabalhada em um projeto
é de 50 reais, prepare um relatório que mostre o nome completo do funcionário, o
nome do projeto e o valor total que o funcionário receberá referente às horas trabalhadas naquele projeto.
*/	

SELECT (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome, p.nome_projeto AS projeto, CAST (t.horas * 50 AS DECIMAL(10,2)) AS total_valor
FROM funcionario AS f
INNER JOIN trabalha_em AS t
ON (f.cpf = t.cpf_funcionario)
INNER JOIN projeto AS p
ON (t.numero_projeto = p.numero_projeto);

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 12: seu chefe está verificando as horas trabalhadas pelos funcionários
nos projetos e percebeu que alguns funcionários, mesmo estando alocadas à algum
projeto, não registraram nenhuma hora trabalhada. Sua tarefa é preparar um relatório que liste 
o nome do departamento, o nome do projeto e o nome dos funcionários
que, mesmo estando alocados a algum projeto, não registraram nenhuma hora trabalhada..
*/

SELECT d.nome_departamento AS departamento, p.nome_projeto AS projeto, (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome
FROM funcionario AS f
INNER JOIN departamento AS d
ON f.numero_departamento = d.numero_departamento
INNER JOIN trabalha_em AS t
ON f.cpf = t.cpf_funcionario
INNER JOIN projeto AS p
ON t.numero_projeto = p.numero_projeto
WHERE t.horas IS NULL;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 13: durante o natal deste ano a empresa irá presentear todos os funcionários e todos os 
dependentes (sim, a empresa vai dar um presente para cada
funcionário e um presente para cada dependente de cada funcionário) e pediu para
que você preparasse um relatório que listasse o nome completo das pessoas a serem
presenteadas (funcionários e dependentes), o sexo e a idade em anos completos
(para poder comprar um presente adequado). Esse relatório deve estar ordenado
pela idade em anos completos, de forma decrescente.
*/	

SELECT (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome, (case when (f.sexo='M') then 'Masculino' when (f.sexo='F') then 'Feminino'end) as sexo, DATE_PART('year', AGE(f.data_nascimento)) AS idade
FROM funcionario AS f
UNION
SELECT d.nome_dependente, (case when (d.sexo='M') then 'Masculino' when (d.sexo='F') then 'Feminino'end) as sexo, DATE_PART('year', AGE(d.data_nascimento)) AS idade
FROM dependente AS d
ORDER BY idade DESC;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 14: prepare um relatório que exiba quantos funcionários cada departamento tem.
*/	

SELECT d.nome_departamento AS departamento, COUNT(f.cpf) AS quantidade_funcionarios
FROM funcionario AS f
INNER JOIN departamento AS d
ON (f.numero_departamento = d.numero_departamento)
GROUP BY d.nome_departamento;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
/*
QUESTÃO 15: como um funcionário pode estar alocado em mais de um projeto,
prepare um relatório que exiba o nome completo do funcionário, o departamento
desse funcionário e o nome dos projetos em que cada funcionário está alocado.
Atenção: se houver algum funcionário que não está alocado em nenhum projeto,
o nome completo e o departamento também devem aparecer no relatório.
*/	

SELECT (f.primeiro_nome||' '|| f.nome_meio||' '|| f.ultimo_nome) AS nome, d.nome_departamento AS departamento, p.nome_projeto AS projeto
FROM funcionario AS f
INNER JOIN trabalha_em AS t
ON f.cpf = t.cpf_funcionario
INNER JOIN projeto AS p
ON t.numero_projeto = p.numero_projeto
INNER JOIN departamento AS d
ON f.numero_departamento = d.numero_departamento
ORDER BY nome;