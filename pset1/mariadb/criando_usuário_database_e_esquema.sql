-- Criando o usuário para administrar o BD

CREATE USER 'izadora'@'localhost' IDENTIFIED BY '123456';

-- Criando o banco de dados e o esquema uvv (MariaDB) 

CREATE SCHEMA uvv
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

-- Permitir todas as permissões para o usuário gerir o BD e se conectando com ele 

GRANT ALL PRIVILEGES ON uvv.* TO 'izadora'@'localhost';
SYSTEM mysql -u izadora -p;
