# AG People Analytics v2 — Setup & Deploy

## Estrutura de arquivos

```
ag-rh/
├── index.html        # Login (admin + cliente)
├── app.html          # Aplicação principal
├── responder.html    # Formulário público de pesquisa
├── config.js         # Configurações centrais
├── schema.sql        # Schema do banco de dados
├── .gitignore
├── README.md
└── SETUP.md          # Este arquivo
```

---

## 1. Criar projeto no Supabase

1. Acesse https://supabase.com e faça login
2. Clique em **New Project**
3. Nome: `ag-rh-analytics`, região: `South America (São Paulo)`, senha forte
4. Aguarde inicializar (~2 min)

---

## 2. Criar o schema do banco

1. Supabase → **SQL Editor**
2. Cole todo o conteúdo de `schema.sql`
3. Clique em **Run** (F5)
4. Confirme as tabelas em **Table Editor**

---

## 3. Configurar credenciais em `config.js`

1. Supabase → **Settings → API**
2. Copie **Project URL** e **anon public key**
3. Edite `config.js`:

```js
const SUPABASE_URL  = 'https://SEU_PROJECT_ID.supabase.co';
const SUPABASE_ANON = 'sua-chave-anon-aqui';
```

4. `OFFLINE_MODE` mudará automaticamente para `false`

---

## 4. Configurar RLS (Row Level Security)

Execute no SQL Editor para o MVP:

```sql
-- Leitura anônima para pesquisas públicas
CREATE POLICY "anon_read_clients"    ON clients    FOR SELECT USING (true);
CREATE POLICY "anon_insert_response" ON survey_responses FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_insert_answer"   ON question_answers  FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_read_surveys"    ON surveys    FOR SELECT USING (true);
CREATE POLICY "anon_read_questions"  ON survey_questions FOR SELECT USING (true);
```

> Em produção, substitua por políticas baseadas em `auth.uid()` do Supabase Auth.

---

## 5. Publicar

### Opção A — Vercel (recomendado)
1. Faça `git push` do repositório
2. Acesse https://vercel.com → **Import**
3. Selecione o repositório → **Deploy**
4. URL automática: `https://ag-rh.vercel.app`
5. Adicione domínio: `rh.agconsultorialtda.com`

### Opção B — GitHub Pages (gratuito)
1. Repositório no GitHub → **Settings → Pages**
2. Branch: `main`, pasta: `/`
3. URL: `https://seuuser.github.io/ag-rh/`

### Opção C — cPanel / Hospedagem
1. Gerenciador de arquivos → `public_html/rh/`
2. Upload dos 6 arquivos
3. URL: `https://agconsultorialtda.com/rh/`

---

## 6. Configurar domínio customizado

No provedor de DNS (Registro.br, Cloudflare):

```
Tipo:  CNAME
Nome:  rh
Valor: cname.vercel-dns.com
TTL:   3600
```

Resultado: `https://rh.agconsultorialtda.com`

---

## 7. Configurar API Claude (Insights IA e Agente)

A chave Claude é configurada diretamente no painel — não vai em código:

1. Acesse https://console.anthropic.com → **API Keys**
2. Crie uma chave `sk-ant-...`
3. No sistema: **menu Agente IA → ⚙️ Config. API** → cole a chave
4. A chave fica salva no localStorage do navegador admin

> Para produção com múltiplos admins, crie um endpoint proxy seguro no backend.

---

## 8. Alterar senha do admin

Edite `index.html` linha 71:
```js
const ADMIN_EMAIL    = 'seu@email.com';
const ADMIN_PASS     = 'sua-senha-segura';
```

E `config.js`:
```js
const ADMIN_EMAIL    = 'seu@email.com';
const ADMIN_PASSWORD = 'sua-senha-segura';
```

---

## Credenciais padrão (demo / offline)

| Tipo    | E-mail                   | Senha  |
|---------|--------------------------|--------|
| Admin   | admin@agconsultoria.com  | 123456 |
| Cliente | rh@tech.com              | rh123  |
| Cliente | rh@varejo.com            | rh456  |
| Cliente | rh@saude.com             | rh789  |

---

## Links de pesquisa (demo)

| Empresa         | Token          | URL                               |
|----------------|----------------|----------------------------------|
| Tech Solutions  | tok-cli1-clim  | `responder.html?token=tok-cli1-clim` |
| Varejo Nordeste | tok-cli2-eng   | `responder.html?token=tok-cli2-eng`  |
| Clínica Saúde   | tok-cli3-nr1   | `responder.html?token=tok-cli3-nr1`  |

---

## Notas importantes para produção

1. **Autenticação:** O sistema usa `sessionStorage` (MVP). Para produção real, migre para Supabase Auth
2. **Senhas:** Atualmente em plain text no localStorage. Em produção, use hash (bcrypt) e Supabase Auth
3. **Claude API:** Chamadas diretas do browser expõem a key no frontend — use proxy backend em produção multi-usuário
4. **Tabelas faltantes no schema:** `indicators` (absenteísmo/turnover) e `nr1_risks` são gerenciadas via localStorage no MVP. Adicione ao schema conforme necessidade de produção
5. **CORS:** A API da Anthropic aceita chamadas diretas do browser com o header `anthropic-dangerous-direct-browser-access: true`

---

## Suporte

📧 suporte@agconsultorialtda.com  
🌐 agconsultorialtda.com  
📲 (55) 9 8615-7028
