-- init/03-create-views.sql
USE Timesync;

-- View de Exemplo
CREATE OR REPLACE VIEW nome_funcionario__nome_superior AS
SELECT 
    u.nome_completo_usuario AS nome_funcionario,
    s.nome_completo_usuario AS nome_superior
FROM usuarios u
LEFT JOIN usuarios s ON s.matricula = u.matricula_superior;

-- Tela de Projetos
-- View de Distribuição de esforço entre colaboradores por projeto
CREATE OR REPLACE VIEW vw_distribuicao_esforco AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    u.matricula,
    u.nome_completo_usuario AS nome_colaborador,
    aup.horas_planejadas,
    ROUND((aup.horas_planejadas / SUM(aup.horas_planejadas)
           OVER (PARTITION BY p.id_projeto)) * 100, 2) AS percentual_esforco
FROM assoc_usuario_projetos aup
LEFT JOIN usuarios u ON CAST(u.matricula AS CHAR) = CAST(aup.usuarios_matricula AS CHAR)
LEFT JOIN projetos p ON CAST(p.id_projeto AS CHAR) = CAST(aup.id_projeto AS CHAR);

-- View tabela de colaboradores por projeto
CREATE OR REPLACE VIEW vw_indicadores_jornada AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    u.matricula,
    u.nome_completo_usuario AS nome_colaborador,
    aup.horas_planejadas,

    SUM(a.horas_totais_apontamento) AS horas_apontadas,

    SUM(CASE WHEN a.motivo_apontamento = 'Hora Extra' THEN a.horas_totais_apontamento ELSE 0 END) AS horas_extras,
    SUM(CASE WHEN a.motivo_apontamento = 'Retroativo' THEN a.horas_totais_apontamento ELSE 0 END) AS horas_retroativas,

    ROUND((SUM(a.horas_totais_apontamento) / aup.horas_planejadas) * 100, 2) AS indice_cumprimento,
    ROUND((SUM(CASE WHEN a.motivo_apontamento = 'Hora Extra' THEN a.horas_totais_apontamento ELSE 0 END) / aup.horas_planejadas) * 100, 2) AS indice_excedente,
    ROUND((SUM(CASE WHEN a.motivo_apontamento = 'Retroativo' THEN a.horas_totais_apontamento ELSE 0 END) / NULLIF(SUM(a.horas_totais_apontamento), 0)) * 100, 2) AS taxa_erro_apontamento

FROM assoc_usuario_projetos aup
LEFT JOIN usuarios u ON CAST(u.matricula AS CHAR) = CAST(aup.usuarios_matricula AS CHAR)
LEFT JOIN projetos p ON CAST(p.id_projeto AS CHAR) = CAST(aup.id_projeto AS CHAR)
LEFT JOIN apontamentos a ON a.usuarios_matricula = u.matricula AND a.id_projeto = p.id_projeto

GROUP BY 
    p.id_projeto,
    p.nome_projeto,
    u.matricula,
    u.nome_completo_usuario,
    aup.horas_planejadas;

-- View Custo Estimado Laboral
CREATE OR REPLACE VIEW vw_custo_estimado_laboral AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(aup.horas_planejadas * ace.valor_hora) AS custo_estimado_laboral
FROM assoc_usuario_projetos aup
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(aup.id_projeto AS CHAR)
LEFT JOIN assoc_cargo_equipe ace 
    ON ace.usuarios_matricula = aup.usuarios_matricula
GROUP BY p.id_projeto, p.nome_projeto;

-- View Custo Estimado Laboral
CREATE OR REPLACE VIEW vw_custo_estimado_laboral AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(aup.horas_planejadas * ace.valor_hora) AS custo_estimado_laboral
FROM assoc_usuario_projetos aup
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(aup.id_projeto AS CHAR)
LEFT JOIN assoc_cargo_equipe ace 
    ON ace.usuarios_matricula = aup.usuarios_matricula
GROUP BY p.id_projeto, p.nome_projeto;

-- View Custo Real Laboral
CREATE OR REPLACE VIEW vw_custo_real_laboral AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(a.horas_totais_apontamento * ace.valor_hora) AS custo_real_laboral
FROM apontamentos a
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(a.id_projeto AS CHAR)
LEFT JOIN usuarios u 
    ON a.usuarios_matricula = u.matricula
LEFT JOIN assoc_cargo_equipe ace 
    ON ace.usuarios_matricula = u.matricula
GROUP BY p.id_projeto, p.nome_projeto;

SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(a.horas_totais_apontamento)
FROM apontamentos a
LEFT JOIN projetos p 
    ON p.id_projeto = a.id_projeto
LEFT JOIN usuarios u 
    ON a.usuarios_matricula = u.matricula
LEFT JOIN assoc_cargo_equipe ace 
    ON ace.usuarios_matricula = u.matricula
GROUP BY p.id_projeto, p.nome_projeto;

-- View Prazo de entrega
CREATE OR REPLACE VIEW vw_prazo_entrega_projeto AS
SELECT 
    id_projeto,
    nome_projeto,
    data_entrega_projeto AS prazo_entrega
FROM projetos;

-- View Horas Planejadas
CREATE OR REPLACE VIEW vw_horas_planejadas AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(aup.horas_planejadas) AS horas_planejadas
FROM assoc_usuario_projetos aup
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(aup.id_projeto AS CHAR)
GROUP BY p.id_projeto, p.nome_projeto;

-- View Horas Apontadas
CREATE OR REPLACE VIEW vw_horas_apontadas AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(a.horas_totais_apontamento) AS horas_apontadas
FROM apontamentos a
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(a.id_projeto AS CHAR)
GROUP BY p.id_projeto, p.nome_projeto;

-- View Horas Extras Totais
CREATE OR REPLACE VIEW vw_horas_extras_totais AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(a.horas_totais_apontamento) AS horas_extras_totais
FROM apontamentos a
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(a.id_projeto AS CHAR)
WHERE a.motivo_apontamento = 'Hora Extra'
GROUP BY p.id_projeto, p.nome_projeto;

-- View Horas Extras Totais
CREATE OR REPLACE VIEW vw_horas_retroativas AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    SUM(a.horas_totais_apontamento) AS horas_retroativas
FROM apontamentos a
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(a.id_projeto AS CHAR)
WHERE a.motivo_apontamento = 'Retroativo'
GROUP BY p.id_projeto, p.nome_projeto;

-- Tela de Equipe
-- View de Custo por categoria profissional
CREATE OR REPLACE VIEW vw_custos_cargos_equipe AS
SELECT 
    c.id_cargo_usuario,
    c.titulo_cargo_usuario AS categoria,
    ace.valor_hora AS custo_hora_trabalho
FROM cargo_usuario c
LEFT JOIN assoc_cargo_equipe ace 
    ON ace.cargo_usuario_id_cargo_usuario = c.id_cargo_usuario
ORDER BY c.id_cargo_usuario;

-- View de Distribuição de projetos 
CREATE OR REPLACE VIEW vw_resumo_projetos_equipe AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    ROUND(SUM(aup.horas_planejadas * ace.valor_hora), 2) AS custo_estimado_laboral,
    SUM(aup.horas_planejadas) AS horas_planejadas,
    DATE_FORMAT(p.data_entrega_projeto, '%d/%m') AS data_entrega,
    DATE_FORMAT(p.data_inicio_projeto, '%d/%m') AS data_inicio
FROM projetos p
LEFT JOIN assoc_usuario_projetos aup 
    ON CAST(aup.id_projeto AS CHAR) = CAST(p.id_projeto AS CHAR)
LEFT JOIN assoc_cargo_equipe ace 
    ON ace.usuarios_matricula = aup.usuarios_matricula
GROUP BY 
    p.id_projeto,
    p.nome_projeto,
    p.data_entrega_projeto,
    p.data_inicio_projeto
ORDER BY p.id_projeto;

-- ===============================
-- VIEW 1: RELATÓRIO DE PROJETOS
-- ===============================
CREATE OR REPLACE VIEW vw_relatorio_projeto AS
SELECT 
    p.id_projeto AS ticket,
    p.nome_projeto AS nome_projeto,
    (SELECT u.nome_completo_usuario 
     FROM assoc_usuario_projetos aup2 
     JOIN usuarios u ON u.matricula = aup2.usuarios_matricula 
     WHERE aup2.id_projeto = p.id_projeto 
     LIMIT 1) AS gestor_responsavel,
    DATE_FORMAT(p.data_inicio_projeto, '%d/%m/%Y') AS data_inicio,
    DATE_FORMAT(p.data_entrega_projeto, '%d/%m/%Y') AS data_entrega,
    CASE 
        -- Se a data atual for ANTES da data de início: Não iniciado
        WHEN CURDATE() < p.data_inicio_projeto THEN 'Não iniciado'
        -- Se a data atual for DEPOIS da data de entrega: Concluído
        WHEN CURDATE() > p.data_entrega_projeto THEN 'Concluído'
        -- Se a data atual estiver ENTRE a data de início e data de entrega: Em andamento
        WHEN CURDATE() >= p.data_inicio_projeto AND CURDATE() <= p.data_entrega_projeto THEN 'Em andamento'
        -- Caso as datas sejam nulas ou inválidas
        ELSE 'Indefinido'
    END AS status,
    COALESCE(SUM(aup.horas_planejadas), 0) AS horas_planejadas,
    COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 0) AS horas_apontadas_no_mes,
    GREATEST(
        COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 0) - 
        COALESCE(SUM(aup.horas_planejadas), 0),
        0
    ) AS horas_extras,
    COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0) AS custo_estimado_laboral,
    COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento)/3600 * ac.valor_hora), 0) AS custo_real_laboral,
    COALESCE(
        ROUND(
            (COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento)/3600 * ac.valor_hora), 0) - 
             COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0))
            / NULLIF(COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0), 0) * 100
        ,1),
        0
    ) AS diferenca_percentual
FROM projetos p
LEFT JOIN assoc_usuario_projetos aup ON aup.id_projeto = p.id_projeto
LEFT JOIN apontamentos a ON a.id_projeto = p.id_projeto 
    AND a.usuarios_matricula = aup.usuarios_matricula
    -- Remove o filtro de datas do projeto para considerar apontamentos do mês atual independente
    -- AND a.data_apontamento BETWEEN p.data_inicio_projeto AND p.data_entrega_projeto
    AND MONTH(a.data_apontamento) = MONTH(CURDATE())
    AND YEAR(a.data_apontamento) = YEAR(CURDATE())
LEFT JOIN assoc_cargo_equipe ac ON ac.usuarios_matricula = aup.usuarios_matricula
GROUP BY p.id_projeto, p.nome_projeto, p.data_inicio_projeto, p.data_entrega_projeto;


-- ===============================
-- VIEW 2: ALOCAÇÃO DE RECURSOS
-- ===============================
CREATE OR REPLACE VIEW vw_alocacao_recursos AS
SELECT 
    u.nome_completo_usuario AS colaborador,
    cu.titulo_cargo_usuario AS cargo,
    ac.valor_hora AS custo_hora,
    aup.horas_planejadas,
    COALESCE(ROUND(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 1), 0) AS horas_apontadas,
    GREATEST(
        COALESCE(ROUND(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 1), 0) - 
        aup.horas_planejadas,
        0
    ) AS horas_extras,
    COALESCE(
        ROUND(
            COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 0) / 
            NULLIF(aup.horas_planejadas, 0) * 100, 
        1),
        0
    ) AS indice_jornada,
    ROUND(
        aup.horas_planejadas / 
        NULLIF(
            (SELECT SUM(horas_planejadas) 
             FROM assoc_usuario_projetos aup2 
             WHERE aup2.id_projeto = aup.id_projeto), 
        0) * 100, 
    1) AS participacao,
    COALESCE(
        ROUND(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600 * ac.valor_hora, 2), 
        0
    ) AS custo_total,
    aup.id_projeto
FROM assoc_usuario_projetos aup
JOIN usuarios u ON u.matricula = aup.usuarios_matricula
JOIN assoc_cargo_equipe ac ON ac.usuarios_matricula = u.matricula
JOIN cargo_usuario cu ON cu.id_cargo_usuario = ac.cargo_usuario_id_cargo_usuario
LEFT JOIN apontamentos a ON a.id_projeto = aup.id_projeto 
    AND a.usuarios_matricula = u.matricula
    AND MONTH(a.data_apontamento) = MONTH(CURDATE())
    AND YEAR(a.data_apontamento) = YEAR(CURDATE())
GROUP BY u.nome_completo_usuario, cu.titulo_cargo_usuario, ac.valor_hora, 
         aup.horas_planejadas, aup.id_projeto, aup.usuarios_matricula;


-- ===============================
-- VIEW 3: INDICADORES DE EFICIÊNCIA
-- ===============================
CREATE OR REPLACE VIEW vw_indicadores_eficiencia AS
SELECT 
    p.id_projeto,
    COALESCE(
        SUM(
            GREATEST(
                TIME_TO_SEC(a.horas_totais_apontamento)/3600 - aup.horas_planejadas,
                0
            )
        ), 
        0
    ) AS horas_extras_totais,
    COALESCE(
        ROUND(
            (COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento)/3600 * ac.valor_hora), 0) - 
             COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0))
            / NULLIF(COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0), 0) * 100
        ,1),
        0
    ) AS custo_real_vs_estimado_percent,
    COALESCE(
        ROUND(
            COALESCE(SUM(aup.horas_planejadas), 0) / 
            NULLIF(COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento)/3600), 0), 0) * 100, 
        1),
        100
    ) AS taxa_aderencia_planejamento
FROM projetos p
LEFT JOIN assoc_usuario_projetos aup ON aup.id_projeto = p.id_projeto
LEFT JOIN apontamentos a ON a.id_projeto = p.id_projeto 
    AND a.usuarios_matricula = aup.usuarios_matricula
LEFT JOIN assoc_cargo_equipe ac ON ac.usuarios_matricula = aup.usuarios_matricula
GROUP BY p.id_projeto;


-- ===============================
-- VIEW 4: COMPARATIVO MENSAL
-- ===============================
CREATE OR REPLACE VIEW vw_comparativo_mensal AS
SELECT 
    p.id_projeto,
    DATE_FORMAT(CURDATE(), '%M') AS mes,
    COALESCE(SUM(aup.horas_planejadas), 0) AS horas_planejadas,
    COALESCE(ROUND(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 1), 0) AS horas_apontadas,
    GREATEST(
        COALESCE(ROUND(SUM(TIME_TO_SEC(a.horas_totais_apontamento))/3600, 1), 0) - 
        COALESCE(SUM(aup.horas_planejadas), 0),
        0
    ) AS horas_extras,
    COALESCE(ROUND(SUM(aup.horas_planejadas * ac.valor_hora), 2), 0) AS custo_estimado,
    COALESCE(ROUND(SUM(TIME_TO_SEC(a.horas_totais_apontamento)/3600 * ac.valor_hora), 2), 0) AS custo_real,
    COALESCE(
        ROUND(
            (COALESCE(SUM(TIME_TO_SEC(a.horas_totais_apontamento)/3600 * ac.valor_hora), 0) - 
             COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0))
            / NULLIF(COALESCE(SUM(aup.horas_planejadas * ac.valor_hora), 0), 0) * 100
        ,1),
        0
    ) AS desvio_percentual
FROM projetos p
LEFT JOIN assoc_usuario_projetos aup ON aup.id_projeto = p.id_projeto
LEFT JOIN apontamentos a ON a.id_projeto = p.id_projeto 
    AND a.usuarios_matricula = aup.usuarios_matricula
    AND MONTH(a.data_apontamento) = MONTH(CURDATE())
    AND YEAR(a.data_apontamento) = YEAR(CURDATE())
LEFT JOIN assoc_cargo_equipe ac ON ac.usuarios_matricula = aup.usuarios_matricula
GROUP BY p.id_projeto
ORDER BY p.id_projeto;


-- ===============================
-- VIEW 5: OBSERVAÇÕES AUTOMÁTICAS
-- ===============================
CREATE OR REPLACE VIEW vw_observacoes_automaticas AS
SELECT 
    'Custo real > estimado em 10%' AS situacao,
    'O projeto está acima do custo previsto para o mês em questão' AS mensagem
UNION ALL
SELECT 
    'Taxa de erro > 5%',
    'Existem inconsistências nos apontamentos. Avaliar colaboradores com maior índice de erro.'
UNION ALL
SELECT 
    'Aderência < 85%',
    'O cronograma de horas está abaixo do esperado. Risco de atraso detectado.';

CREATE VIEW vw_informacoes_calculo AS
WITH
-- ============================
-- Soma de horas planejadas
-- ============================
cte_planejado AS (
    SELECT
        usuarios_matricula,
        CAST(ROUND(SUM(horas_planejadas), 1) AS DOUBLE) AS total_planejado
    FROM assoc_usuario_projetos
    GROUP BY usuarios_matricula
),

-- ============================
-- Soma de horas apontadas
-- ============================
cte_apontado AS (
    SELECT
        usuarios_matricula,
        CAST(ROUND(SUM(horas_totais_apontamento), 1) AS DOUBLE) AS total_apontado
    FROM apontamentos
    GROUP BY usuarios_matricula
)

SELECT
    u.matricula,
    CAST(ace.valor_hora AS DOUBLE) AS valor_hora_colaborador,
    COALESCE(cp.total_planejado, 0.0) AS horas_planejadas_totais,
    COALESCE(ca.total_apontado, 0.0) AS horas_apontadas_totais

FROM usuarios u
LEFT JOIN assoc_cargo_equipe ace
    ON ace.usuarios_matricula = u.matricula
LEFT JOIN cte_planejado cp
    ON cp.usuarios_matricula = u.matricula
LEFT JOIN cte_apontado ca
    ON ca.usuarios_matricula = u.matricula;