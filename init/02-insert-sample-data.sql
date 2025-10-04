-- init/02-insert-sample-data.sql

USE Timesync;

-- =========================
-- Inserir dados na tabela estado_dados
-- =========================
INSERT INTO estado_dados (id_estado_dado, nome_estado_dado) VALUES
(UUID_TO_BIN(UUID()), 'Ativo'),
(UUID_TO_BIN(UUID()), 'Inativo'),
(UUID_TO_BIN(UUID()), 'Pendente'),
(UUID_TO_BIN(UUID()), 'Concluído');

-- =========================
-- Inserir dados na tabela cargo_usuario
-- =========================
INSERT INTO cargo_usuario (id_cargo_usuario, titulo_cargo_usuario) VALUES
(UUID_TO_BIN(UUID()), 'Desenvolvedor Junior'),
(UUID_TO_BIN(UUID()), 'Desenvolvedor Pleno'),
(UUID_TO_BIN(UUID()), 'Desenvolvedor Senior'),
(UUID_TO_BIN(UUID()), 'Gerente de Projetos'),
(UUID_TO_BIN(UUID()), 'Analista de Sistemas');

-- =========================
-- Inserir dados na tabela usuarios
-- =========================
INSERT INTO usuarios (matricula, nome_completo_usuario, email_usuario, id_microsoft_usuario, data_criacao_usuario, data_atualizacao_usuario, id_estado_dado, matricula_superior) VALUES
(1001, 'João Silva', 'joao.silva@empresa.com', 'joao.silva_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), NULL),
 
(1002, 'Maria Santos', 'maria.santos@empresa.com', 'maria.santos_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1001),
 
(1003, 'Pedro Oliveira', 'pedro.oliveira@empresa.com', 'pedro.oliveira_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1001),
 
(1004, 'Ana Costa', 'ana.costa@empresa.com', 'ana.costa_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1002);

-- =========================
-- Inserir dados na tabela projetos
-- =========================
INSERT INTO projetos (id_projeto, nome_projeto, horas_estimadas_projeto, horas_apontadas_projeto, id_estado_dado) VALUES
('PROJ01', 'Sistema de Gestão Interna', '200:00:00', '45:30:00',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
('PROJ02', 'Portal do Cliente', '150:00:00', '80:15:00',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
('PROJ03', 'Aplicativo Mobile', '300:00:00', '120:45:00',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
('PROJ04', 'Migração de Dados', '100:00:00', '25:20:00',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Concluído' LIMIT 1));

-- =========================
-- Inserir dados na tabela equipe
-- =========================
INSERT INTO equipe (id_equipe, usuarios_matricula) VALUES
(UUID_TO_BIN(UUID()), 1001),
(UUID_TO_BIN(UUID()), 1002),
(UUID_TO_BIN(UUID()), 1003),
(UUID_TO_BIN(UUID()), 1004);

-- =========================
-- Inserir dados na tabela assoc_cargo_equipe
-- =========================
INSERT INTO assoc_cargo_equipe (id_assoc_cargo_equipe, usuarios_matricula, equipe_id_equipe, cargo_usuario_id_cargo_usuario, valor_hora) VALUES
(UUID_TO_BIN(UUID()), 1001, 
 (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1001),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Gerente de Projetos'), 150.00),
 
(UUID_TO_BIN(UUID()), 1002, 
 (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1002),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor Senior'), 120.00),
 
(UUID_TO_BIN(UUID()), 1003, 
 (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1003),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor Pleno'), 90.00),
 
(UUID_TO_BIN(UUID()), 1004, 
 (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1004),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor Junior'), 65.00);

-- =========================
-- Inserir dados na tabela assoc_usuario_projetos
-- =========================
INSERT INTO assoc_usuario_projetos (id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, data_criacao_associacao, horas_planejadas, data_atualizacao_associacao) VALUES
(UUID_TO_BIN(UUID()), 1001, 'PROJ01', NOW(), 40, NOW()),
(UUID_TO_BIN(UUID()), 1001, 'PROJ02', NOW(), 30, NOW()),
(UUID_TO_BIN(UUID()), 1002, 'PROJ01', NOW(), 60, NOW()),
(UUID_TO_BIN(UUID()), 1002, 'PROJ03', NOW(), 80, NOW()),
(UUID_TO_BIN(UUID()), 1003, 'PROJ02', NOW(), 50, NOW()),
(UUID_TO_BIN(UUID()), 1003, 'PROJ03', NOW(), 70, NOW()),
(UUID_TO_BIN(UUID()), 1004, 'PROJ01', NOW(), 40, NOW()),
(UUID_TO_BIN(UUID()), 1004, 'PROJ04', NOW(), 20, NOW());

-- =========================
-- Inserir dados na tabela apontamentos
-- =========================
INSERT INTO apontamentos (id_apontamento, data_apontamento, ocorrencia_apontamento, justificativa_apontamento, id_projeto, hora_inicio_apontamento, hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, usuarios_matricula, id_estado_dado) VALUES
(UUID_TO_BIN(UUID()), '2024-01-15 09:00:00', 'Desenvolvimento módulo usuários', 'Implementação CRUD completo', 'PROJ01', '09:00:00', '12:00:00', '03:00:00', 'Desenvolvimento', 1001,
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
(UUID_TO_BIN(UUID()), '2024-01-15 14:00:00', 'Revisão de código', 'Revisão PR #123', 'PROJ01', '14:00:00', '15:30:00', '01:30:00', 'Revisão', 1002,
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
(UUID_TO_BIN(UUID()), '2024-01-16 10:00:00', 'Configuração ambiente', 'Setup docker e banco', 'PROJ02', '10:00:00', '12:30:00', '02:30:00', 'Configuração', 1003,
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
(UUID_TO_BIN(UUID()), '2024-01-16 13:00:00', 'Testes unitários', 'Cobertura 80% módulo auth', 'PROJ03', '13:00:00', '17:00:00', '04:00:00', 'Testes', 1004,
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
 
(UUID_TO_BIN(UUID()), '2024-01-17 08:30:00', 'Reunião de planejamento', 'Sprint planning semana 3', 'PROJ01', '08:30:00', '10:00:00', '01:30:00', 'Reunião', 1001,
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1));