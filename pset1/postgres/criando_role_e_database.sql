-- CRIANDO O USUÁRIO ADMINISTRADOR DO BANCO DE DADOS 'izadora' 
CREATE ROLE izadora WITH
    LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD '123456';
    COMMENT ON ROLE "izadora" IS 'Usuário "Dono" do banco de dados. Pode criar, editar e apagar quaisquer tabelas, schemas e até o próprio banco de dados.';

-- CRIANDO O BANCO DE DADOS UVV TENDO O USUARIO 'izadora' COMO SEU DONO
CREATE DATABASE uvv
    WITH
    OWNER = "izadora"
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt-BR.UTF-8'
    CONNECTION LIMIT = -1;           