-- ============================================================
-- PULSAR RH — SCHEMA SUPABASE
-- Execute no SQL Editor: https://supabase.com/dashboard → SQL Editor
-- ============================================================

-- ── TABELAS ─────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS clients (
  id           TEXT PRIMARY KEY,
  name         TEXT NOT NULL,
  email        TEXT NOT NULL,
  cnpj         TEXT,
  segment      TEXT,
  headcount    INTEGER DEFAULT 0,
  contact_name TEXT,
  plan         TEXT DEFAULT 'completo',
  status       TEXT DEFAULT 'ativo',
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS surveys (
  id            TEXT PRIMARY KEY,
  client_id     TEXT REFERENCES clients(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  type          TEXT,
  period        TEXT,
  status        TEXT DEFAULT 'ativa',
  total_invited INTEGER DEFAULT 0,
  public_token  TEXT,
  deadline      TEXT,
  description   TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_survey_token ON surveys(public_token);

CREATE TABLE IF NOT EXISTS survey_questions (
  id         TEXT PRIMARY KEY,
  survey_id  TEXT REFERENCES surveys(id) ON DELETE CASCADE,
  client_id  TEXT,
  text       TEXT,
  type       TEXT,
  dimension  TEXT,
  order_num  INTEGER DEFAULT 0,
  is_custom  BOOLEAN DEFAULT false,
  weight     DECIMAL DEFAULT 1.0
);

CREATE TABLE IF NOT EXISTS collaborators (
  id             TEXT PRIMARY KEY,
  client_id      TEXT REFERENCES clients(id) ON DELETE CASCADE,
  name           TEXT,
  email          TEXT,
  role           TEXT,
  department     TEXT,
  regime         TEXT,
  salary         NUMERIC,
  admission_date TEXT,
  status         TEXT DEFAULT 'ativo'
);

CREATE TABLE IF NOT EXISTS responses (
  id               TEXT PRIMARY KEY,
  survey_id        TEXT,
  client_id        TEXT REFERENCES clients(id) ON DELETE CASCADE,
  respondent_name  TEXT,
  respondent_dept  TEXT,
  respondent_tenure TEXT,
  overall_score    NUMERIC,
  completed_at     TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_response_survey ON responses(survey_id);

CREATE TABLE IF NOT EXISTS answers (
  id             TEXT PRIMARY KEY,
  response_id    TEXT,
  survey_id      TEXT,
  client_id      TEXT REFERENCES clients(id) ON DELETE CASCADE,
  question_id    TEXT,
  dimension      TEXT,
  question_type  TEXT,
  numeric_value  NUMERIC,
  text_value     TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_answer_survey    ON answers(survey_id);
CREATE INDEX IF NOT EXISTS idx_answer_client    ON answers(client_id);
CREATE INDEX IF NOT EXISTS idx_answer_dimension ON answers(dimension);

CREATE TABLE IF NOT EXISTS actions (
  id          TEXT PRIMARY KEY,
  client_id   TEXT REFERENCES clients(id) ON DELETE CASCADE,
  survey_id   TEXT,
  title       TEXT,
  area        TEXT,
  priority    TEXT DEFAULT 'media',
  responsible TEXT,
  deadline    TEXT,
  status      TEXT DEFAULT 'pendente',
  description TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS indicators (
  id                TEXT PRIMARY KEY,
  client_id         TEXT REFERENCES clients(id) ON DELETE CASCADE,
  month             TEXT,
  headcount         INTEGER,
  working_days      INTEGER,
  absenteeism_days  INTEGER DEFAULT 0,
  turnover_exits    INTEGER DEFAULT 0,
  admissions        INTEGER DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_indicator_month ON indicators(client_id, month);

CREATE TABLE IF NOT EXISTS nr1risks (
  id          TEXT PRIMARY KEY,
  client_id   TEXT REFERENCES clients(id) ON DELETE CASCADE,
  area        TEXT,
  factor      TEXT,
  probability INTEGER,
  severity    INTEGER,
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── RLS ──────────────────────────────────────────────────────

ALTER TABLE clients        ENABLE ROW LEVEL SECURITY;
ALTER TABLE surveys        ENABLE ROW LEVEL SECURITY;
ALTER TABLE survey_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE collaborators  ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses      ENABLE ROW LEVEL SECURITY;
ALTER TABLE answers        ENABLE ROW LEVEL SECURITY;
ALTER TABLE actions        ENABLE ROW LEVEL SECURITY;
ALTER TABLE indicators     ENABLE ROW LEVEL SECURITY;
ALTER TABLE nr1risks       ENABLE ROW LEVEL SECURITY;

-- ADMIN — acesso total a tudo
CREATE POLICY "admin_clients"     ON clients         FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_surveys"     ON surveys         FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_sq"          ON survey_questions FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_collabs"     ON collaborators   FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_responses"   ON responses       FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_answers"     ON answers         FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_actions"     ON actions         FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_indicators"  ON indicators      FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');
CREATE POLICY "admin_nr1"         ON nr1risks        FOR ALL USING ((auth.jwt()->>'email')='suporte@agconsultorialtda.com') WITH CHECK ((auth.jwt()->>'email')='suporte@agconsultorialtda.com');

-- CLIENTES — lêem apenas os próprios dados (identificados pelo email)
CREATE POLICY "client_own_row"    ON clients         FOR SELECT USING (lower(email)=lower(auth.jwt()->>'email'));
CREATE POLICY "client_surveys"    ON surveys         FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_sq"         ON survey_questions FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_collabs"    ON collaborators   FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_responses"  ON responses       FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_answers"    ON answers         FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_actions"    ON actions         FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_indicators" ON indicators      FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));
CREATE POLICY "client_nr1"        ON nr1risks        FOR SELECT USING (client_id IN (SELECT id FROM clients WHERE lower(email)=lower(auth.jwt()->>'email')));

-- ANÔNIMO (respondentes de pesquisa) — lê survey+perguntas por token, grava respostas
CREATE POLICY "anon_survey_token" ON surveys         FOR SELECT TO anon USING (true);
CREATE POLICY "anon_sq_read"      ON survey_questions FOR SELECT TO anon USING (true);
CREATE POLICY "anon_resp_insert"  ON responses       FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_ans_insert"   ON answers         FOR INSERT TO anon WITH CHECK (true);
-- Atualiza total_invited ao gravar resposta
CREATE POLICY "anon_survey_upd"   ON surveys         FOR UPDATE TO anon USING (true) WITH CHECK (true);
