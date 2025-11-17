USE Timesync;

-- =========================
-- View: vw_usuarios_completos
-- =========================
CREATE OR REPLACE VIEW vw_usuarios_completos AS
SELECT 
    u.matricula,
    u.nome_completo_usuario,
    CAST(AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_usuario,
    CAST(AES_DECRYPT(u.id_microsoft_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as id_microsoft_usuario,
    u.data_criacao_usuario,
    u.data_atualizacao_usuario,
    ed.nome_estado_dado as estado_usuario,
    u.matricula_superior,
    sup.nome_completo_usuario as nome_superior
FROM usuarios u
LEFT JOIN estado_dados ed ON u.id_estado_dado = ed.id_estado_dado
LEFT JOIN usuarios sup ON u.matricula_superior = sup.matricula;

-- =========================
-- View: vw_colaboradores_equipe
-- =========================
CREATE OR REPLACE VIEW vw_colaboradores_equipe AS
SELECT 
    ace.id_assoc_cargo_equipe,
    u.matricula,
    u.nome_completo_usuario,
    CAST(AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_usuario,
    cu.titulo_cargo_usuario,
    CAST(AES_DECRYPT(ace.valor_hora_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as valor_hora,
    e.id_equipe
FROM assoc_cargo_equipe ace
JOIN usuarios u ON ace.usuarios_matricula = u.matricula
JOIN cargo_usuario cu ON ace.cargo_usuario_id_cargo_usuario = cu.id_cargo_usuario
JOIN equipe e ON ace.equipe_id_equipe = e.id_equipe;

-- =========================
-- View: vw_projetos_ativos
-- =========================
CREATE OR REPLACE VIEW vw_projetos_ativos AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    p.data_inicio_projeto,
    p.data_entrega_projeto,
    ed.nome_estado_dado as estado_projeto
FROM projetos p
JOIN estado_dados ed ON p.id_estado_dado = ed.id_estado_dado
WHERE ed.nome_estado_dado = 'Ativo';

-- =========================
-- View: vw_alocacao_projetos
-- =========================
CREATE OR REPLACE VIEW vw_alocacao_projetos AS
SELECT 
    aup.id_assoc_usuarios_projetos,
    u.matricula,
    u.nome_completo_usuario,
    CAST(AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_usuario,
    p.id_projeto,
    p.nome_projeto,
    aup.horas_planejadas,
    aup.data_criacao_associacao,
    aup.data_atualizacao_associacao
FROM assoc_usuario_projetos aup
JOIN usuarios u ON aup.usuarios_matricula = u.matricula
JOIN projetos p ON aup.id_projeto = p.id_projeto;

-- =========================
-- View: vw_apontamentos_detalhados
-- =========================
CREATE OR REPLACE VIEW vw_apontamentos_detalhados AS
SELECT 
    a.id_apontamento,
    a.data_apontamento,
    u.matricula,
    u.nome_completo_usuario,
    CAST(AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_usuario,
    p.id_projeto,
    p.nome_projeto,
    a.ocorrencia_apontamento,
    a.justificativa_apontamento,
    a.hora_inicio_apontamento,
    a.hora_fim_apontamento,
    a.horas_totais_apontamento,
    a.motivo_apontamento,
    ed.nome_estado_dado as estado_apontamento
FROM apontamentos a
JOIN usuarios u ON a.usuarios_matricula = u.matricula
LEFT JOIN projetos p ON a.id_projeto = p.id_projeto
JOIN estado_dados ed ON a.id_estado_dado = ed.id_estado_dado;

-- =========================
-- View: vw_custos_projetos
-- =========================
CREATE OR REPLACE VIEW vw_custos_projetos AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    u.matricula,
    u.nome_completo_usuario,
    CAST(AES_DECRYPT(ace.valor_hora_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as valor_hora,
    aup.horas_planejadas,
    (CAST(AES_DECRYPT(ace.valor_hora_criptografado, 'timesync_chave_criptografia_2025') AS DECIMAL(10,2)) * aup.horas_planejadas) as custo_total_planejado
FROM assoc_usuario_projetos aup
JOIN usuarios u ON aup.usuarios_matricula = u.matricula
JOIN projetos p ON aup.id_projeto = p.id_projeto
JOIN assoc_cargo_equipe ace ON u.matricula = ace.usuarios_matricula;

-- =========================
-- View: vw_horas_trabalhadas
-- =========================
CREATE OR REPLACE VIEW vw_horas_trabalhadas AS
SELECT 
    u.matricula,
    u.nome_completo_usuario,
    CAST(AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_usuario,
    p.id_projeto,
    p.nome_projeto,
    SUM(a.horas_totais_apontamento) as total_horas_trabalhadas,
    COUNT(a.id_apontamento) as total_apontamentos
FROM apontamentos a
JOIN usuarios u ON a.usuarios_matricula = u.matricula
LEFT JOIN projetos p ON a.id_projeto = p.id_projeto
GROUP BY u.matricula, u.nome_completo_usuario, p.id_projeto, p.nome_projeto;

-- =========================
-- View: vw_equipe_hierarquia
-- =========================
CREATE OR REPLACE VIEW vw_equipe_hierarquia AS
SELECT 
    sup.matricula as matricula_superior,
    sup.nome_completo_usuario as nome_superior,
    CAST(AES_DECRYPT(sup.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_superior,
    u.matricula as matricula_subordinado,
    u.nome_completo_usuario as nome_subordinado,
    CAST(AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_subordinado,
    cu.titulo_cargo_usuario,
    CAST(AES_DECRYPT(ace.valor_hora_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as valor_hora
FROM usuarios u
JOIN usuarios sup ON u.matricula_superior = sup.matricula
JOIN assoc_cargo_equipe ace ON u.matricula = ace.usuarios_matricula
JOIN cargo_usuario cu ON ace.cargo_usuario_id_cargo_usuario = cu.id_cargo_usuario
WHERE u.id_estado_dado = (SELECT id_estado_dado FROM estado_dados WHERE nome_estado_dado = 'Ativo');

-- =========================
-- View: vw_resumo_projeto
-- =========================
CREATE OR REPLACE VIEW vw_resumo_projeto AS
SELECT 
    p.id_projeto,
    p.nome_projeto,
    p.data_inicio_projeto,
    p.data_entrega_projeto,
    COUNT(DISTINCT aup.usuarios_matricula) as total_colaboradores,
    SUM(aup.horas_planejadas) as total_horas_planejadas,
    SUM(a.horas_totais_apontamento) as total_horas_executadas,
    ed.nome_estado_dado as estado_projeto
FROM projetos p
LEFT JOIN assoc_usuario_projetos aup ON p.id_projeto = aup.id_projeto
LEFT JOIN apontamentos a ON p.id_projeto = a.id_projeto
JOIN estado_dados ed ON p.id_estado_dado = ed.id_estado_dado
GROUP BY p.id_projeto, p.nome_projeto, p.data_inicio_projeto, p.data_entrega_projeto, ed.nome_estado_dado;

-- =========================
-- View: vw_dados_criptografia_teste
-- =========================
CREATE OR REPLACE VIEW vw_dados_criptografia_teste AS
SELECT 
    'usuarios' as tabela,
    matricula,
    nome_completo_usuario,
    CAST(AES_DECRYPT(email_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as email_decrypt,
    CAST(AES_DECRYPT(id_microsoft_usuario_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as id_microsoft_decrypt
FROM usuarios
UNION ALL
SELECT 
    'assoc_cargo_equipe' as tabela,
    usuarios_matricula as matricula,
    '' as nome_completo_usuario,
    '' as email_decrypt,
    CAST(AES_DECRYPT(valor_hora_criptografado, 'timesync_chave_criptografia_2025') AS CHAR) as id_microsoft_decrypt
FROM assoc_cargo_equipe;

-- =========================
-- View: vw_verificacao_criptografia
-- =========================
CREATE OR REPLACE VIEW vw_verificacao_criptografia AS
SELECT 
    u.matricula,
    u.nome_completo_usuario,
    -- Verifica se a descriptografia funciona
    CASE 
        WHEN AES_DECRYPT(u.email_usuario_criptografado, 'timesync_chave_criptografia_2025') IS NOT NULL 
        THEN 'OK' 
        ELSE 'ERRO' 
    END as status_email,
    CASE 
        WHEN AES_DECRYPT(u.id_microsoft_usuario_criptografado, 'timesync_chave_criptografia_2025') IS NOT NULL 
        THEN 'OK' 
        ELSE 'ERRO' 
    END as status_microsoft,
    CASE 
        WHEN AES_DECRYPT(ace.valor_hora_criptografado, 'timesync_chave_criptografia_2025') IS NOT NULL 
        THEN 'OK' 
        ELSE 'ERRO' 
    END as status_valor_hora
FROM usuarios u
LEFT JOIN assoc_cargo_equipe ace ON u.matricula = ace.usuarios_matricula;