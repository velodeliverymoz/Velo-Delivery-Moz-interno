-- =============================================
-- VELO DELIVERY MOZ - Reset e Setup Completo
-- =============================================

-- Apagar tabelas existentes (se houver)
DROP TABLE IF EXISTS actividade CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS taxistas CASCADE;
DROP TABLE IF EXISTS utilizadores CASCADE;

-- Tabela de utilizadores
CREATE TABLE utilizadores (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  usuario TEXT UNIQUE NOT NULL,
  senha TEXT NOT NULL,
  perfil TEXT DEFAULT 'gestor',
  criado_em TIMESTAMP DEFAULT NOW()
);

-- Tabela de taxistas
CREATE TABLE taxistas (
  id SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  telefone TEXT,
  receita_diaria INTEGER NOT NULL DEFAULT 300,
  data_inicio DATE NOT NULL,
  matricula TEXT,
  ativo BOOLEAN DEFAULT TRUE,
  criado_em TIMESTAMP DEFAULT NOW()
);

-- Tabela de pagamentos
CREATE TABLE pagamentos (
  id SERIAL PRIMARY KEY,
  taxista_id INTEGER REFERENCES taxistas(id) ON DELETE CASCADE,
  data DATE NOT NULL,
  valor INTEGER NOT NULL,
  observacao TEXT,
  gestor TEXT,
  criado_em TIMESTAMP DEFAULT NOW(),
  UNIQUE(taxista_id, data)
);

-- Tabela de actividade
CREATE TABLE actividade (
  id SERIAL PRIMARY KEY,
  taxista_nome TEXT NOT NULL,
  acao TEXT NOT NULL,
  valor INTEGER NOT NULL,
  data DATE NOT NULL,
  gestor TEXT,
  criado_em TIMESTAMP DEFAULT NOW()
);

-- Dados iniciais
INSERT INTO utilizadores (nome, usuario, senha, perfil) VALUES
  ('Administrador', 'admin', 'velo2025', 'admin'),
  ('Gestor Carlos', 'gestor1', 'g1234', 'gestor'),
  ('Gestora Ana', 'gestor2', 'g5678', 'gestor');

INSERT INTO taxistas (nome, telefone, receita_diaria, data_inicio, matricula, ativo) VALUES
  ('Manuel Jacinto', '+258 84 111 2222', 300, '2024-06-01', 'MAP-1001', TRUE),
  ('Carlos Ferro', '+258 82 333 4444', 250, '2024-09-15', 'MAP-1002', TRUE),
  ('Amina Salimo', '+258 86 555 6666', 350, '2025-01-10', 'MAP-1003', TRUE);

-- Permissões
ALTER TABLE utilizadores DISABLE ROW LEVEL SECURITY;
ALTER TABLE taxistas DISABLE ROW LEVEL SECURITY;
ALTER TABLE pagamentos DISABLE ROW LEVEL SECURITY;
ALTER TABLE actividade DISABLE ROW LEVEL SECURITY;

GRANT ALL ON utilizadores TO anon;
GRANT ALL ON taxistas TO anon;
GRANT ALL ON pagamentos TO anon;
GRANT ALL ON actividade TO anon;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;
