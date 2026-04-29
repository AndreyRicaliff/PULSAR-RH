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
const SUPABASE_URL  = 'https://rpkjljwqpzwqwerydbgu.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwa2psandxcHp3cXdlcnlkYmd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc0NDAyNjMsImV4cCI6MjA5MzAxNjI2M30.7mxJ_oicfO9LnK-RP2xEwCTI0lAWvSUup6HGS5AByok';

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
