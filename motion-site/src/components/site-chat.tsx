'use client';

import { useEffect, useRef, useState } from 'react';
import { MessageCircle, Send, X, Loader2 } from 'lucide-react';

type Msg = { role: 'user' | 'assistant'; content: string };

export default function SiteChat() {
  const [open, setOpen] = useState(false);
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState<Msg[]>([
    {
      role: 'assistant',
      content:
        "Hi — I'm Oscar's site assistant. Ask about cloud engineering, projects, or how to reach him.",
    },
  ]);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const listRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    listRef.current?.scrollTo({ top: listRef.current.scrollHeight, behavior: 'smooth' });
  }, [messages, open, pending]);

  const send = async () => {
    const text = input.trim();
    if (!text || pending) return;
    setInput('');
    setError(null);
    const next: Msg[] = [...messages, { role: 'user', content: text }];
    setMessages(next);
    setPending(true);
    try {
      const res = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ messages: next }),
      });
      const data = (await res.json()) as {
        reply?: string;
        error?: string;
        detail?: string;
        code?: number;
      };
      if (!res.ok) {
        throw new Error(
          data.error ||
            data.detail ||
            (data.code ? `Request failed (${data.code})` : `Request failed (${res.status})`)
        );
      }
      if (!data.reply) throw new Error('No reply from server');
      setMessages([...next, { role: 'assistant', content: data.reply }]);
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'Something went wrong';
      setError(msg);
      setInput(text);
      setMessages((prev) =>
        prev.length && prev[prev.length - 1]?.role === 'user'
          ? prev.slice(0, -1)
          : prev
      );
    } finally {
      setPending(false);
    }
  };

  return (
    <div className='fixed right-5 bottom-5 z-[100] flex flex-col items-end gap-3'>
      {open && (
        <div
          className='flex w-[min(100vw-2.5rem,400px)] flex-col overflow-hidden rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)]'
          role='dialog'
          aria-label='Chat with portfolio assistant'
        >
          <div className='flex items-center justify-between border-b border-[var(--border-subtle)] px-4 py-3'>
            <span className='text-sm font-semibold text-[var(--text-primary)]'>Ask about Oscar</span>
            <button
              type='button'
              onClick={() => setOpen(false)}
              className='rounded-lg p-1.5 text-[var(--text-muted)] hover:bg-[var(--hover-overlay)] hover:text-[var(--text-primary)]'
              aria-label='Close chat'
            >
              <X size={18} />
            </button>
          </div>
          <div
            ref={listRef}
            className='max-h-[min(52vh,420px)] space-y-3 overflow-y-auto px-4 py-3'
          >
            {messages.map((m, i) => (
              <div
                key={`${i}-${m.role}`}
                className={`rounded-xl px-3 py-2 text-sm leading-relaxed ${
                  m.role === 'user'
                    ? 'ml-6 bg-[var(--pill-white)] text-[var(--pill-text)]'
                    : 'mr-4 border border-[var(--border-subtle)] bg-[var(--bg)] text-[var(--text-primary)]'
                }`}
              >
                {m.content}
              </div>
            ))}
            {pending && (
              <div className='mr-4 flex items-center gap-2 rounded-xl border border-[var(--border-subtle)] bg-[var(--bg)] px-3 py-2 text-sm text-[var(--text-muted)]'>
                <Loader2 className='h-4 w-4 animate-spin' aria-hidden />
                Thinking…
              </div>
            )}
          </div>
          {error && (
            <div className='border-t border-red-500/20 bg-red-500/10 px-4 py-2 text-xs text-red-300'>
              {error}
            </div>
          )}
          <div className='flex gap-2 border-t border-[var(--border-subtle)] p-3'>
            <input
              type='text'
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault();
                  void send();
                }
              }}
              placeholder='Ask a question…'
              className='min-w-0 flex-1 rounded-full border border-[var(--border-subtle)] bg-[var(--bg)] px-3 py-2 text-sm text-[var(--text-primary)] placeholder:text-[var(--text-faint)] outline-none focus:border-[var(--border-hover)]'
              disabled={pending}
              maxLength={2000}
              aria-label='Message'
            />
            <button
              type='button'
              onClick={() => void send()}
              disabled={pending || !input.trim()}
              className='inline-flex size-10 shrink-0 items-center justify-center rounded-full bg-[var(--pill-white)] text-[var(--pill-text)] disabled:opacity-40'
              aria-label='Send'
            >
              <Send size={16} />
            </button>
          </div>
        </div>
      )}
      <button
        type='button'
        onClick={() => setOpen((o) => !o)}
        className='flex h-14 w-14 items-center justify-center rounded-full bg-[var(--pill-white)] text-[var(--pill-text)] transition-transform hover:-translate-y-px'
        aria-expanded={open}
        aria-label={open ? 'Close chat' : 'Open chat'}
      >
        {open ? <X size={22} /> : <MessageCircle size={24} />}
      </button>
    </div>
  );
}
