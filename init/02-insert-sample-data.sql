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
INSERT INTO usuarios (
    matricula, nome_completo_usuario, email_usuario, id_microsoft_usuario, 
    data_criacao_usuario, data_atualizacao_usuario, id_estado_dado, matricula_superior
) VALUES
(1001, 'João Silva', 'joao.silva@empresa.com', 'joao.silva_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), NULL),
(1002, 'Maria Santos', 'maria.santos@empresa.com', 'maria.santos_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1001),
(1003, 'Pedro Oliveira', 'pedro.oliveira@empresa.com', 'pedro.oliveira_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1001),
(1004, 'Ana Costa', 'ana.costa@empresa.com', 'ana.costa_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1001),
(1005, 'Lucas Almeida', 'lucas.almeida@empresa.com', 'lucas.almeida_empresa.com#EXT#', NOW(), NOW(), 
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1), 1001);

-- =========================
-- Inserir dados na tabela projetos
-- =========================
INSERT INTO projetos (
    id_projeto, nome_projeto, data_entrega_projeto, data_inicio_projeto, 
    id_estado_dado
) VALUES
('PROJ01', 'Sistema de Gestão Interna', '2024-12-30', '2024-01-10',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
('PROJ02', 'Portal do Cliente', '2024-11-15', '2024-02-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
('PROJ03', 'Aplicativo Mobile', '2025-01-30', '2024-03-05',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1)),
('PROJ04', 'Migração de Dados', '2024-09-20', '2024-05-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Concluído' LIMIT 1));

-- =========================
-- Inserir dados na tabela equipe (UMA SÓ EQUIPE)
-- =========================
INSERT INTO equipe (id_equipe, usuarios_matricula) VALUES
(UUID_TO_BIN(UUID()), 1001);

-- =========================
-- Inserir dados na tabela assoc_cargo_equipe
-- =========================
INSERT INTO assoc_cargo_equipe (
    id_assoc_cargo_equipe, usuarios_matricula, equipe_id_equipe, 
    cargo_usuario_id_cargo_usuario, valor_hora
) VALUES
(UUID_TO_BIN(UUID()), 1002, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1001),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor Senior'), 120.00),
(UUID_TO_BIN(UUID()), 1003, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1001),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor Pleno'), 90.00),
(UUID_TO_BIN(UUID()), 1004, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1001),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor Junior'), 65.00),
(UUID_TO_BIN(UUID()), 1005, (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1001),
 (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Analista de Sistemas'), 80.00);

-- =========================
-- Inserir dados na tabela assoc_usuario_projetos
-- =========================
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1001, 'PROJ01', NOW(), 40, NOW()),
(UUID_TO_BIN(UUID()), 1002, 'PROJ01', NOW(), 60, NOW()),
(UUID_TO_BIN(UUID()), 1003, 'PROJ01', NOW(), 70, NOW()),
(UUID_TO_BIN(UUID()), 1004, 'PROJ01', NOW(), 80, NOW()),
(UUID_TO_BIN(UUID()), 1005, 'PROJ01', NOW(), 20, NOW()),
(UUID_TO_BIN(UUID()), 1001, 'PROJ02', NOW(), 40, NOW()),
(UUID_TO_BIN(UUID()), 1002, 'PROJ02', NOW(), 60, NOW()),
(UUID_TO_BIN(UUID()), 1003, 'PROJ02', NOW(), 70, NOW());

-- =========================
-- Inserir dados na tabela apontamentos
-- =========================

INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, justificativa_apontamento,
    id_projeto, hora_inicio_apontamento, hora_fim_apontamento, horas_totais_apontamento,
    motivo_apontamento, usuarios_matricula, id_estado_dado
) VALUES
-- PROJ01 - Usuario 1001 com MAIS horas (dias completos)
(UUID_TO_BIN(UUID()), '2024-02-01 08:00:00', 'Reunião inicial do projeto', 'Definição de escopo', 'PROJ01', '08:00:00', '12:00:00', NULL, 'Planejamento', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-01 13:00:00', 'Análise de requisitos', 'Documentação técnica', 'PROJ01', '13:00:00', '18:00:00', NULL, 'Análise', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-02 08:00:00', 'Acompanhamento equipe', 'Verificação de progresso', 'PROJ01', '08:00:00', '12:00:00', NULL, 'Gestão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-02 13:00:00', 'Revisão de métricas', 'Análise de KPIs', 'PROJ01', '13:00:00', '18:00:00', NULL, 'Análise', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-03 08:00:00', 'Aprovação de entregas', 'Validação sprint 1', 'PROJ01', '08:00:00', '12:00:00', NULL, 'Revisão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-03 13:00:00', 'Planejamento sprint 2', 'Priorização backlog', 'PROJ01', '13:00:00', '18:00:00', NULL, 'Planejamento', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-04 08:00:00', 'Reunião com cliente', 'Apresentação parcial', 'PROJ01', '08:00:00', '12:00:00', NULL, 'Gestão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-04 13:00:00', 'Follow-up ações', 'Definição de próximos passos', 'PROJ01', '13:00:00', '18:00:00', NULL, 'Gestão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-05 08:00:00', 'Análise de riscos', 'Identificação de blockers', 'PROJ01', '08:00:00', '12:00:00', NULL, 'Análise', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-05 13:00:00', 'Report de status', 'Relatório para diretoria', 'PROJ01', '13:00:00', '18:00:00', NULL, 'Documentação', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),

-- PROJ02 - Usuario 1001 com MENOS horas (apenas reuniões curtas)
(UUID_TO_BIN(UUID()), '2024-02-06 09:00:00', 'Reunião inicial PROJ02', 'Apresentação da equipe', 'PROJ02', '09:00:00', '10:00:00', NULL, 'Planejamento', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-07 14:00:00', 'Acompanhamento sprint', 'Análise de progresso', 'PROJ02', '14:00:00', '15:00:00', NULL, 'Gestão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-08 09:00:00', 'Aprovação de layout', 'Validação do front-end', 'PROJ02', '09:00:00', '10:00:00', NULL, 'Revisão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-09 10:00:00', 'Reunião cliente', 'Coleta de feedback', 'PROJ02', '10:00:00', '11:00:00', NULL, 'Gestão', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1)),
(UUID_TO_BIN(UUID()), '2024-02-10 13:00:00', 'Planejamento sprint 2', 'Definição de metas', 'PROJ02', '13:00:00', '14:00:00', NULL, 'Planejamento', 1001, (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1));

-- Maria (1002) - PROJ01 com MENOS horas
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-01 09:00:00', 'Implementação API usuários', 'CRUD de usuários', 'PROJ01', '09:00:00', '11:00:00', NULL, 'Desenvolvimento', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-02 13:00:00', 'Correção bugs sprint 1', 'Ajuste de autenticação', 'PROJ01', '13:00:00', '15:00:00', NULL, 'Correção', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-03 09:00:00', 'Revisão de código', 'Code review PR #42', 'PROJ01', '09:00:00', '10:30:00', NULL, 'Revisão', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;

-- Maria (1002) - PROJ02 com MAIS horas (dias completos)
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-06 08:00:00', 'Modelagem do banco', 'Criação de tabelas principais', 'PROJ02', '08:00:00', '12:00:00', NULL, 'Desenvolvimento', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-06 13:00:00', 'Implementação entidades', 'Classes de domínio', 'PROJ02', '13:00:00', '18:00:00', NULL, 'Desenvolvimento', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-07 08:00:00', 'Testes unitários', 'Cobertura 75%', 'PROJ02', '08:00:00', '12:00:00', NULL, 'Testes', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-07 13:00:00', 'Integração contínua', 'Configuração pipeline', 'PROJ02', '13:00:00', '18:00:00', NULL, 'Configuração', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-08 08:00:00', 'Refatoração código', 'Melhoria de performance', 'PROJ02', '08:00:00', '12:00:00', NULL, 'Refatoração', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-08 13:00:00', 'Otimização queries', 'Análise de performance', 'PROJ02', '13:00:00', '18:00:00', NULL, 'Otimização', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-09 08:00:00', 'Revisão peer code', 'Feedback entre devs', 'PROJ02', '08:00:00', '12:00:00', NULL, 'Revisão', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-09 13:00:00', 'Documentação técnica', 'API endpoints', 'PROJ02', '13:00:00', '18:00:00', NULL, 'Documentação', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-10 08:00:00', 'Deploy teste', 'Ambiente staging', 'PROJ02', '08:00:00', '12:00:00', NULL, 'Deploy', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;
INSERT INTO apontamentos
SELECT UUID_TO_BIN(UUID()), '2024-02-10 13:00:00', 'Monitoramento produção', 'Análise de logs', 'PROJ02', '13:00:00', '18:00:00', NULL, 'Monitoramento', 1002, id_estado_dado 
FROM estado_dados WHERE nome_estado_dado='Ativo' LIMIT 1;