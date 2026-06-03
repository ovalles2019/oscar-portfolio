import { NextResponse } from 'next/server';

const SYSTEM_PROMPT = `You are a concise, professional assistant embedded on Oscar Valles's portfolio site (oscar-valles.com).
Oscar is a Cloud Engineer & full-stack developer: Master's in Computer Engineering at UTD, AWS, Kubernetes, Terraform, Python, React, MCP servers for ML and cloud ops, and production systems.
Notable projects with live demos: Agentic AI Governance Harness (agentic-governance-demo.onrender.com), FieldTech Assistant, Budget Insights, pgvector RAG Demo (pgvector-rag-demo.onrender.com), Small Business Operations MCP, ML Experiment Tracker MCP, AWS CloudOps MCP — see portfolio project cards for URLs.
Answer visitor questions about his background, skills, and projects. If asked something unrelated or sensitive, decline briefly and suggest email: ovalles6845@gmail.com.
Keep replies short (roughly 2–6 sentences) unless the user asks for detail. Do not invent employers, dates, or repos that are not implied by this context.`;

type ChatMessage = { role: 'user' | 'assistant' | 'system'; content: string };

const MAX_MESSAGES = 20;
const MAX_CONTENT = 8000;

/** Netlify / copy-paste sometimes wraps the value in quotes or adds a BOM. */
function normalizeApiKey(raw: string | undefined): string | undefined {
  if (!raw) return;
  let k = raw.trim().replace(/^\uFEFF/, '');
  if (
    (k.startsWith('"') && k.endsWith('"')) ||
    (k.startsWith("'") && k.endsWith("'"))
  ) {
    k = k.slice(1, -1).trim();
  }
  return k || undefined;
}

export async function POST(req: Request) {
  const apiKey = normalizeApiKey(process.env.Ai_K ?? process.env.OPENAI_API_KEY);
  if (!apiKey) {
    return NextResponse.json(
      {
        error:
          'Chat is not configured. Set Ai_K (or OPENAI_API_KEY) in the environment (e.g. Netlify env vars).',
      },
      { status: 503 }
    );
  }

  let body: unknown;
  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const raw = (body as { messages?: unknown }).messages;
  if (!Array.isArray(raw)) {
    return NextResponse.json({ error: 'Expected { messages: [...] }' }, { status: 400 });
  }

  const messages: ChatMessage[] = [];
  for (const m of raw.slice(-MAX_MESSAGES)) {
    if (
      typeof m === 'object' &&
      m !== null &&
      ('role' in m) &&
      ('content' in m) &&
      (m as { role: string }).role !== 'system'
    ) {
      const role = (m as { role: string }).role;
      const content = String((m as { content: unknown }).content ?? '');
      if (content.length > MAX_CONTENT) {
        return NextResponse.json({ error: 'Message too long' }, { status: 400 });
      }
      if (role === 'user' || role === 'assistant') {
        messages.push({ role, content });
      }
    }
  }

  if (messages.length === 0 || messages[messages.length - 1].role !== 'user') {
    return NextResponse.json(
      { error: 'Last message must be from the user' },
      { status: 400 }
    );
  }

  const model = process.env.OPENAI_MODEL?.trim() || 'gpt-4o-mini';

  const upstream = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model,
      temperature: 0.6,
      messages: [{ role: 'system', content: SYSTEM_PROMPT }, ...messages],
    }),
  });

  const text = await upstream.text();
  if (!upstream.ok) {
    let message = `Request failed (${upstream.status}).`;
    try {
      const errBody = JSON.parse(text) as {
        error?: { message?: string; code?: string; type?: string };
      };
      const m = errBody.error?.message;
      if (m) message = m;
      else if (typeof errBody.error === 'string') message = errBody.error;
    } catch {
      if (text?.trim()) message = text.trim().slice(0, 280);
    }
    return NextResponse.json(
      {
        error: message,
        code: upstream.status,
      },
      { status: 502 }
    );
  }

  let data: {
    choices?: Array<{ message?: { content?: string } }>;
  };
  try {
    data = JSON.parse(text) as typeof data;
  } catch {
    return NextResponse.json({ error: 'Invalid upstream response' }, { status: 502 });
  }

  const reply = data.choices?.[0]?.message?.content?.trim();
  if (!reply) {
    return NextResponse.json({ error: 'Empty model reply' }, { status: 502 });
  }

  return NextResponse.json({ reply });
}
