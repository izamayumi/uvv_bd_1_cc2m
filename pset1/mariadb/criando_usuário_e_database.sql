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