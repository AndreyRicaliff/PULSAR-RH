// ============================================================
// AG PEOPLE ANALYTICS — CONFIGURAÇÃO CENTRAL
// ============================================================
// PASSO 1: Supabase → https://supabase.com
//          Crie o projeto → Settings → API
//          Copie "Project URL" e "anon public key"
//
// PASSO 2: Claude API → https://console.anthropic.com
//          API Keys → Create Key
//          Cole a chave no painel do sistema (Agente IA → ⚙️)
//
// PASSO 3: Substitua os valores abaixo e faça o deploy
// ============================================================

// ── SUPABASE ──────────────────────────────────────────────
const SUPABASE_URL  = 'https://SEU_PROJECT_ID.supabase.co';
const SUPABASE_ANON = 'sua-chave-anon-publica-aqui';

// ── MODO DE OPERAÇÃO ──────────────────────────────────────
// true  → usa localStorage (demo offline, sem banco de dados)
// false → usa Supabase (produção, requer credenciais acima)
const OFFLINE_MODE = SUPABASE_URL.includes('SEU_PROJECT');

// ── ADMINISTRADOR ─────────────────────────────────────────
// Em produção, substitua por autenticação via Supabase Auth
const ADMIN_EMAIL    = 'admin@agconsultoria.com';
const ADMIN_PASSWORD = '123456';

// ── CONFIGURAÇÕES GERAIS ──────────────────────────────────
const APP_VERSION = '2.0.0';
const APP_NAME    = 'AG People Analytics';
