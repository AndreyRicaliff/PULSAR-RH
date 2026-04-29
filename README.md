# PULSAR RH — AG Consultoria

Sistema SaaS de People Analytics para gestão de clima, indicadores de RH e conformidade NR-1.

---

## Arquivos

```
PULSAR-RH/
├── index.html              # Login (Admin AG + Empresa Cliente)
├── app.html                # Painel admin (exclusivo AG Consultoria)
├── client.html             # Portal do cliente (read-only, dados via Supabase)
├── responder.html          # Formulário público de pesquisa (colaboradores)
├── config.js               # Configurações centrais (Supabase, admin email)
├── questions.js            # Banco de perguntas padrão por tipo
├── supabase-schema.sql     # Schema e RLS para o Supabase
├── vercel.json             # Configuração de deploy
└── email-template-magic-link.html  # Template de e-mail para Supabase Auth
```

---

## Perfis de Acesso

| Perfil | Portal | Autenticação |
|--------|--------|-------------|
| **Admin (AG Consultoria)** | `/app` — painel completo | E-mail + senha (Supabase Auth) |
| **Cliente (empresa)** | `/client` — read-only | Magic link por e-mail (Supabase Auth) |
| **Colaborador** | `/responder?token=TOKEN` | Anônimo, link público |

---

## Funcionalidades

- Dashboard com KPIs: eNPS, score médio, absenteísmo, turnover, retenção
- People Analytics: radar de dimensões, distribuição NPS
- Indicadores de RH: absenteísmo, turnover, evolução mensal
- Pesquisas: 10 tipos, banco de perguntas, link público por token
- Formulário do colaborador: Likert, NPS, múltipla escolha, discursiva
- Planos de Ação: kanban (Pendente / Em Andamento / Concluído)
- Matriz de Riscos NR-1: heatmap 5×5
- Insights IA + Agente IA (requer chave Anthropic)
- Portal do cliente: visão isolada, read-only, dados em tempo real via Supabase

---

## Stack

- HTML5 + CSS3 + JavaScript puro (sem build step)
- Supabase (PostgreSQL + Auth)
- Chart.js 4.4.0
- Anthropic Claude API (claude-sonnet-4-6)
- Deploy: Vercel

---

## Setup Rápido

Consulte `SETUP.md` para instruções completas.

1. Supabase → SQL Editor → execute `supabase-schema.sql`
2. Cole URL e anon key em `config.js`
3. Configure e-mail template (Supabase → Auth → Email Templates → Magic Link)
4. `git push` → Vercel faz deploy automático

---

## Credenciais Demo (offline)

| Tipo | E-mail | Senha |
|------|--------|-------|
| Admin | admin@demo.pulsar | demo123 |

Em modo online (Supabase), clientes recebem magic link por e-mail. Não há senhas de cliente.

---

## Contato

📧 suporte@agconsultorialtda.com
🌐 agconsultorialtda.com
