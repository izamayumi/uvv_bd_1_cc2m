/*
 =-=-=-= ORIENTAÇÕES =-=-=-=

* O ARQUIVO DEVE SER EXECUTADO A PARTIR DO TERMINAL POSTGRES psql PARA TER SEU FUNCIONAMENTO CORRETO.

* ESSE ARQUIVO É RESPONSÁVEL POR EXECUTAR TODOS OS SCRIPTS NECESSÁRIOS PARA QUE O PROJETO DO BANCO DE DADOS SEJA FINALIZADO. 

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
 Aluna: Izadora Mayumi Goto Bomfim
 Professor: Abrantes Araújo Silva Filho  

‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
*/

\echo 
\echo DEFINA O DIRETÓRIO DA PASTA ONDE ESTÃO OS ARQUIVOS "criando_role_e_database.sql" e "criando_esquema_e_tabelas.sql":
\prompt path
 

\echo 
\echo Criando o Banco de Dados "UVV" e o Usuário Administrador "izadora".
\i :path/criando_role_e_database.sql


\echo 
\echo A senha padrão para o Usuario "izadora" recebe: 123456.
\echo Defina uma nova senha para o usuario
\password izadora


\echo 
\echo Conectando ao banco de dados.
\c uvv izadora localhost 5432


\echo 
\echo Criando Esquema Elmasri e suas Tabelas.
\i :path/criando_esquema_e_tabelas.sql


\echo 
\echo Esquema Elmasri Criado. Inserindo dados:
\i :path/inserindo_dados.sql