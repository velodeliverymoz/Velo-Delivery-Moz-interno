-- =============================================
-- VELO DELIVERY MOZ - Reset e Setup Completo v3
-- =============================================

-- Extensão para hash de senhas
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Apagar tabelas existentes (se houver)
DROP TABLE IF EXISTS actividade CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS taxistas CASCADE;
DROP TABLE IF EXISTS utilizadores CASCADE;

-- =============================================
-- Tabela de utilizadores
-- =============================================
CREATE TABLE utilizadores (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    usuario TEXT UNIQUE NOT NULL,
    -- Senha guardada com hash bcrypt (não em texto simples)
    senha TEXT NOT NULL,
    perfil TEXT DEFAULT 'gestor' CHECK (perfil IN ('admin', 'gestor')),
    criado_em TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- Tabela de taxistas
-- =============================================
CREATE TABLE taxistas (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    telefone TEXT,
    -- NUMERIC(10,2) para suportar valores decimais (ex: 1500.50 MZN)
    receita_diaria NUMERIC(10,2) NOT NULL DEFAULT 300.00,
    data_inicio DATE NOT NULL,
    matricula TEXT UNIQUE,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- Tabela de pagamentos
-- =============================================
CREATE TABLE pagamentos (
    id SERIAL PRIMARY KEY,
    -- Referência por ID (integridade referencial)
    taxista_id INTEGER REFERENCES taxistas(id) ON DELETE CASCADE,
    data DATE NOT NULL,
    -- NUMERIC(10,2) para valores monetários
    valor NUMERIC(10,2) NOT NULL,
    observacao TEXT,
    gestor TEXT,
    criado_em TIMESTAMP DEFAULT NOW(),
    -- Evita pagamento duplicado para o mesmo taxista no mesmo dia
    UNIQUE(taxista_id, data)
);

-- =============================================
-- Tabela de actividade
-- =============================================
CREATE TABLE actividade (
    id SERIAL PRIMARY KEY,
    -- Referência por ID em vez de nome (evita inconsistência)
    taxista_id INTEGER REFERENCES taxistas(id) ON DELETE CASCADE,
    acao TEXT NOT NULL,
    -- NUMERIC(10,2) para valores monetários
    valor NUMERIC(10,2) NOT NULL,
    data DATE NOT NULL,
    gestor TEXT,
    criado_em TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- Dados iniciais - Utilizadores
-- Senhas guardadas com hash bcrypt via pgcrypto
-- =============================================
INSERT INTO utilizadores (nome, usuario, senha, perfil) VALUES
    ('Administrador', 'admin',    crypt('velo2025', gen_salt('bf')), 'admin'),
    ('Gestor Carlos',  'gestor1', crypt('g1234',    gen_salt('bf')), 'gestor'),
    ('Gestora Ana',    'gestor2', crypt('g5678',    gen_salt('bf')), 'gestor');

-- =============================================
-- Dados iniciais - Taxistas
-- =============================================
INSERT INTO taxistas (nome, telefone, receita_diaria, data_inicio, matricula, ativo) VALUES
    ('Manuel Jacinto', '+258 84 111 2222', 300.00, '2024-06-01', 'MAP-1001', TRUE),
    ('Carlos Ferro',   '+258 82 333 4444', 250.00, '2024-09-15', 'MAP-1002', TRUE),
    ('Amina Salimo',   '+258 86 555 6666', 350.00, '2025-01-10', 'MAP-1003', TRUE);

-- =============================================
-- Segurança - Row Level Security
-- NOTA: Em desenvolvimento pode desativar,
-- mas em produção configure políticas RLS!
-- =============================================

-- Opção A: Desenvolvimento (acesso livre)
ALTER TABLE utilizadores DISABLE ROW LEVEL SECURITY;
ALTER TABLE taxistas     DISABLE ROW LEVEL SECURITY;
ALTER TABLE pagamentos   DISABLE ROW LEVEL SECURITY;
ALTER TABLE actividade   DISABLE ROW LEVEL SECURITY;

GRANT ALL ON utilizadores TO anon;
GRANT ALL ON taxistas     TO anon;
GRANT ALL ON pagamentos   TO anon;
GRANT ALL ON actividade   TO anon;

-- Permissões nas sequências (necessário para INSERT)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;

-- =============================================
-- VIEW útil: Actividade com nome do taxista
-- =============================================
CREATE OR REPLACE VIEW v_actividade AS
SELECT
    a.id,
    t.nome AS taxista_nome,
    t.matricula,
    a.acao,
    a.valor,
    a.data,
    a.gestor,
    a.criado_em
FROM actividade a
JOIN taxistas t ON t.id = a.taxista_id;

-- =============================================
-- VIEW útil: Pagamentos com nome do taxista
-- =============================================
CREATE OR REPLACE VIEW v_pagamentos AS
SELECT
    p.id,
    t.nome AS taxista_nome,
    t.matricula,
    p.data,
    p.valor,
    p.observacao,
    p.gestor,
    p.criado_em
FROM pagamentos p
JOIN taxistas t ON t.id = p.taxista_id;

GRANT SELECT ON v_actividade TO anon;
GRANT SELECT ON v_pagamentos TO anon;

-- =============================================
-- FIM DO SETUP
-- =============================================
-- =============================================
-- VELO DELIVERY MOZ - Reset e Setup Completo v3
-- =============================================

-- Extensão para hash de senhas
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Apagar tabelas existentes (se houver)
DROP TABLE IF EXISTS actividade CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS taxistas CASCADE;
DROP TABLE IF EXISTS utilizadores CASCADE;

-- =============================================
-- Tabela de utilizadores
-- =============================================
CREATE TABLE utilizadores (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    usuario TEXT UNIQUE NOT NULL,
    -- Senha guardada com hash bcrypt (não em texto simples)
    senha TEXT NOT NULL,
    perfil TEXT DEFAULT 'gestor' CHECK (perfil IN ('admin', 'gestor')),
    criado_em TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- Tabela de taxistas
-- =============================================
CREATE TABLE taxistas (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    telefone TEXT,
    -- NUMERIC(10,2) para suportar valores decimais (ex: 1500.50 MZN)
    receita_diaria NUMERIC(10,2) NOT NULL DEFAULT 300.00,
    data_inicio DATE NOT NULL,
    matricula TEXT UNIQUE,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- Tabela de pagamentos
-- =============================================
CREATE TABLE pagamentos (
    id SERIAL PRIMARY KEY,
    -- Referência por ID (integridade referencial)
    taxista_id INTEGER REFERENCES taxistas(id) ON DELETE CASCADE,
    data DATE NOT NULL,
    -- NUMERIC(10,2) para valores monetários
    valor NUMERIC(10,2) NOT NULL,
    observacao TEXT,
    gestor TEXT,
    criado_em TIMESTAMP DEFAULT NOW(),
    -- Evita pagamento duplicado para o mesmo taxista no mesmo dia
    UNIQUE(taxista_id, data)
);

-- =============================================
-- Tabela de actividade
-- =============================================
CREATE TABLE actividade (
    id SERIAL PRIMARY KEY,
    -- Referência por ID em vez de nome (evita inconsistência)
    taxista_id INTEGER REFERENCES taxistas(id) ON DELETE CASCADE,
    acao TEXT NOT NULL,
    -- NUMERIC(10,2) para valores monetários
    valor NUMERIC(10,2) NOT NULL,
    data DATE NOT NULL,
    gestor TEXT,
    criado_em TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- Dados iniciais - Utilizadores
-- Senhas guardadas com hash bcrypt via pgcrypto
-- =============================================
INSERT INTO utilizadores (nome, usuario, senha, perfil) VALUES
    ('Administrador', 'admin',    crypt('velo2025', gen_salt('bf')), 'admin'),
    ('Gestor Carlos',  'gestor1', crypt('g1234',    gen_salt('bf')), 'gestor'),
    ('Gestora Ana',    'gestor2', crypt('g5678',    gen_salt('bf')), 'gestor');

-- =============================================
-- Dados iniciais - Taxistas
-- =============================================
INSERT INTO taxistas (nome, telefone, receita_diaria, data_inicio, matricula, ativo) VALUES
    ('Manuel Jacinto', '+258 84 111 2222', 300.00, '2024-06-01', 'MAP-1001', TRUE),
    ('Carlos Ferro',   '+258 82 333 4444', 250.00, '2024-09-15', 'MAP-1002', TRUE),
    ('Amina Salimo',   '+258 86 555 6666', 350.00, '2025-01-10', 'MAP-1003', TRUE);

-- =============================================
-- Segurança - Row Level Security
-- NOTA: Em desenvolvimento pode desativar,
-- mas em produção configure políticas RLS!
-- =============================================

-- Opção A: Desenvolvimento (acesso livre)
ALTER TABLE utilizadores DISABLE ROW LEVEL SECURITY;
ALTER TABLE taxistas     DISABLE ROW LEVEL SECURITY;
ALTER TABLE pagamentos   DISABLE ROW LEVEL SECURITY;
ALTER TABLE actividade   DISABLE ROW LEVEL SECURITY;

GRANT ALL ON utilizadores TO anon;
GRANT ALL ON taxistas     TO anon;
GRANT ALL ON pagamentos   TO anon;
GRANT ALL ON actividade   TO anon;

-- Permissões nas sequências (necessário para INSERT)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;

-- =============================================
-- VIEW útil: Actividade com nome do taxista
-- =============================================
CREATE OR REPLACE VIEW v_actividade AS
SELECT
    a.id,
    t.nome AS taxista_nome,
    t.matricula,
    a.acao,
    a.valor,
    a.data,
    a.gestor,
    a.criado_em
FROM actividade a
JOIN taxistas t ON t.id = a.taxista_id;

-- =============================================
-- VIEW útil: Pagamentos com nome do taxista
-- =============================================
CREATE OR REPLACE VIEW v_pagamentos AS
SELECT
    p.id,
    t.nome AS taxista_nome,
    t.matricula,
    p.data,
    p.valor,
    p.observacao,
    p.gestor,
    p.criado_em
FROM pagamentos p
JOIN taxistas t ON t.id = p.taxista_id;

GRANT SELECT ON v_actividade TO anon;
GRANT SELECT ON v_pagamentos TO anon;

-- =============================================
-- FIM DO SETUP
-- =============================================
