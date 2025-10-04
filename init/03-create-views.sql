-- init/03-create-views.sql
USE Timesync;

-- View de Exemplo
CREATE OR REPLACE VIEW nome_funcionario__nome_superior AS
SELECT 
    u.nome_completo_usuario AS nome_funcionario,
    s.nome_completo_usuario AS nome_superior
FROM usuarios u
LEFT JOIN usuarios s ON s.matricula = u.matricula_superior;