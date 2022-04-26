# **SQL Power Architect**


## **O que é o SQL Power Architect?**

SQL Power Architect é uma ferramenta livre e de código aberto, não sendo exclusiva para o PostgreSQL, podendo também ser utilizada em
projetos com Oracle, SQL Server, MySQL, Derby e HSQLDB.

![postgres-logo](https://ucarecdn.com/c51f4b2a-d92c-4e2a-a775-8b7c06fcf3f1/)

## **Correção de erros do projeto Elmasri**
### Erros:
- local:VARCHAR(15)
- relacionamento funcionário <-> departamento = N:1
- relacionamento localizações_departamento = N:1
- cpf_supervisor NOT NULL
- hora NOT NULL

### Correções:
- local:VARCHAR(30) Porque os endereços dados pelo pset tem tamanho maior que 15 caracteres
- relacionamento funcionario <-> departamento = 1:N
- - relacionamento localizações_departamento = N:N
- cpf_supervisor pode ser NULL, pois nos dados da coluna cpf_supervisor do pset uma tupla está NULL
- hora pode ser NULL
