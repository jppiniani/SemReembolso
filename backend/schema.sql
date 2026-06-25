-- =============================================================
-- Game Lambda - Schema do banco de dados
-- MySQL 8.x
-- =============================================================
-- Cria 4 tabelas: jogador, run, item, run_item.
-- Para uso: importar este arquivo no MySQL Workbench
-- (File > Open SQL Script > Run) ou via CLI:
--   mysql -u root -p < schema.sql
-- =============================================================

DROP DATABASE IF EXISTS game_lambda;
CREATE DATABASE game_lambda CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE game_lambda;

-- -------------------------------------------------------------
-- Tabela: jogador
-- Cada nickname unico = 1 linha. Reaproveitada se o nick voltar.
-- -------------------------------------------------------------
CREATE TABLE jogador (
    id_jogador  INT          NOT NULL AUTO_INCREMENT,
    nickname    VARCHAR(32)  NOT NULL,
    criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_jogador),
    UNIQUE KEY uk_jogador_nickname (nickname)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Tabela: run
-- Uma linha por partida concluida (morte para o mercador).
-- -------------------------------------------------------------
CREATE TABLE run (
    id_run          INT       NOT NULL AUTO_INCREMENT,
    id_jogador      INT       NOT NULL,
    tempo_segundos  INT       NOT NULL,
    finalizada_em   DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_run),
    CONSTRAINT fk_run_jogador
        FOREIGN KEY (id_jogador) REFERENCES jogador(id_jogador)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Tabela: item
-- Catalogo estatico (BOTA, ARMADURA).
-- -------------------------------------------------------------
CREATE TABLE item (
    id_item       INT          NOT NULL AUTO_INCREMENT,
    codigo        VARCHAR(20)  NOT NULL,
    nome_default  VARCHAR(64)  NOT NULL,
    preco         INT          NOT NULL,
    PRIMARY KEY (id_item),
    UNIQUE KEY uk_item_codigo (codigo)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Tabela: run_item (associativa N:N entre run e item)
-- -------------------------------------------------------------
CREATE TABLE run_item (
    id_run   INT NOT NULL,
    id_item  INT NOT NULL,
    PRIMARY KEY (id_run, id_item),
    CONSTRAINT fk_runitem_run
        FOREIGN KEY (id_run) REFERENCES run(id_run)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_runitem_item
        FOREIGN KEY (id_item) REFERENCES item(id_item)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =============================================================
-- Dados iniciais
-- =============================================================
INSERT INTO item (codigo, nome_default, preco) VALUES
    ('BOTA',     'Bota do Heroi Traido',     100),
    ('ARMADURA', 'Armadura do Heroi Traido', 150);
