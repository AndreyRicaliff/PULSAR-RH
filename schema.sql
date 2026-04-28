-- ============================================================
-- AG PEOPLE ANALYTICS — SCHEMA SUPABASE
-- Execute no SQL Editor do Supabase
-- ============================================================

-- Extensões
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ────────────────────────────────────────────────────────────
-- CLIENTES (empresas)
-- ────────────────────────────────────────────────────────────
CREATE TABLE clients (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        TEXT NOT NULL,
  cnpj        TEXT,
  segment     TEXT,
  headcount   INTEGER DEFAULT 0,
  contact_name TEXT,
  contact_phone TEXT,
  email       TEXT UNIQUE NOT NULL,
  password    TEXT NOT NULL,       -- hash ou plain (MVP)
  plan        TEXT DEFAULT 'basico',
  status      TEXT DEFAULT 'ativo',
  logo_url    TEXT,
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────────────────────
-- COLABORADORES
-- ────────────────────────────────────────────────────────────
CREATE TABLE collaborators (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id     UUID REFERENCES clients(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  cpf           TEXT,
  email         TEXT,
  phone         TEXT,
  role          TEXT,
  department    TEXT,
  manager       TEXT,
  regime        TEXT,
  salary        DECIMAL(12,2),
  level         TEXT,
  admission_date DATE,
  status        TEXT DEFAULT 'ativo',
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_collab_client ON collaborators(client_id);

-- ────────────────────────────────────────────────────────────
-- PESQUISAS
-- ────────────────────────────────────────────────────────────
CREATE TABLE surveys (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id     UUID REFERENCES clients(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  type          TEXT NOT NULL,   -- clima|engajamento|360|180|lideranca|felicidade|nr1|onboarding|desligamento|saude
  period        TEXT,            -- pontual|mensal|trimestral|semestral|anual
  description   TEXT,
  deadline      DATE,
  status        TEXT DEFAULT 'ativa',  -- ativa|concluida|pausada
  total_invited INTEGER DEFAULT 0,
  public_token  TEXT UNIQUE DEFAULT encode(gen_random_bytes(12), 'hex'),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_survey_client ON surveys(client_id);
CREATE INDEX idx_survey_token  ON surveys(public_token);

-- ────────────────────────────────────────────────────────────
-- PERGUNTAS (padrão + customizadas)
-- ────────────────────────────────────────────────────────────
CREATE TABLE survey_questions (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  survey_id     UUID REFERENCES surveys(id) ON DELETE CASCADE,
  text          TEXT NOT NULL,
  type          TEXT NOT NULL,   -- likert|nps|discursiva|escolha
  options       JSONB,           -- array de strings para 'escolha'
  dimension     TEXT,            -- dimensão a que pertence (para gráficos)
  order_num     INTEGER DEFAULT 0,
  is_custom     BOOLEAN DEFAULT false,
  weight        DECIMAL DEFAULT 1.0,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_question_survey ON survey_questions(survey_id);

-- ────────────────────────────────────────────────────────────
-- RESPOSTAS (uma por sessão/colaborador)
-- ────────────────────────────────────────────────────────────
CREATE TABLE survey_responses (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  survey_id         UUID REFERENCES surveys(id) ON DELETE CASCADE,
  client_id         UUID REFERENCES clients(id),
  respondent_name   TEXT DEFAULT 'Anônimo',
  respondent_email  TEXT,
  respondent_role   TEXT,
  respondent_dept   TEXT,
  respondent_tenure TEXT,
  overall_score     DECIMAL(4,2),
  completed_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_response_survey ON survey_responses(survey_id);
CREATE INDEX idx_response_client ON survey_responses(client_id);

-- ────────────────────────────────────────────────────────────
-- RESPOSTAS POR PERGUNTA (big data)
-- ────────────────────────────────────────────────────────────
CREATE TABLE question_answers (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  response_id   UUID REFERENCES survey_responses(id) ON DELETE CASCADE,
  survey_id     UUID REFERENCES surveys(id),
  client_id     UUID REFERENCES clients(id),
  question_id   UUID REFERENCES survey_questions(id),
  dimension     TEXT,
  question_type TEXT,
  numeric_value DECIMAL(5,2),
  text_value    TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_answer_response  ON question_answers(response_id);
CREATE INDEX idx_answer_survey    ON question_answers(survey_id);
CREATE INDEX idx_answer_client    ON question_answers(client_id);
CREATE INDEX idx_answer_dimension ON question_answers(dimension);

-- ────────────────────────────────────────────────────────────
-- PLANOS DE AÇÃO
-- ────────────────────────────────────────────────────────────
CREATE TABLE action_plans (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id        UUID REFERENCES clients(id) ON DELETE CASCADE,
  survey_id        UUID REFERENCES surveys(id),
  title            TEXT NOT NULL,
  description      TEXT,
  area             TEXT,
  priority         TEXT DEFAULT 'media',
  responsible      TEXT,
  deadline         DATE,
  status           TEXT DEFAULT 'pendente',
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_action_client ON action_plans(client_id);

-- ────────────────────────────────────────────────────────────
-- VIEWS ANALÍTICAS (Big Data por empresa)
-- ────────────────────────────────────────────────────────────

-- Score médio por dimensão e empresa
CREATE OR REPLACE VIEW vw_dimension_scores AS
SELECT
  qa.client_id,
  qa.survey_id,
  s.type  AS survey_type,
  qa.dimension,
  ROUND(AVG(qa.numeric_value), 2) AS avg_score,
  COUNT(*)                        AS total_answers,
  MIN(qa.created_at)              AS first_at,
  MAX(qa.created_at)              AS last_at
FROM question_answers qa
JOIN surveys s ON s.id = qa.survey_id
WHERE qa.numeric_value IS NOT NULL
GROUP BY qa.client_id, qa.survey_id, s.type, qa.dimension;

-- eNPS por empresa
CREATE OR REPLACE VIEW vw_enps AS
SELECT
  client_id,
  survey_id,
  COUNT(*) FILTER (WHERE numeric_value >= 9) AS promoters,
  COUNT(*) FILTER (WHERE numeric_value BETWEEN 7 AND 8) AS passives,
  COUNT(*) FILTER (WHERE numeric_value <= 6) AS detractors,
  COUNT(*) AS total,
  ROUND(
    (COUNT(*) FILTER (WHERE numeric_value >= 9)::DECIMAL / NULLIF(COUNT(*),0) -
     COUNT(*) FILTER (WHERE numeric_value <= 6)::DECIMAL / NULLIF(COUNT(*),0)) * 100
  , 0) AS enps_score
FROM question_answers
WHERE dimension = 'nps' AND numeric_value IS NOT NULL
GROUP BY client_id, survey_id;

-- Tendência mensal por empresa
CREATE OR REPLACE VIEW vw_monthly_trend AS
SELECT
  client_id,
  DATE_TRUNC('month', completed_at) AS month,
  COUNT(*)                           AS responses,
  ROUND(AVG(overall_score), 2)       AS avg_score
FROM survey_responses
GROUP BY client_id, DATE_TRUNC('month', completed_at)
ORDER BY client_id, month;

-- ────────────────────────────────────────────────────────────
-- INDICADORES DE RH (absenteísmo, turnover)
-- ────────────────────────────────────────────────────────────
CREATE TABLE indicators (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id         UUID REFERENCES clients(id) ON DELETE CASCADE,
  month             TEXT NOT NULL,          -- formato YYYY-MM
  headcount         INTEGER NOT NULL,
  working_days      INTEGER NOT NULL,
  absenteeism_days  INTEGER DEFAULT 0,
  turnover_exits    INTEGER DEFAULT 0,
  admissions        INTEGER DEFAULT 0,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_indicator_client ON indicators(client_id);
CREATE INDEX idx_indicator_month  ON indicators(client_id, month);

-- ────────────────────────────────────────────────────────────
-- RISCOS PSICOSSOCIAIS NR-1
-- ────────────────────────────────────────────────────────────
CREATE TABLE nr1_risks (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id   UUID REFERENCES clients(id) ON DELETE CASCADE,
  area        TEXT NOT NULL,           -- área NR-1 Anexo III
  factor      TEXT NOT NULL,           -- fator de risco identificado
  probability INTEGER NOT NULL CHECK (probability BETWEEN 1 AND 5),
  severity    INTEGER NOT NULL CHECK (severity BETWEEN 1 AND 5),
  score       INTEGER GENERATED ALWAYS AS (probability * severity) STORED,
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_nr1risk_client ON nr1_risks(client_id);

-- View de riscos críticos
CREATE OR REPLACE VIEW vw_critical_risks AS
SELECT
  r.*,
  c.name AS client_name,
  CASE
    WHEN r.probability * r.severity >= 17 THEN 'critico'
    WHEN r.probability * r.severity >= 10 THEN 'alto'
    WHEN r.probability * r.severity >= 5  THEN 'medio'
    ELSE 'baixo'
  END AS risk_level
FROM nr1_risks r
JOIN clients c ON c.id = r.client_id
ORDER BY r.probability * r.severity DESC;

-- ────────────────────────────────────────────────────────────
-- RLS (Row Level Security) — cada cliente vê só os seus dados
-- ────────────────────────────────────────────────────────────
ALTER TABLE collaborators    ENABLE ROW LEVEL SECURITY;
ALTER TABLE surveys          ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE question_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE action_plans     ENABLE ROW LEVEL SECURITY;
ALTER TABLE indicators       ENABLE ROW LEVEL SECURITY;
ALTER TABLE nr1_risks        ENABLE ROW LEVEL SECURITY;

-- Admin (service_role) vê tudo — policies de leitura abertas para anon (MVP)
-- Em produção, use Supabase Auth e vincule auth.uid() ao client_id

-- ────────────────────────────────────────────────────────────
-- DADOS INICIAIS (seed)
-- ────────────────────────────────────────────────────────────
INSERT INTO clients (name, cnpj, segment, headcount, contact_name, email, password, plan)
VALUES
  ('Tech Solutions Ltda',  '12.345.678/0001-99', 'Tecnologia', 85,  'Ana Silva',  'rh@tech.com',    'rh123', 'completo'),
  ('Varejo Nordeste S/A',  '98.765.432/0001-11', 'Varejo',     220, 'Carlos Melo','rh@varejo.com',  'rh456', 'intermediario'),
  ('Clínica Saúde Total',  '55.555.555/0001-55', 'Saúde',      42,  'Dra. Paula', 'rh@saude.com',   'rh789', 'basico');
