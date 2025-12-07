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
(UUID_TO_BIN(UUID()), 'Desenvolvedor RPA'),
(UUID_TO_BIN(UUID()), 'Analista de Processos'),
(UUID_TO_BIN(UUID()), 'Coordenador de Projetos'),
(UUID_TO_BIN(UUID()), 'Gerente de Projetos'),
(UUID_TO_BIN(UUID()), 'Especialista em Automação');

-- =========================
-- Inserir dados na tabela usuarios (baseado no documento)
-- =========================
INSERT INTO usuarios (
    matricula, nome_completo_usuario, email_usuario, senha_usuario, id_microsoft_usuario, 
    data_criacao_usuario, data_atualizacao_usuario, id_estado_dado, matricula_superior
) VALUES
(509880, 'Giovanna AAvila', 'giovanna.aavila@empresa.com', '123Aa321','giovanna.aavila_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), NULL),
(509881, 'Carlos Silva', 'carlos.silva@empresa.com', '123Aa321','carlos.silva_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 509880),
(509882, 'Ana Rodrigues', 'ana.rodrigues@empresa.com', '123Aa321','ana.rodrigues_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 509880),
(509883, 'Pedro Santos', 'pedro.santos@empresa.com', '123Aa321','pedro.santos_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 509880),
(509884, 'Mariana Lima', 'mariana.lima@empresa.com', '123Aa321','mariana.lima_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 509880);

-- =========================
-- Inserir dados na tabela projetos (baseado no documento)
-- =========================
INSERT INTO projetos (
    id_projeto, nome_projeto, data_entrega_projeto, data_inicio_projeto, 
    id_estado_dado
) VALUES
('PC.037', 'ITAU - PROJETOS RPA', '2025-12-30', '2025-08-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
('PC.038', 'BRADESCO - PROCESS MINING', '2025-11-15', '2025-08-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
('PC.039', 'SANTANDER - AUTOMAÇÃO', '2025-10-30', '2025-08-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
('PC.040', 'BANCO DO BRASIL - BOTs', '2025-09-20', '2025-08-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1));

-- =========================
-- Inserir dados na tabela equipe
-- =========================
INSERT INTO equipe (id_equipe, usuarios_matricula) VALUES
(UUID_TO_BIN(UUID()), 509880);

-- =========================
-- Inserir dados na tabela assoc_cargo_equipe
-- =========================
INSERT INTO assoc_cargo_equipe (
    id_assoc_cargo_equipe, usuarios_matricula, equipe_id_equipe, 
    cargo_usuario_id_cargo_usuario, valor_hora
) VALUES
(UUID_TO_BIN(UUID()), 509880, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 509880),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Especialista em Automação'), 150.00),
(UUID_TO_BIN(UUID()), 509881, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 509880),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor RPA'), 120.00),
(UUID_TO_BIN(UUID()), 509882, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 509880),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Analista de Processos'), 100.00),
(UUID_TO_BIN(UUID()), 509883, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 509880),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor RPA'), 110.00),
(UUID_TO_BIN(UUID()), 509884, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 509880),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Coordenador de Projetos'), 130.00);

-- =========================
-- Inserir dados na tabela assoc_usuario_projetos
-- =========================
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
-- Giovanna nos projetos principais
(UUID_TO_BIN(UUID()), 509880, 'PC.037', '2025-08-01', 160, NOW()),
(UUID_TO_BIN(UUID()), 509880, 'PC.038', '2025-08-01', 160, NOW()),
-- Outros colaboradores distribuídos
(UUID_TO_BIN(UUID()), 509881, 'PC.037', '2025-08-01', 120, NOW()),
(UUID_TO_BIN(UUID()), 509881, 'PC.038', '2025-08-01', 120, NOW()),
(UUID_TO_BIN(UUID()), 509882, 'PC.038', '2025-08-01', 140, NOW()),
(UUID_TO_BIN(UUID()), 509882, 'PC.039', '2025-08-01', 100, NOW()),
(UUID_TO_BIN(UUID()), 509883, 'PC.037', '2025-08-01', 130, NOW()),
(UUID_TO_BIN(UUID()), 509883, 'PC.040', '2025-08-01', 110, NOW()),
(UUID_TO_BIN(UUID()), 509884, 'PC.038', '2025-08-01', 150, NOW()),
(UUID_TO_BIN(UUID()), 509884, 'PC.039', '2025-08-01', 90, NOW());

-- =========================
-- Inserir dados na tabela apontamentos (baseado no documento real)
-- =========================

-- Agosto 2025 - Baseado no espelho de ponto da Giovanna
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, justificativa_apontamento,
    id_projeto, hora_inicio_apontamento, hora_fim_apontamento, horas_totais_apontamento,
    motivo_apontamento, usuarios_matricula, id_estado_dado
) VALUES
-- 01/08/2025 - Dia completo
(UUID_TO_BIN(UUID()), '2025-08-01', 'Relógio Web', NULL, 'PC.037', '07:00:00', '12:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-01', 'Relógio Web', NULL, 'PC.037', '13:00:00', '16:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-01', 'Horas Projeto', 'ITAU - PROJETOS RPA', 'PC.037', NULL, NULL, 8, 'Projeto alocado', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-01', 'Horas Programadas', 'BRADESCO - PROCESS MINING', 'PC.038', NULL, NULL, 8, 'Projeto alocado', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),

-- 02-03/08/2025 - Finais de semana compensados
(UUID_TO_BIN(UUID()), '2025-08-02', 'Compensado', NULL, NULL, NULL, NULL, 0, 'Folga', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-03', 'Compensado', NULL, NULL, NULL, NULL, 0, 'Folga', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),

-- 04/08/2025 - Com marcação manual
(UUID_TO_BIN(UUID()), '2025-08-04', 'Marcação Manual', NULL, NULL, '08:00:00', '12:00:00', NULL, '01-Esquecimento', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-04', 'Relógio Web', NULL, NULL, '13:00:00', '17:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-04', 'Horas Programadas', 'BRADESCO - PROCESS MINING', NULL, NULL, NULL, 8, 'Projeto alocado', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),

-- 05/08/2025 - Com hora extra
(UUID_TO_BIN(UUID()), '2025-08-05', 'Relógio Web', NULL, NULL, '08:00:00', '12:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-05', 'Relógio Web', NULL, NULL, '13:00:00', '19:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-05', 'Hora extra', '14 - Hora extra', NULL, NULL, NULL, 2, 'Hora extra justificada', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-05', 'Horas Programadas', 'BRADESCO - PROCESS MINING', 'PC.038', NULL, NULL,8, 'Projeto alocado', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-05', 'Horas Projeto Extra', 'BRADESCO - PROCESS MINING', 'PC.038', NULL, NULL, 2, 'Hora extra', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),

-- 06/08/2025 - Com marcação manual
(UUID_TO_BIN(UUID()), '2025-08-06', 'Relógio Web', NULL, NULL, '08:00:00', '12:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-06', 'Marcação Manual', NULL, NULL, '13:00:00', '17:00:00', NULL, 'Retroativo', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-06', 'Horas Programadas', 'BRADESCO - PROCESS MINING', 'PC.038', NULL, NULL, 8, 'Projeto alocado', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),

-- Dias 07-15/08/2025 - Padrão normal
(UUID_TO_BIN(UUID()), '2025-08-07', 'Relógio Web', NULL, NULL, '08:00:00', '12:22:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-07', 'Relógio Web', NULL, NULL, '13:22:00', '17:00:00', NULL, 'Trabalho normal', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2025-08-07', 'Horas Programadas', 'BRADESCO - PROCESS MINING', 'PC.038', NULL, NULL, 8, 'Projeto alocado', 509880, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1));