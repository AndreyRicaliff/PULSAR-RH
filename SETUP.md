# PULSAR RH — Guia de Setup e Deploy

---

## 1. Supabase — Criar Projeto

1. Acesse https://supabase.com → **New Project**
2. Nome: `pulsar-rh`, região: **South America (São Paulo)**
3. Aguarde inicializar (~2 min)

---

## 2. Criar Schema e RLS

1. Supabase → **SQL Editor**
2. Cole o conteúdo de **`supabase-schema.sql`** (não use `schema.sql` — obsoleto)
3. Clique em **Run** (F5)
4. Confirme as 9 tabelas em **Table Editor**

---

## 3. Configurar Credenciais

1. Supabase → **Settings → API**
2. Copie **Project URL** e **anon public key**
3. Edite `config.js`:

```js
const SUPABASE_URL  = 'https://SEU_PROJECT_ID.supabase.co';
const SUPABASE_ANON = 'sua-chave-anon-aqui';
const ADMIN_EMAIL   = 'seu@email.com';
```

`OFFLINE_MODE` muda automaticamente para `false` quando a URL não contém `SEU_PROJECT`.

---

## 4. Criar Usuário Admin no Supabase Auth

1. Supabase → **Authentication → Users → Add User**
2. E-mail: mesmo valor de `ADMIN_EMAIL` em `config.js`
3. Senha forte → **Create User**

---

## 5. Configurar Template de E-mail (Magic Link)

1. Supabase → **Authentication → Email Templates → Magic Link**
2. Cole o conteúdo de `email-template-magic-link.html` no campo **Body**
3. Subject: `Seu acesso ao PULSAR RH`
4. **Save**

---

## 6. Deploy no Vercel

1. `git push` para o repositório
2. https://vercel.com → **Import** → selecione o repositório
3. **Deploy** (zero configuração — `vercel.json` já está configurado)
4. Domínio customizado → **Settings → Domains** → `rh.agconsultorialtda.com`

No DNS (Cloudflare / Registro.br):
```
Tipo:  CNAME
Nome:  rh
Valor: cname.vercel-dns.com
TTL:   3600
```

---

## 7. Configurar API Claude (IA)

A chave Claude **não vai em código** — configure direto no painel:

1. https://console.anthropic.com → **API Keys → Create Key**
2. No PULSAR RH: menu **Agente IA → ⚙️ Config. API** → cole `sk-ant-...`

---

## 8. Enviar Acesso ao Primeiro Cliente

1. Crie o cliente em **Clientes → + Novo Cliente** (marque "Enviar convite")
2. O cliente recebe um magic link por e-mail → clica → cai em `/client`
3. No portal do cliente: visão read-only dos dados cadastrados pelo admin

---

## Fluxo Completo

```
Admin cria cliente → Admin cria pesquisa → Copia link público →
Envia link para colaboradores → Colaboradores respondem (/responder?token=...) →
Respostas gravadas no Supabase → Admin vê resultados em /app →
Cliente vê resultados read-only em /client →
Admin cria planos de ação → Cliente acompanha kanban em /client
```

---

## URLs do Sistema

| URL | Quem acessa |
|-----|-------------|
| `/` | Tela de login |
| `/app` | Admin (AG Consultoria) — redireciona cliente para /client |
| `/client` | Portal do cliente — redireciona admin para /app |
| `/responder?token=TOKEN` | Colaboradores (anônimo) |

---

## Variáveis em `config.js`

| Variável | Descrição |
|----------|-----------|
| `SUPABASE_URL` | URL do projeto Supabase |
| `SUPABASE_ANON` | Chave anon pública (segura para expor no frontend + RLS) |
| `OFFLINE_MODE` | Auto: `true` se URL contém `SEU_PROJECT` |
| `ADMIN_EMAIL` | E-mail do admin — identifica papel após login |
| `DEMO_ADMIN_EMAIL` | Credencial apenas para modo offline (demo) |
| `DEMO_ADMIN_PASSWORD` | Senha apenas para modo offline (demo) |

---

## Suporte

📧 suporte@agconsultorialtda.com
🌐 agconsultorialtda.com
📲 (55) 9 8615-7028
