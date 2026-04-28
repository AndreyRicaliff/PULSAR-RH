# AG People Analytics v2

Sistema de People Analytics da **AG Consultoria** — plataforma SaaS para gestão de clima organizacional, indicadores de RH e conformidade NR-1.

---

## Estrutura de Arquivos

```
ag-rh/
├── index.html        # Tela de login (Admin AG + Empresa Cliente)
├── app.html          # Aplicação principal (painel admin e cliente)
├── responder.html    # Formulário público de pesquisa (link enviado aos colaboradores)
├── config.js         # ⚙️  Configurações centrais (Supabase, modo offline)
├── schema.sql        # Schema completo do banco de dados Supabase
├── SETUP.md          # Guia detalhado de instalação e deploy
├── .gitignore
└── README.md
```

---

## Perfis de Acesso

| Perfil | Acesso | Como entra |
|---|---|---|
| **Admin (AG Consultoria)** | Painel completo: todos os clientes, relatórios, config | `index.html` → aba "Consultoria AG" |
| **Cliente (empresa)** | Apenas dados da própria empresa | `index.html` → aba "Empresa Cliente" |
| **Colaborador** | Responde pesquisas via link público | `responder.html?token=TOKEN` |

---

## Funcionalidades

### Dashboard
- KPIs em tempo real: eNPS, Score médio, Felicidade, Absenteísmo, Turnover, Retenção, Headcount
- Gráficos: radar de dimensões, distribuição eNPS, tendência mensal, score por empresa

### People Analytics
- Radar de todas as dimensões
- Distribuição NPS (promotores / neutros / detratores)
- Headcount por departamento

### Indicadores de RH
- **Absenteísmo** — fórmula: (faltas ÷ (HC × dias úteis)) × 100
- **Turnover mensal** — fórmula: ((saídas + entradas) ÷ 2 ÷ HC) × 100
- **Taxa de Retenção** — 100% − turnover
- **Índice de Felicidade** — calculado das pesquisas de felicidade
- Evolução histórica em gráficos de linha
- Lançamento mensal de dados pelo admin

### Matrizes de Risco (NR-1)
- **Matriz 5×5** Probabilidade × Severidade com heatmap colorido
- Cadastro de fatores de risco psicossocial (NR-1 Anexo III)
- Classificação automática: Baixo / Médio / Alto / Crítico
- Tabela detalhada com evidências

### Pesquisas
Tipos disponíveis: Clima Organizacional, Engajamento/eNPS, Avaliação 360°, Avaliação 180°, Liderança, Felicidade, NR-1/Saúde Mental, Onboarding, Desligamento, Saúde Geral

- Banco de perguntas padrão por tipo
- Perguntas customizadas por pesquisa
- Link público único por pesquisa (token)
- Gestão de status: ativa / pausada / concluída

### Formulário do Colaborador (`responder.html`)
- Design mobile-first com animações
- Tipos de pergunta: Likert (1–10), NPS (0–10), Múltipla Escolha, Discursiva
- Feedback inline por resposta
- 100% anônimo — sem identificação do respondente
- Coleta área, tempo de empresa (opcionais)

### Insights IA
- Análise automática de pontos fortes e atenção
- Campo de **notas do especialista** para contexto qualitativo
- **Geração de insights com Claude AI** (requer API key)
- Análise integrada: scores + indicadores + riscos NR-1 + planos de ação

### Agente IA (chat)
- Chat em tempo real com Claude claude-sonnet-4-6
- Contexto automático: todos os dados da empresa selecionada
- Histórico de conversa na sessão

### Gestão
- Colaboradores (CLT, PJ, Estágio, Temporário)
- Planos de Ação com prioridade e responsável
- Clientes (admin): CRUD completo, planos básico/intermediário/completo
- Relatórios consolidados

---

## Stack Técnica

- **Frontend:** HTML5 + CSS3 + JavaScript puro (sem frameworks, sem build step)
- **Gráficos:** Chart.js 4.4.0 (via CDN)
- **Banco de dados:** Supabase (PostgreSQL) — opcional, modo offline com localStorage
- **IA:** Anthropic Claude API (claude-sonnet-4-6)
- **Autenticação:** Sessão via `sessionStorage` (MVP) → migrar para Supabase Auth em produção
- **Deploy:** qualquer hospedagem estática (Vercel, GitHub Pages, cPanel)

---

## Setup Rápido (3 passos)

### 1. Supabase (banco de dados)
```
1. Acesse https://supabase.com → New Project
2. Região: South America (São Paulo)
3. SQL Editor → cole e execute schema.sql
4. Settings → API → copie URL e anon key
5. Cole em config.js
```

### 2. RLS (segurança básica para MVP)
```sql
-- Execute no SQL Editor do Supabase
CREATE POLICY "anon_read_clients"    ON clients    FOR SELECT USING (true);
CREATE POLICY "anon_insert_response" ON survey_responses FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_insert_answer"   ON question_answers  FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_read_surveys"    ON surveys    FOR SELECT USING (true);
CREATE POLICY "anon_read_questions"  ON survey_questions FOR SELECT USING (true);
```

### 3. Deploy no Vercel
```
1. git push para o repositório
2. Acesse https://vercel.com → Import
3. Selecione o repositório
4. Deploy (zero configuração)
5. Adicione domínio: rh.agconsultorialtda.com
```

Consulte `SETUP.md` para instruções detalhadas.

---

## Configuração da API Claude (IA)

A chave Claude **não é armazenada em código** — o usuário admin configura diretamente no painel:

```
App → menu "Agente IA" → botão ⚙️ Config. API → cole a chave sk-ant-...
```

A chave é salva em `localStorage` do navegador do admin (uso interno).  
Para produção com múltiplos usuários, implemente um proxy backend seguro.

---

## Credenciais Demo (modo offline)

| Tipo | E-mail | Senha |
|---|---|---|
| Admin | admin@agconsultoria.com | 123456 |
| Cliente 1 | rh@tech.com | rh123 |
| Cliente 2 | rh@varejo.com | rh456 |
| Cliente 3 | rh@saude.com | rh789 |

**Importante:** Altere todas as senhas antes de ir para produção.

---

## Links de Pesquisa Demo

| Empresa | Token | URL |
|---|---|---|
| Tech Solutions | tok-cli1-clim | `responder.html?token=tok-cli1-clim` |
| Varejo Nordeste | tok-cli2-eng | `responder.html?token=tok-cli2-eng` |
| Clínica Saúde | tok-cli3-nr1 | `responder.html?token=tok-cli3-nr1` |

---

## Variáveis em `config.js`

| Variável | Descrição |
|---|---|
| `SUPABASE_URL` | URL do projeto Supabase |
| `SUPABASE_ANON` | Chave anon pública do Supabase |
| `OFFLINE_MODE` | `true` = localStorage / `false` = Supabase |
| `ADMIN_EMAIL` | E-mail do administrador |
| `ADMIN_PASSWORD` | Senha do administrador |

---

## Banco de Dados (Supabase)

Tabelas principais:
- `clients` — empresas clientes
- `collaborators` — colaboradores por empresa
- `surveys` — pesquisas com token público
- `survey_questions` — perguntas por pesquisa
- `survey_responses` — uma por respondente
- `question_answers` — respostas por pergunta (big data)
- `action_plans` — planos de ação

Views analíticas:
- `vw_dimension_scores` — score médio por dimensão e empresa
- `vw_enps` — cálculo eNPS por empresa
- `vw_monthly_trend` — tendência mensal de score

> **Nota:** Absenteísmo, turnover e riscos NR-1 são gerenciados via localStorage no MVP. Para Supabase, adicione as tabelas `indicators` e `nr1_risks` conforme estrutura dos dados em `app.html → initSeedData()`.

---

## Fluxo de Uso

```
Admin cria empresa → Admin cria pesquisa → Copia link → 
Envia para colaboradores → Colaboradores respondem (responder.html) → 
Resultados aparecem em tempo real no painel → 
Admin adiciona notas de especialista → IA gera insights → 
Admin conversa com Agente IA → Admin cria planos de ação
```

---

## Contato

📧 suporte@agconsultorialtda.com  
🌐 agconsultorialtda.com  
📲 (55) 9 8615-7028
