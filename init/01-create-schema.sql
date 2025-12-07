
USE Timesync;

-- =========================
-- Tabela: estado_dados
-- =========================
CREATE TABLE estado_dados (
    id_estado_dado BINARY(16) PRIMARY KEY,
    nome_estado_dado VARCHAR(60) NOT NULL
);

-- =========================
-- Tabela: cargo_usuario
-- =========================
CREATE TABLE cargo_usuario (
    id_cargo_usuario BINARY(16) PRIMARY KEY,
    titulo_cargo_usuario VARCHAR(60) NOT NULL
);

-- =========================
-- Tabela: usuarios
-- =========================
CREATE TABLE usuarios (
    matricula INT PRIMARY KEY,
    nome_completo_usuario VARCHAR(100) NOT NULL,
    email_usuario VARCHAR(150) NOT NULL,
    senha_usuario VARCHAR(40) NOT NULL,
    id_microsoft_usuario VARCHAR(255),
    data_criacao_usuario DATETIME NOT NULL,
    data_atualizacao_usuario DATETIME NOT NULL,
    id_estado_dado BINARY(16) NOT NULL,
    matricula_superior INT,
    CONSTRAINT fk_usuarios_estado FOREIGN KEY (id_estado_dado) REFERENCES estado_dados(id_estado_dado),
    CONSTRAINT fk_usuarios_superior FOREIGN KEY (matricula_superior) REFERENCES usuarios(matricula)
);

-- =========================
-- Tabela: projetos
-- =========================
CREATE TABLE projetos (
    id_projeto CHAR(6) PRIMARY KEY,
    nome_projeto VARCHAR(255) NOT NULL,
    data_entrega_projeto DATE NOT NULL,
    data_inicio_projeto DATE NOT NULL,
    id_estado_dado BINARY(16) NOT NULL,
    CONSTRAINT fk_projetos_estado FOREIGN KEY (id_estado_dado) REFERENCES estado_dados(id_estado_dado)
);

-- =========================
-- Tabela: apontamentos
-- =========================
CREATE TABLE apontamentos (
    id_apontamento BINARY(16) PRIMARY KEY,
    data_apontamento DATETIME NOT NULL,
    ocorrencia_apontamento VARCHAR(150) NOT NULL,
    justificativa_apontamento VARCHAR(150),
    id_projeto CHAR(6),
    hora_inicio_apontamento TIME,
    hora_fim_apontamento TIME,
    horas_totais_apontamento FLOAT,
    motivo_apontamento VARCHAR(150),
    usuarios_matricula INT NOT NULL,
    id_estado_dado BINARY(16) NOT NULL,
    CONSTRAINT fk_apontamentos_projeto FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto),
    CONSTRAINT fk_apontamentos_usuario FOREIGN KEY (usuarios_matricula) REFERENCES usuarios(matricula),
    CONSTRAINT fk_apontamentos_estado FOREIGN KEY (id_estado_dado) REFERENCES estado_dados(id_estado_dado)
);

-- =========================
-- Tabela: assoc_usuario_projetos
-- =========================
CREATE TABLE assoc_usuario_projetos (
    id_assoc_usuarios_projetos BINARY(16) PRIMARY KEY,
    usuarios_matricula INT NOT NULL,
    id_projeto CHAR(6) NOT NULL,
    data_criacao_associacao DATETIME NOT NULL,
    horas_planejadas INT NOT NULL,
    data_atualizacao_associacao DATETIME NOT NULL,
    CONSTRAINT fk_assoc_usuario FOREIGN KEY (usuarios_matricula) REFERENCES usuarios(matricula),
    CONSTRAINT fk_assoc_projeto FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto)
);

-- =========================
-- Tabela: equipe
-- =========================
CREATE TABLE equipe (
    id_equipe BINARY(16) PRIMARY KEY,
    usuarios_matricula INT NOT NULL,
    CONSTRAINT fk_equipe_usuario FOREIGN KEY (usuarios_matricula) REFERENCES usuarios(matricula)
);

-- =========================
-- Tabela: assoc_cargo_equipe
-- =========================
CREATE TABLE assoc_cargo_equipe (
    id_assoc_cargo_equipe BINARY(16) PRIMARY KEY,
    usuarios_matricula INT NOT NULL,
    equipe_id_equipe BINARY(16) NOT NULL,
    cargo_usuario_id_cargo_usuario BINARY(16) NOT NULL,
    valor_hora FLOAT NOT NULL,
    CONSTRAINT fk_assoc_cargo_usuario FOREIGN KEY (usuarios_matricula) REFERENCES usuarios(matricula),
    CONSTRAINT fk_assoc_cargo_equipe FOREIGN KEY (equipe_id_equipe) REFERENCES equipe(id_equipe),
    CONSTRAINT fk_assoc_cargo FOREIGN KEY (cargo_usuario_id_cargo_usuario) REFERENCES cargo_usuario(id_cargo_usuario)
);

DELIMITER //
CREATE TRIGGER calcular_horas_apontamento
BEFORE INSERT ON apontamentos
FOR EACH ROW
BEGIN
    IF NEW.horas_totais_apontamento IS NULL THEN
        SET NEW.horas_totais_apontamento = TIME_TO_SEC(TIMEDIFF(NEW.hora_fim_apontamento, NEW.hora_inicio_apontamento)) / 3600;
    END IF;
END //
DELIMITER ;