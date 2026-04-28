// ============================================================
// AG PEOPLE ANALYTICS — BANCO DE PERGUNTAS PADRÃO (UNIFICADO)
// ============================================================
// Fonte única de verdade para STD_QUESTIONS, TYPE_LABELS e
// normalizeDim. Usado por app.html (admin) e responder.html
// (formulário público). Dimensions em snake_case para alinhar
// com schema.sql / Supabase.
// ============================================================

const STD_QUESTIONS = {
  clima: [
    {id:'c1',text:'Como você avalia a comunicação interna da empresa?',type:'likert',dimension:'comunicacao',sub:'Pense na clareza das informações, canais disponíveis e transparência da liderança.'},
    {id:'c2',text:'Você se sente reconhecido(a) pelo seu trabalho e conquistas?',type:'likert',dimension:'reconhecimento',sub:'Considere elogios, feedbacks positivos e valorização do seu esforço.'},
    {id:'c3',text:'Como é o ambiente de colaboração e trabalho em equipe?',type:'likert',dimension:'trabalho_equipe',sub:'Pense na cooperação, confiança e sinergia com seus colegas.'},
    {id:'c4',text:'A empresa investe no seu crescimento e desenvolvimento profissional?',type:'likert',dimension:'crescimento',sub:'Treinamentos, mentorias, plano de carreira e oportunidades de evolução.'},
    {id:'c5',text:'Como você avalia seu bem-estar e qualidade de vida no trabalho?',type:'likert',dimension:'bem_estar',sub:'Considere equilíbrio entre vida pessoal e profissional, saúde e ambiente físico.'},
    {id:'c6',text:'Em uma escala de 0 a 10, o quanto você recomendaria esta empresa como um ótimo lugar para trabalhar?',type:'nps',dimension:'nps',sub:'0 = jamais recomendaria · 10 = recomendaria com certeza e entusiasmo'},
  ],
  engajamento: [
    {id:'e1',text:'O quanto você se sente engajado(a) com a missão e objetivos da empresa?',type:'likert',dimension:'engajamento',sub:'Pense em como seus valores se alinham com os da organização.'},
    {id:'e2',text:'Você sente que seu trabalho tem propósito e gera impacto real?',type:'likert',dimension:'proposito',sub:'Considere como suas atividades contribuem para um objetivo maior.'},
    {id:'e3',text:'A liderança te inspira e motiva a dar o seu melhor?',type:'likert',dimension:'lideranca',sub:'Pense em como seu gestor ou diretoria influencia sua motivação diária.'},
    {id:'e4',text:'Em uma escala de 0 a 10, o quanto você recomendaria esta empresa como lugar para trabalhar?',type:'nps',dimension:'nps',sub:'0 = jamais · 10 = com total entusiasmo'},
  ],
  '360': [
    {id:'360-1',text:'O colaborador avaliado demonstra liderança positiva e inspiradora?',type:'likert',dimension:'lideranca',sub:'Considere sua capacidade de influenciar e motivar as pessoas ao redor.'},
    {id:'360-2',text:'A comunicação dele/dela é clara, objetiva e respeitosa?',type:'likert',dimension:'comunicacao',sub:'Pense em reuniões, e-mails, conversas e clareza nas solicitações.'},
    {id:'360-3',text:'Ele/ela colabora ativamente com a equipe e busca soluções conjuntas?',type:'likert',dimension:'trabalho_equipe',sub:'Avalie a disposição para ajudar, compartilhar e trabalhar junto.'},
    {id:'360-4',text:'Age com ética, transparência e integridade em suas decisões?',type:'likert',dimension:'etica',sub:'Pense em situações onde valores e princípios foram colocados à prova.'},
    {id:'360-5',text:'Busca constantemente aprender, melhorar e se desenvolver?',type:'likert',dimension:'crescimento',sub:'Avalie a abertura para feedback e disposição para evoluir.'},
  ],
  '180': [
    {id:'180-1',text:'Seu gestor oferece feedback claro, construtivo e regular?',type:'likert',dimension:'feedback',sub:'Pense na qualidade e frequência dos retornos que você recebe.'},
    {id:'180-2',text:'Você recebe suporte e recursos adequados para atingir suas metas?',type:'likert',dimension:'suporte',sub:'Considere ferramentas, informações e apoio disponíveis.'},
    {id:'180-3',text:'Seu gestor reconhece suas conquistas e valoriza seu esforço?',type:'likert',dimension:'reconhecimento',sub:'Pense em situações em que você se sentiu valorizado pelo seu líder.'},
  ],
  lideranca: [
    {id:'l1',text:'Seu líder comunica a visão, metas e expectativas com clareza?',type:'likert',dimension:'visao',sub:'Você sabe para onde a equipe está indo e qual é o seu papel nisso?'},
    {id:'l2',text:'Você confia nas decisões e no julgamento do seu gestor?',type:'likert',dimension:'confianca',sub:'Pense em situações difíceis e como as decisões foram tomadas.'},
    {id:'l3',text:'Seu líder incentiva o desenvolvimento e crescimento da equipe?',type:'likert',dimension:'desenvolvimento',sub:'Ele/ela investe no potencial das pessoas ao seu redor?'},
    {id:'l4',text:'O quanto este líder te inspira a dar o seu melhor todos os dias?',type:'nps',dimension:'nps',sub:'0 = não me inspira · 10 = me inspira completamente'},
  ],
  felicidade: [
    {id:'f1',text:'De modo geral, como está sua felicidade no trabalho hoje?',type:'likert',dimension:'felicidade',sub:'Seja honesto(a) — não existe resposta certa ou errada.'},
    {id:'f2',text:'Seu trabalho está alinhado com seus valores e propósito pessoal?',type:'likert',dimension:'proposito',sub:'Você sente que o que faz tem significado para você?'},
    {id:'f3',text:'Você se sente genuinamente valorizado(a) como pessoa, não apenas como profissional?',type:'likert',dimension:'valor',sub:'A empresa reconhece quem você é além das suas entregas?'},
    {id:'f4',text:'O que mais contribui para a sua felicidade aqui?',type:'escolha',dimension:'drivers',sub:'Escolha o fator mais importante para você.',options:['Colegas e trabalho em equipe','Reconhecimento e valorização','Desafios e crescimento','Liderança inspiradora','Flexibilidade e equilíbrio de vida','Propósito e impacto do trabalho']},
  ],
  nr1: [
    {id:'n1',text:'Como você avalia seu nível de estresse no trabalho atualmente?',type:'likert',dimension:'saude_mental',sub:'1 = muito baixo (ótimo) · 10 = extremamente alto (preocupante)'},
    {id:'n2',text:'Você consegue equilibrar a vida profissional com a pessoal?',type:'likert',dimension:'equilibrio',sub:'Pense em tempo para família, hobbies, descanso e autocuidado.'},
    {id:'n3',text:'Você se sente apoiado(a) pela empresa em momentos de dificuldade?',type:'likert',dimension:'suporte',sub:'Há recursos, pessoas ou políticas que te ajudam quando você precisa?'},
    {id:'n4',text:'Nos últimos 30 dias, sentiu sintomas de cansaço extremo ou esgotamento?',type:'escolha',dimension:'burnout',sub:'Seja honesto(a) — essa informação é fundamental para ações de cuidado.',options:['Não senti nenhum sintoma','Senti levemente, mas passou','Sinto regularmente e me preocupa','Estou me sentindo esgotado(a) agora']},
    {id:'n5',text:'A empresa promove ações concretas de saúde mental e bem-estar?',type:'likert',dimension:'saude_mental',sub:'Palestras, apoio psicológico, programas de bem-estar, políticas flexíveis.'},
  ],
  onboarding: [
    {id:'o1',text:'O processo de integração foi bem planejado e te preparou para a função?',type:'likert',dimension:'onboarding',sub:'Você recebeu as informações, treinamentos e suporte necessários?'},
    {id:'o2',text:'A equipe e a liderança te acolheram e fizeram você se sentir bem-vindo(a)?',type:'likert',dimension:'acolhimento',sub:'Pense nos primeiros dias e semanas na empresa.'},
    {id:'o3',text:'O que mais poderia ter tornado sua chegada ainda melhor?',type:'escolha',dimension:'melhoria',sub:'Escolha o principal ponto a ser melhorado.',options:['Mais treinamentos técnicos','Melhor apresentação da cultura','Buddy / mentor nos primeiros dias','Mais clareza sobre a função','Integração social com o time','Suporte do RH foi excelente']},
    {id:'o4',text:'Com base na sua experiência até aqui, o quanto você recomendaria esta empresa? (0 a 10)',type:'nps',dimension:'nps',sub:'0 = não recomendaria · 10 = recomendaria com toda certeza'},
  ],
  desligamento: [
    {id:'d1',text:'Qual o principal motivo da sua saída da empresa?',type:'escolha',dimension:'motivo',sub:'Seja sincero(a) — isso nos ajuda a melhorar para os próximos.',options:['Nova oportunidade de crescimento','Remuneração abaixo do mercado','Ambiente ou cultura organizacional','Relacionamento com a gestão','Mudança de área / carreira','Questões pessoais']},
    {id:'d2',text:'Você foi tratado(a) com respeito e dignidade durante toda a sua jornada aqui?',type:'likert',dimension:'respeito',sub:'Considere a cultura, liderança e colegas ao longo do tempo.'},
    {id:'d3',text:'O que a empresa poderia ter feito diferente para te manter?',type:'discursiva',dimension:'melhoria',sub:'Sua resposta pode mudar a trajetória de quem vem depois de você.'},
    {id:'d4',text:'Você recomendaria esta empresa como empregador para alguém de confiança? (0–10)',type:'nps',dimension:'nps',sub:'0 = jamais · 10 = com total confiança'},
  ],
  saude: [
    {id:'s1',text:'Como você avalia sua saúde geral atualmente?',type:'likert',dimension:'saude',sub:'Considere saúde física, mental e emocional de forma integrada.'},
    {id:'s2',text:'A empresa oferece condições físicas e ergonômicas adequadas para o trabalho?',type:'likert',dimension:'ergonomia',sub:'Equipamentos, cadeiras, iluminação, temperatura, espaço.'},
    {id:'s3',text:'Você faz pausas e se desconecta adequadamente durante o dia?',type:'escolha',dimension:'pausas',sub:'Pausas regulares são essenciais para produtividade e saúde.',options:['Sim, com regularidade e sem culpa','Às vezes, quando dá tempo','Raramente — sinto pressão para não pausar','Não consigo me desconectar']},
  ],
};

const TYPE_LABELS = {
  clima:'Clima Organizacional',
  engajamento:'Engajamento / eNPS',
  '360':'Avaliação 360°',
  '180':'Avaliação 180°',
  lideranca:'Liderança',
  felicidade:'Felicidade no Trabalho',
  nr1:'NR-1 / Saúde Mental',
  onboarding:'Onboarding',
  desligamento:'Desligamento',
  saude:'Saúde Geral',
};

// Normaliza dimensões legadas (Title Case) ou customizadas pelo admin
// para snake_case. Std questions já vêm em snake_case.
const DIM_LEGACY_MAP = {
  'Comunicação':'comunicacao','Reconhecimento':'reconhecimento','Equipe':'trabalho_equipe',
  'Crescimento':'crescimento','Bem-estar':'bem_estar','eNPS':'nps','NPS':'nps',
  'Engajamento':'engajamento','Propósito':'proposito','Liderança':'lideranca',
  'Estresse':'saude_mental','Equilíbrio':'equilibrio','Suporte':'suporte',
  'Burnout':'burnout','Saúde Mental':'saude_mental','Felicidade':'felicidade',
  'Valor':'valor','Drivers':'drivers','Feedback':'feedback','Confiança':'confianca',
  'Desenvolvimento':'desenvolvimento','Inspiração':'nps','Ética':'etica',
  'Visão':'visao','Integração':'onboarding','Acolhimento':'acolhimento',
  'Melhoria':'melhoria','Motivo':'motivo','Respeito':'respeito',
  'Saúde':'saude','Ergonomia':'ergonomia','Pausas':'pausas',
};

function normalizeDim(d){
  if(!d) return null;
  if(DIM_LEGACY_MAP[d]) return DIM_LEGACY_MAP[d];
  return String(d).toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g,'').replace(/\s+/g,'_');
}

// Disponibiliza globalmente (sem módulos — projeto é HTML puro)
if (typeof window !== 'undefined') {
  window.STD_QUESTIONS = STD_QUESTIONS;
  window.TYPE_LABELS = TYPE_LABELS;
  window.normalizeDim = normalizeDim;
}
