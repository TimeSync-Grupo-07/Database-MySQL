USE Timesync;

-- ================================================
-- 1. ESTADOS DE DADOS (expandidos)
-- ================================================
INSERT INTO estado_dados (id_estado_dado, nome_estado_dado) VALUES
(UUID_TO_BIN(UUID()), 'Ativo'),
(UUID_TO_BIN(UUID()), 'Inativo'),
(UUID_TO_BIN(UUID()), 'Pendente'),
(UUID_TO_BIN(UUID()), 'Concluído'),
(UUID_TO_BIN(UUID()), 'Em Andamento'),
(UUID_TO_BIN(UUID()), 'Cancelado'),
(UUID_TO_BIN(UUID()), 'Aguardando Aprovação'),
(UUID_TO_BIN(UUID()), 'Pausado'),
(UUID_TO_BIN(UUID()), 'Em Revisão'),
(UUID_TO_BIN(UUID()), 'Arquivado');

-- ================================================
-- 2. CARGOS DE USUÁRIO (expandidos)
-- ================================================
INSERT INTO cargo_usuario (id_cargo_usuario, titulo_cargo_usuario) VALUES
(UUID_TO_BIN(UUID()), 'Desenvolvedor RPA Júnior'),
(UUID_TO_BIN(UUID()), 'Desenvolvedor RPA Pleno'),
(UUID_TO_BIN(UUID()), 'Desenvolvedor RPA Sênior'),
(UUID_TO_BIN(UUID()), 'Analista de Processos Júnior'),
(UUID_TO_BIN(UUID()), 'Analista de Processos Pleno'),
(UUID_TO_BIN(UUID()), 'Analista de Processos Sênior'),
(UUID_TO_BIN(UUID()), 'Coordenador de Projetos'),
(UUID_TO_BIN(UUID()), 'Gerente de Projetos'),
(UUID_TO_BIN(UUID()), 'Especialista em Automação'),
(UUID_TO_BIN(UUID()), 'Arquiteto RPA'),
(UUID_TO_BIN(UUID()), 'Product Owner'),
(UUID_TO_BIN(UUID()), 'Scrum Master'),
(UUID_TO_BIN(UUID()), 'QA Analyst'),
(UUID_TO_BIN(UUID()), 'DevOps Engineer'),
(UUID_TO_BIN(UUID()), 'Business Analyst');

-- ================================================
-- 3. USUÁRIOS (20 usuários - hierarquia completa)
-- ================================================
-- Obter ID do estado Ativo uma vez para otimizar
SET @estado_ativo = (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo' LIMIT 1);
SET @estado_inativo = (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Inativo' LIMIT 1);
SET @estado_concluido = (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Concluído' LIMIT 1);

INSERT INTO usuarios (
    matricula, nome_completo_usuario, email_usuario, senha_usuario, 
    id_microsoft_usuario, data_criacao_usuario, data_atualizacao_usuario, 
    id_estado_dado, matricula_superior
) VALUES
-- Gerente Geral (sem superior)
(1001, 'Roberto Mendes', 'roberto.mendes@empresa.com', 'Hash123!', 
 'roberto.mendes_empresa.com#EXT#', '2024-01-15', NOW(),
 @estado_ativo, NULL),

-- Gerentes de Projeto (superior: 1001)
(1002, 'Carla Santos', 'carla.santos@empresa.com', 'Hash123!',
 'carla.santos_empresa.com#EXT#', '2024-02-10', NOW(),
 @estado_ativo, 1001),
 
(1003, 'Fernando Oliveira', 'fernando.oliveira@empresa.com', 'Hash123!',
 'fernando.oliveira_empresa.com#EXT#', '2024-02-12', NOW(),
 @estado_ativo, 1001),
 
(1004, 'Patricia Lima', 'patricia.lima@empresa.com', 'Hash123!',
 'patricia.lima_empresa.com#EXT#', '2024-02-15', NOW(),
 @estado_ativo, 1001),

-- Coordenadores (superiores: 1002, 1003, 1004)
(1005, 'Ricardo Almeida', 'ricardo.almeida@empresa.com', 'Hash123!',
 'ricardo.almeida_empresa.com#EXT#', '2024-03-01', NOW(),
 @estado_ativo, 1002),
 
(1006, 'Juliana Costa', 'juliana.costa@empresa.com', 'Hash123!',
 'juliana.costa_empresa.com#EXT#', '2024-03-05', NOW(),
 @estado_ativo, 1003),
 
(1007, 'Marcos Silva', 'marcos.silva@empresa.com', 'Hash123!',
 'marcos.silva_empresa.com#EXT#', '2024-03-10', NOW(),
 @estado_ativo, 1004),

-- Sêniors (superiores: coordenadores)
(1008, 'Ana Beatriz', 'ana.beatriz@empresa.com', 'Hash123!',
 'ana.beatriz_empresa.com#EXT#', '2024-04-01', NOW(),
 @estado_ativo, 1005),
 
(1009, 'Gabriel Torres', 'gabriel.torres@empresa.com', 'Hash123!',
 'gabriel.torres_empresa.com#EXT#', '2024-04-05', NOW(),
 @estado_ativo, 1006),
 
(1010, 'Camila Rocha', 'camila.rocha@empresa.com', 'Hash123!',
 'camila.rocha_empresa.com#EXT#', '2024-04-10', NOW(),
 @estado_ativo, 1007),

-- Plenos
(1011, 'Lucas Pereira', 'lucas.pereira@empresa.com', 'Hash123!',
 'lucas.pereira_empresa.com#EXT#', '2024-05-01', NOW(),
 @estado_ativo, 1008),
 
(1012, 'Mariana Santos', 'mariana.santos@empresa.com', 'Hash123!',
 'mariana.santos_empresa.com#EXT#', '2024-05-05', NOW(),
 @estado_ativo, 1009),
 
(1013, 'Bruno Oliveira', 'bruno.oliveira@empresa.com', 'Hash123!',
 'bruno.oliveira_empresa.com#EXT#', '2024-05-10', NOW(),
 @estado_ativo, 1010),

-- Júniores
(1014, 'Isabela Martins', 'isabela.martins@empresa.com', 'Hash123!',
 'isabela.martins_empresa.com#EXT#', '2024-06-01', NOW(),
 @estado_ativo, 1011),
 
(1015, 'Thiago Souza', 'thiago.souza@empresa.com', 'Hash123!',
 'thiago.souza_empresa.com#EXT#', '2024-06-05', NOW(),
 @estado_ativo, 1012),
 
(1016, 'Vanessa Lima', 'vanessa.lima@empresa.com', 'Hash123!',
 'vanessa.lima_empresa.com#EXT#', '2024-06-10', NOW(),
 @estado_ativo, 1013),

-- Estagiários/Outros
(1017, 'Rafael Costa', 'rafael.costa@empresa.com', 'Hash123!',
 'rafael.costa_empresa.com#EXT#', '2024-07-01', NOW(),
 @estado_ativo, 1014),
 
(1018, 'Carolina Alves', 'carolina.alves@empresa.com', 'Hash123!',
 'carolina.alves_empresa.com#EXT#', '2024-07-05', NOW(),
 @estado_ativo, 1015),
 
(1019, 'Diego Rodrigues', 'diego.rodrigues@empresa.com', 'Hash123!',
 'diego.rodrigues_empresa.com#EXT#', '2024-07-10', NOW(),
 @estado_ativo, 1016),

-- Usuário inativo para teste
(1020, 'João Inativo', 'joao.inativo@empresa.com', 'Hash123!',
 'joao.inativo_empresa.com#EXT#', '2024-01-01', NOW(),
 @estado_inativo, 1001);

-- ================================================
-- 4. PROJETOS (15 projetos diversos)
-- ================================================
INSERT INTO projetos (
    id_projeto, nome_projeto, data_entrega_projeto, data_inicio_projeto, 
    id_estado_dado
) VALUES
-- Projetos Ativos
('PC.101', 'Itaú - Automação Onboarding', '2025-12-30', '2025-08-01',
 @estado_ativo),
 
('PC.102', 'Bradesco - Process Mining CFO', '2025-11-15', '2025-08-01',
 @estado_ativo),
 
('PC.103', 'Santander - Bot Crédito Consignado', '2025-10-30', '2025-08-01',
 @estado_ativo),
 
('PC.104', 'BB - Automação Backoffice', '2025-09-20', '2025-08-01',
 @estado_ativo),
 
('PC.105', 'Nubank - OCR Faturamento', '2025-12-15', '2025-09-01',
 @estado_ativo),
 
('PC.106', 'Inter - RPA Contábil', '2026-01-31', '2025-10-01',
 @estado_ativo),

-- Projetos Em Andamento
('PC.201', 'Caixa - Digitalização Processos', '2025-11-30', '2025-07-15',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Em Andamento' LIMIT 1)),
 
('PC.202', 'XP Investimentos - Bot Trade', '2025-10-15', '2025-06-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Em Andamento' LIMIT 1)),

-- Projetos Concluídos
('PC.301', 'BTG - Automação Relatórios', '2025-06-30', '2025-01-15',
 @estado_concluido),
 
('PC.302', 'C6 Bank - Sistema Anti-fraude', '2025-05-20', '2024-12-01',
 @estado_concluido),

-- Projetos Pendentes
('PC.401', 'Mercado Pago - Chatbot', '2026-03-31', '2026-01-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Pendente' LIMIT 1)),

-- Projetos Cancelados
('PC.501', 'Original - Migração Legacy', '2025-08-30', '2025-04-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Cancelado' LIMIT 1)),

-- Projetos em Revisão
('PC.601', 'PicPay - Analytics RPA', '2025-12-31', '2025-09-01',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Em Revisão' LIMIT 1)),

-- Projetos Pausados
('PC.701', 'Neon - Integração APIs', '2026-02-28', '2025-08-15',
 (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Pausado' LIMIT 1)),

-- Projeto com prazo curto (para views de prazo)
('PC.801', 'Sicoob - Emergência Sistema', '2025-08-31', '2025-08-25',
 @estado_ativo);

-- ================================================
-- 5. EQUIPES (3 equipes diferentes)
-- ================================================
INSERT INTO equipe (id_equipe, usuarios_matricula) VALUES
(UUID_TO_BIN(UUID()), 1001), -- Equipe 1 - Roberto (Gestor)
(UUID_TO_BIN(UUID()), 1002), -- Equipe 2 - Carla
(UUID_TO_BIN(UUID()), 1003); -- Equipe 3 - Fernando

-- ================================================
-- 6. ASSOCIAÇÃO CARGO-EQUIPE (todos os usuários)
-- ================================================
-- Obter IDs de cargos uma vez
SET @cargo_gerente = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Gerente de Projetos' LIMIT 1);
SET @cargo_coordenador = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Coordenador de Projetos' LIMIT 1);
SET @cargo_senior = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor RPA Sênior' LIMIT 1);
SET @cargo_pleno = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor RPA Pleno' LIMIT 1);
SET @cargo_junior = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Desenvolvedor RPA Júnior' LIMIT 1);
SET @cargo_qa = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'QA Analyst' LIMIT 1);
SET @cargo_arquiteto = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Arquiteto RPA' LIMIT 1);
SET @cargo_analista_pleno = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Analista de Processos Pleno' LIMIT 1);
SET @cargo_analista_junior = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Analista de Processos Júnior' LIMIT 1);
SET @cargo_business = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Business Analyst' LIMIT 1);
SET @cargo_scrum = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Scrum Master' LIMIT 1);
SET @cargo_especialista = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Especialista em Automação' LIMIT 1);
SET @cargo_devops = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'DevOps Engineer' LIMIT 1);
SET @cargo_product = (SELECT id_cargo_usuario FROM cargo_usuario WHERE titulo_cargo_usuario = 'Product Owner' LIMIT 1);

-- Obter IDs das equipes
SET @equipe_1 = (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1001 LIMIT 1);
SET @equipe_2 = (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1002 LIMIT 1);
SET @equipe_3 = (SELECT id_equipe FROM equipe WHERE usuarios_matricula = 1003 LIMIT 1);

-- Nota: Valores hora realistas baseados em cargos
INSERT INTO assoc_cargo_equipe (
    id_assoc_cargo_equipe, usuarios_matricula, equipe_id_equipe, 
    cargo_usuario_id_cargo_usuario, valor_hora
) VALUES
-- Equipe 1 (Roberto)
(UUID_TO_BIN(UUID()), 1001, @equipe_1, @cargo_gerente, 250.00),
(UUID_TO_BIN(UUID()), 1005, @equipe_1, @cargo_coordenador, 180.00),
(UUID_TO_BIN(UUID()), 1008, @equipe_1, @cargo_senior, 150.00),
(UUID_TO_BIN(UUID()), 1011, @equipe_1, @cargo_pleno, 120.00),
(UUID_TO_BIN(UUID()), 1014, @equipe_1, @cargo_junior, 80.00),
(UUID_TO_BIN(UUID()), 1017, @equipe_1, @cargo_qa, 90.00),

-- Equipe 2 (Carla)
(UUID_TO_BIN(UUID()), 1002, @equipe_2, @cargo_gerente, 240.00),
(UUID_TO_BIN(UUID()), 1006, @equipe_2, @cargo_coordenador, 175.00),
(UUID_TO_BIN(UUID()), 1009, @equipe_2, @cargo_arquiteto, 200.00),
(UUID_TO_BIN(UUID()), 1012, @equipe_2, @cargo_analista_pleno, 110.00),
(UUID_TO_BIN(UUID()), 1015, @equipe_2, @cargo_analista_junior, 75.00),
(UUID_TO_BIN(UUID()), 1018, @equipe_2, @cargo_business, 95.00),

-- Equipe 3 (Fernando)
(UUID_TO_BIN(UUID()), 1003, @equipe_3, @cargo_gerente, 235.00),
(UUID_TO_BIN(UUID()), 1007, @equipe_3, @cargo_scrum, 160.00),
(UUID_TO_BIN(UUID()), 1010, @equipe_3, @cargo_especialista, 170.00),
(UUID_TO_BIN(UUID()), 1013, @equipe_3, @cargo_senior, 145.00),
(UUID_TO_BIN(UUID()), 1016, @equipe_3, @cargo_devops, 130.00),
(UUID_TO_BIN(UUID()), 1019, @equipe_3, @cargo_product, 180.00);

-- ================================================
-- 7. ASSOCIAÇÃO USUÁRIO-PROJETOS (alocações diversas)
-- ================================================
-- Projeto PC.101 (Grande projeto, várias pessoas)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1005, 'PC.101', '2025-08-01', 200, NOW()), -- Coordenador
(UUID_TO_BIN(UUID()), 1008, 'PC.101', '2025-08-01', 160, NOW()), -- Sênior
(UUID_TO_BIN(UUID()), 1011, 'PC.101', '2025-08-01', 120, NOW()), -- Pleno
(UUID_TO_BIN(UUID()), 1014, 'PC.101', '2025-08-01', 80, NOW()),  -- Júnior
(UUID_TO_BIN(UUID()), 1017, 'PC.101', '2025-08-01', 100, NOW()); -- QA

-- Projeto PC.102 (Equipe média)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1006, 'PC.102', '2025-08-01', 180, NOW()),
(UUID_TO_BIN(UUID()), 1009, 'PC.102', '2025-08-01', 150, NOW()),
(UUID_TO_BIN(UUID()), 1012, 'PC.102', '2025-08-01', 140, NOW()),
(UUID_TO_BIN(UUID()), 1015, 'PC.102', '2025-08-01', 90, NOW());

-- Projeto PC.103 (Time pequeno)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1007, 'PC.103', '2025-08-01', 160, NOW()),
(UUID_TO_BIN(UUID()), 1010, 'PC.103', '2025-08-01', 140, NOW()),
(UUID_TO_BIN(UUID()), 1013, 'PC.103', '2025-08-01', 130, NOW());

-- Projeto PC.104 (Projeto individual)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1016, 'PC.104', '2025-08-01', 100, NOW());

-- Projeto PC.105 (Time misto)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1008, 'PC.105', '2025-09-01', 120, NOW()),
(UUID_TO_BIN(UUID()), 1012, 'PC.105', '2025-09-01', 100, NOW()),
(UUID_TO_BIN(UUID()), 1016, 'PC.105', '2025-09-01', 80, NOW());

-- Projeto PC.201 (Projeto em andamento com muitas horas)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1005, 'PC.201', '2025-07-15', 300, NOW()),
(UUID_TO_BIN(UUID()), 1009, 'PC.201', '2025-07-15', 250, NOW()),
(UUID_TO_BIN(UUID()), 1013, 'PC.201', '2025-07-15', 200, NOW()),
(UUID_TO_BIN(UUID()), 1017, 'PC.201', '2025-07-15', 150, NOW());

-- Projeto PC.801 (Projeto emergencial - pouco planejado)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
(UUID_TO_BIN(UUID()), 1008, 'PC.801', '2025-08-25', 40, NOW()),
(UUID_TO_BIN(UUID()), 1011, 'PC.801', '2025-08-25', 30, NOW());

-- ================================================
-- 8. APONTAMENTOS (dados ricos para todas as views)
-- ================================================

-- Criar uma tabela temporária para armazenar IDs de projetos para uso no loop
CREATE TEMPORARY TABLE IF NOT EXISTS temp_projetos (
    id CHAR(6),
    ordem INT
);

-- Inserir projetos na ordem desejada
INSERT INTO temp_projetos (id, ordem) VALUES
('PC.101', 1),
('PC.102', 2),
('PC.103', 3),
('PC.104', 4),
('PC.105', 5),
('PC.201', 6),
('PC.801', 7);

-- Procedimento simplificado sem a variável problemática
DELIMITER //
CREATE PROCEDURE InserirApontamentoBatch()
BEGIN
    DECLARE data_atual DATE;
    DECLARE usuario_matricula INT;
    DECLARE projeto_id CHAR(6);
    DECLARE projeto_count INT;
    DECLARE projeto_index INT;
    
    -- Contar projetos
    SET projeto_count = (SELECT COUNT(*) FROM temp_projetos);
    
    -- Loop por dias de agosto 2025 (1-31)
    SET data_atual = '2025-08-01';
    
    WHILE data_atual <= '2025-08-31' DO
        -- Pular finais de semana (sábado=6, domingo=0)
        IF DAYOFWEEK(data_atual) NOT IN (1,7) THEN
            -- Para cada usuário ativo (1001-1019)
            SET usuario_matricula = 1001;
            
            WHILE usuario_matricula <= 1019 DO
                IF usuario_matricula != 1020 THEN -- Pular inativo
                    -- Escolher projeto aleatório para o dia
                    SET projeto_index = FLOOR(1 + RAND() * projeto_count);
                    SET projeto_id = (SELECT id FROM temp_projetos WHERE ordem = projeto_index);
                    
                    -- Inserir apontamento do turno da manhã
                    INSERT INTO apontamentos (
                        id_apontamento, data_apontamento, ocorrencia_apontamento, 
                        justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
                        hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
                        usuarios_matricula, id_estado_dado
                    ) VALUES (
                        UUID_TO_BIN(UUID()),
                        data_atual,
                        CASE 
                            WHEN RAND() < 0.7 THEN 'Relógio Web'
                            WHEN RAND() < 0.9 THEN 'Marcação Manual'
                            ELSE 'Hora Extra'
                        END,
                        CASE 
                            WHEN RAND() < 0.1 THEN 'Justificativa necessária'
                            ELSE NULL
                        END,
                        CASE WHEN RAND() < 0.8 THEN projeto_id ELSE NULL END,
                        '08:00:00',
                        '12:00:00',
                        NULL,
                        CASE 
                            WHEN RAND() < 0.05 THEN 'Hora Extra'
                            WHEN RAND() < 0.1 THEN 'Retroativo'
                            ELSE 'Trabalho normal'
                        END,
                        usuario_matricula,
                        @estado_ativo
                    );
                    
                    -- Inserir apontamento do turno da tarde
                    INSERT INTO apontamentos (
                        id_apontamento, data_apontamento, ocorrencia_apontamento, 
                        justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
                        hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
                        usuarios_matricula, id_estado_dado
                    ) VALUES (
                        UUID_TO_BIN(UUID()),
                        data_atual,
                        CASE 
                            WHEN RAND() < 0.8 THEN 'Relógio Web'
                            WHEN RAND() < 0.95 THEN 'Marcação Manual'
                            ELSE 'Hora Extra'
                        END,
                        CASE 
                            WHEN RAND() < 0.05 THEN 'Ajuste manual necessário'
                            ELSE NULL
                        END,
                        CASE WHEN RAND() < 0.9 THEN projeto_id ELSE NULL END,
                        '13:00:00',
                        CASE 
                            WHEN RAND() < 0.1 THEN '19:00:00' -- Hora extra
                            WHEN RAND() < 0.2 THEN '17:30:00' -- Meia hora extra
                            ELSE '17:00:00' -- Horário normal
                        END,
                        NULL,
                        CASE 
                            WHEN RAND() < 0.07 THEN 'Hora Extra'
                            WHEN RAND() < 0.15 THEN 'Retroativo'
                            ELSE 'Trabalho normal'
                        END,
                        usuario_matricula,
                        @estado_ativo
                    );
                    
                    -- 20% de chance de ter apontamento adicional noturno (hora extra)
                    IF RAND() < 0.2 THEN
                        INSERT INTO apontamentos (
                            id_apontamento, data_apontamento, ocorrencia_apontamento, 
                            justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
                            hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
                            usuarios_matricula, id_estado_dado
                        ) VALUES (
                            UUID_TO_BIN(UUID()),
                            data_atual,
                            'Hora Extra',
                            'Demanda urgente',
                            projeto_id,
                            '18:00:00',
                            '20:00:00',
                            2.0,
                            'Hora Extra',
                            usuario_matricula,
                            @estado_ativo
                        );
                    END IF;
                    
                    -- 10% de chance de apontamento retroativo
                    IF RAND() < 0.1 THEN
                        INSERT INTO apontamentos (
                            id_apontamento, data_apontamento, ocorrencia_apontamento, 
                            justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
                            hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
                            usuarios_matricula, id_estado_dado
                        ) VALUES (
                            UUID_TO_BIN(UUID()),
                            DATE_SUB(data_atual, INTERVAL FLOOR(1 + RAND() * 5) DAY),
                            'Marcação Manual',
                            'Esquecimento de apontamento',
                            projeto_id,
                            NULL,
                            NULL,
                            ROUND(4 + (RAND() * 4), 1),
                            'Retroativo',
                            usuario_matricula,
                            @estado_ativo
                        );
                    END IF;
                END IF;
                
                SET usuario_matricula = usuario_matricula + 1;
            END WHILE;
            
            -- Dias 15 e 30: Inserir folgas compensatórias para alguns
            IF DAY(data_atual) IN (15, 30) THEN
                INSERT INTO apontamentos (
                    id_apontamento, data_apontamento, ocorrencia_apontamento, 
                    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
                    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
                    usuarios_matricula, id_estado_dado
                ) VALUES 
                (UUID_TO_BIN(UUID()), data_atual, 'Compensado', 'Folga', NULL, NULL, NULL, 0, 'Folga', 1001, @estado_ativo),
                (UUID_TO_BIN(UUID()), data_atual, 'Compensado', 'Folga', NULL, NULL, NULL, 0, 'Folga', 1005, @estado_ativo),
                (UUID_TO_BIN(UUID()), data_atual, 'Compensado', 'Folga', NULL, NULL, NULL, 0, 'Folga', 1008, @estado_ativo);
            END IF;
        END IF;
        
        SET data_atual = DATE_ADD(data_atual, INTERVAL 1 DAY);
    END WHILE;
    
END //
DELIMITER ;

-- Executar o batch de inserção de apontamentos
CALL InserirApontamentoBatch();

-- Drop procedure após uso
DROP PROCEDURE InserirApontamentoBatch;

-- Remover tabela temporária
DROP TEMPORARY TABLE IF EXISTS temp_projetos;

-- ================================================
-- 9. DADOS ESPECÍFICOS PARA TESTES DAS VIEWS
-- ================================================

-- 1. Projeto com horas extras significativas (PC.801 - emergencial)
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, 
    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
    usuarios_matricula, id_estado_dado
) VALUES
(UUID_TO_BIN(UUID()), '2025-08-26', 'Hora Extra', 'Emergência', 'PC.801', '08:00:00', '22:00:00', 14, 'Hora Extra', 1008, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-27', 'Hora Extra', 'Emergência', 'PC.801', '08:00:00', '20:00:00', 12, 'Hora Extra', 1011, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-28', 'Hora Extra', 'Crítica', 'PC.801', '08:00:00', '23:00:00', 15, 'Hora Extra', 1008, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-28', 'Hora Extra', 'Crítica', 'PC.801', '08:00:00', '21:00:00', 13, 'Hora Extra', 1011, @estado_ativo);

-- 2. Projeto com muitos retroativos (PC.201 - complexo)
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, 
    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
    usuarios_matricula, id_estado_dado
) VALUES
(UUID_TO_BIN(UUID()), '2025-08-10', 'Marcação Manual', 'Esquecimento', 'PC.201', NULL, NULL, 6, 'Retroativo', 1009, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-12', 'Marcação Manual', 'Correção', 'PC.201', NULL, NULL, 8, 'Retroativo', 1013, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-15', 'Marcação Manual', 'Ajuste', 'PC.201', NULL, NULL, 4, 'Retroativo', 1005, @estado_ativo);

-- 3. Projeto concluído com histórico (PC.301)
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, 
    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
    usuarios_matricula, id_estado_dado
) VALUES
(UUID_TO_BIN(UUID()), '2025-06-28', 'Relógio Web', NULL, 'PC.301', '08:00:00', '18:00:00', 10, 'Hora Extra', 1005, @estado_concluido),
(UUID_TO_BIN(UUID()), '2025-06-29', 'Relógio Web', NULL, 'PC.301', '08:00:00', '17:00:00', 9, 'Trabalho normal', 1005, @estado_concluido),
(UUID_TO_BIN(UUID()), '2025-06-10', 'Relógio Web', NULL, 'PC.301', '08:00:00', '18:00:00', 10, 'Hora Extra', 1005, @estado_concluido),
(UUID_TO_BIN(UUID()), '2025-06-11', 'Relógio Web', NULL, 'PC.301', '08:00:00', '18:00:00', 10, 'Hora Extra', 1009, @estado_concluido);

-- 4. Usuário com múltiplos projetos no mesmo dia (sobrecarga)
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, 
    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
    usuarios_matricula, id_estado_dado
) VALUES
(UUID_TO_BIN(UUID()), '2025-08-20', 'Relógio Web', NULL, 'PC.101', '08:00:00', '12:00:00', 4, 'Trabalho normal', 1008, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-20', 'Relógio Web', NULL, 'PC.105', '13:00:00', '17:00:00', 4, 'Trabalho normal', 1008, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-08-20', 'Hora Extra', 'Demanda urgente', 'PC.801', '18:00:00', '21:00:00', 3, 'Hora Extra', 1008, @estado_ativo);

-- 5. Dados para meses anteriores (testar comparativo)
-- Julho 2025 (mês anterior)
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, 
    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
    usuarios_matricula, id_estado_dado
) VALUES
(UUID_TO_BIN(UUID()), '2025-07-15', 'Relógio Web', NULL, 'PC.201', '08:00:00', '12:00:00', 4, 'Trabalho normal', 1005, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-07-15', 'Relógio Web', NULL, 'PC.201', '13:00:00', '17:00:00', 4, 'Trabalho normal', 1005, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-07-20', 'Hora Extra', 'Entrega parcial', 'PC.201', '08:00:00', '20:00:00', 12, 'Hora Extra', 1009, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-07-25', 'Relógio Web', NULL, 'PC.101', '08:00:00', '12:00:00', 4, 'Trabalho normal', 1011, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-07-25', 'Relógio Web', NULL, 'PC.101', '13:00:00', '17:00:00', 4, 'Trabalho normal', 1011, @estado_ativo);

-- Setembro 2025 (próximo mês - alguns dados futuros)
INSERT INTO apontamentos (
    id_apontamento, data_apontamento, ocorrencia_apontamento, 
    justificativa_apontamento, id_projeto, hora_inicio_apontamento, 
    hora_fim_apontamento, horas_totais_apontamento, motivo_apontamento, 
    usuarios_matricula, id_estado_dado
) VALUES
(UUID_TO_BIN(UUID()), '2025-09-02', 'Marcação Manual', 'Planejamento', 'PC.105', NULL, NULL, 8, 'Trabalho normal', 1016, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-09-03', 'Relógio Web', NULL, 'PC.105', '08:00:00', '12:00:00', 4, 'Trabalho normal', 1016, @estado_ativo),
(UUID_TO_BIN(UUID()), '2025-09-03', 'Relógio Web', NULL, 'PC.105', '13:00:00', '17:00:00', 4, 'Trabalho normal', 1016, @estado_ativo);

-- ================================================
-- 10. INSERÇÕES ADICIONAIS PARA TESTES ESPECÍFICOS
-- ================================================

-- Inserir associações cruzadas (usuários em múltiplos projetos)
INSERT INTO assoc_usuario_projetos (
    id_assoc_usuarios_projetos, usuarios_matricula, id_projeto, 
    data_criacao_associacao, horas_planejadas, data_atualizacao_associacao
) VALUES
-- Usuário 1008 em mais projetos (sobrecarregado)
(UUID_TO_BIN(UUID()), 1008, 'PC.201', '2025-08-15', 50, NOW()),
(UUID_TO_BIN(UUID()), 1008, 'PC.104', '2025-08-20', 30, NOW()),

-- Usuário 1012 em múltiplos projetos
(UUID_TO_BIN(UUID()), 1012, 'PC.103', '2025-08-10', 60, NOW()),
(UUID_TO_BIN(UUID()), 1012, 'PC.201', '2025-08-05', 40, NOW()),

-- Projeto com apenas 1 pessoa (PC.104 já tem)
(UUID_TO_BIN(UUID()), 1019, 'PC.104', '2025-08-15', 20, NOW()); -- Adiciona mais uma pessoa

-- ================================================
-- VERIFICAÇÃO FINAL
-- ================================================

SELECT '=== ESTATÍSTICAS DOS DADOS INSERIDOS ===' as Info;

SELECT 
    'Estado Dados' as Tabela,
    COUNT(*) as Total
FROM estado_dados
UNION ALL
SELECT 
    'Cargos',
    COUNT(*)
FROM cargo_usuario
UNION ALL
SELECT 
    'Usuários',
    COUNT(*)
FROM usuarios
UNION ALL
SELECT 
    'Projetos',
    COUNT(*)
FROM projetos
UNION ALL
SELECT 
    'Equipes',
    COUNT(*)
FROM equipe
UNION ALL
SELECT 
    'Assoc Cargo-Equipe',
    COUNT(*)
FROM assoc_cargo_equipe
UNION ALL
SELECT 
    'Assoc Usuário-Projetos',
    COUNT(*)
FROM assoc_usuario_projetos
UNION ALL
SELECT 
    'Apontamentos',
    COUNT(*)
FROM apontamentos;