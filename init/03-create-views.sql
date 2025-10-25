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
    
-- [TESTE] View de Distribuição de esforço entre colaboradores por projeto
SELECT * FROM vw_distribuicao_esforco;

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


-- [TESTE] View tabela de colaboradores por projeto
SELECT nome_colaborador, indice_cumprimento, indice_excedente, taxa_erro_apontamento
FROM vw_indicadores_jornada
WHERE id_projeto = 'PROJ01';

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
    SUM(a.horas_totais_apontamento * ace.valor_hora) AS custo_real_laboral
FROM apontamentos a
LEFT JOIN projetos p 
    ON CAST(p.id_projeto AS CHAR) = CAST(a.id_projeto AS CHAR)
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

-- [TESTE] View Custo Estimado e Real Laboral + Prazo de entrega
SELECT 
    e.id_projeto,
    e.nome_projeto,
    e.custo_estimado_laboral,
    r.custo_real_laboral,
    p.prazo_entrega
FROM vw_custo_estimado_laboral e
LEFT JOIN vw_custo_real_laboral r ON e.id_projeto = r.id_projeto
LEFT JOIN vw_prazo_entrega_projeto p ON e.id_projeto = p.id_projeto;

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

-- [TESTE] View Horas Planejadas
SELECT * FROM vw_horas_planejadas WHERE id_projeto = 'PROJ01';

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

-- [TESTE] View Horas Apontadas
SELECT * FROM vw_horas_apontadas WHERE id_projeto = 'PROJ01';

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

-- [TESTE] View Horas Extras Totais
SELECT * FROM vw_horas_extras_totais WHERE id_projeto = 'PROJ01';

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

-- [TESTE] View Horas Extras Totais
SELECT * FROM vw_horas_retroativas WHERE id_projeto = 'PROJ01';

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

-- [TESTE] View de Custo por categoria profissional
SELECT * FROM vw_custos_cargos_equipe;

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

-- [TESTE] View de Distribuição de projetos 
SELECT * FROM vw_resumo_projetos_equipe;
