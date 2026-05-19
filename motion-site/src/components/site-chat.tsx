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
    <div className='fixed bottom-5 right-5 z-[100] flex flex-col items-end gap-3'>
      {open && (
        <div
          className='flex w-[min(100vw-2.5rem,400px)] flex-col overflow-hidden rounded-2xl border border-white/10 bg-zinc-950/95 shadow-[0_24px_80px_-20px_rgba(0,0,0,0.85)] backdrop-blur-xl'
          role='dialog'
          aria-label='Chat with portfolio assistant'
        >
          <div className='flex items-center justify-between border-b border-white/10 px-4 py-3'>
            <span className='text-sm font-semibold text-white'>Ask about Oscar</span>
            <button
              type='button'
              onClick={() => setOpen(false)}
              className='rounded-lg p-1.5 text-white/60 hover:bg-white/10 hover:text-white'
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
                    ? 'ml-6 bg-indigo-500/20 text-indigo-50'
                    : 'mr-4 bg-white/[0.06] text-gray-200'
                }`}
              >
                {m.content}
              </div>
            ))}
            {pending && (
              <div className='mr-4 flex items-center gap-2 rounded-xl bg-white/[0.06] px-3 py-2 text-sm text-gray-400'>
                <Loader2 className='h-4 w-4 animate-spin' aria-hidden />
                Thinking…
              </div>
            )}
          </div>
          {error && (
            <div className='border-t border-red-500/20 bg-red-500/10 px-4 py-2 text-xs text-red-200'>
              {error}
            </div>
          )}
          <div className='flex gap-2 border-t border-white/10 p-3'>
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
              className='min-w-0 flex-1 rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-white placeholder:text-white/35 outline-none focus:border-indigo-500/40'
              disabled={pending}
              maxLength={2000}
              aria-label='Message'
            />
            <button
              type='button'
              onClick={() => void send()}
              disabled={pending || !input.trim()}
              className='inline-flex shrink-0 items-center justify-center rounded-xl bg-gradient-to-r from-indigo-500 to-purple-600 px-3 py-2 text-white shadow-lg shadow-indigo-500/20 disabled:opacity-40'
              aria-label='Send'
            >
              <Send size={18} />
            </button>
          </div>
        </div>
      )}
      <button
        type='button'
        onClick={() => setOpen((o) => !o)}
        className='flex h-14 w-14 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 to-purple-600 text-white shadow-lg shadow-indigo-500/30 ring-2 ring-white/10 transition hover:scale-105 hover:shadow-indigo-500/40'
        aria-expanded={open}
        aria-label={open ? 'Close chat' : 'Open chat'}
      >
        {open ? <X size={22} /> : <MessageCircle size={24} />}
      </button>
    </div>
  );
}
