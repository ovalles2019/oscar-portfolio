'use client';

import { FormEvent, useState } from 'react';
import { motion } from 'framer-motion';
import { ArrowUpRight, CheckCircle2, Loader2, Newspaper, Send } from 'lucide-react';
import type { DigestLatest } from '@/lib/digest';

const fadeUp = {
  hidden: { opacity: 0, y: 30 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { delay: i * 0.1, duration: 0.6, ease: 'easeOut' as const },
  }),
};

type Props = {
  digest: DigestLatest;
};

export default function WeeklyDigest({ digest }: Props) {
  const [email, setEmail] = useState('');
  const [status, setStatus] = useState<'idle' | 'loading' | 'ok' | 'error'>('idle');
  const [message, setMessage] = useState('');

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setStatus('loading');
    setMessage('');

    try {
      const res = await fetch('/api/subscribe', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, source: 'motion-site-weekly-digest' }),
      });
      const data = (await res.json()) as { error?: string; message?: string };
      if (!res.ok) {
        setStatus('error');
        setMessage(data.error || 'Something went wrong. Try again.');
        return;
      }
      setStatus('ok');
      setMessage(data.message || 'You’re on the list. See you Monday.');
      setEmail('');
    } catch {
      setStatus('error');
      setMessage('Network error. Please try again.');
    }
  }

  return (
    <section
      id="weekly-digest"
      className="mx-auto max-w-[1400px] px-5 py-20 md:px-10 lg:px-[80px] xl:px-[150px]"
    >
      <motion.h2
        className="mb-3 text-4xl font-extrabold text-[var(--text-primary)] md:text-[44px]"
        variants={fadeUp}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={0}
      >
        Weekly AI Digest
      </motion.h2>
      <motion.p
        className="mb-10 max-w-2xl text-[15px] leading-[1.75] text-[var(--text-muted)]"
        variants={fadeUp}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={1}
      >
        An n8n automation pulls AI coverage from public feeds, summarizes it with
        GPT-4o-mini, and delivers a short brief. Read this week below — or
        subscribe and get it in your inbox.
      </motion.p>

      <div className="grid items-start gap-6 lg:grid-cols-[1.4fr_1fr]">
        <motion.div
          className="rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] p-6 md:p-8"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={2}
        >
          <div className="mb-6 flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl border border-[var(--border-subtle)] bg-[var(--bg)]">
              <Newspaper size={18} className="text-[var(--text-primary)]" />
            </div>
            <div>
              <p className="font-bold text-[var(--text-primary)]">{digest.title}</p>
              <p className="text-sm text-[var(--text-muted)]">Week of {digest.weekOf}</p>
            </div>
          </div>

          <ol className="mb-6 space-y-4">
            {digest.takeaways.map((t, i) => (
              <li key={i} className="flex gap-3 text-sm leading-relaxed text-[var(--text-primary)]">
                <span className="mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-md border border-[var(--border-subtle)] bg-[var(--bg)] text-xs font-bold">
                  {i + 1}
                </span>
                <span className="text-[var(--text-muted)]">{t}</span>
              </li>
            ))}
          </ol>

          <p className="mb-5 border-t border-[var(--border-subtle)] pt-4 text-sm text-[var(--text-muted)]">
            <span className="font-semibold text-[var(--text-primary)]">Watch next week: </span>
            {digest.watchNext}
          </p>

          {digest.sources?.length ? (
            <div className="mb-5 space-y-2">
              <p className="text-xs font-bold tracking-wider uppercase text-[var(--text-muted)]">
                Sources
              </p>
              {digest.sources.slice(0, 4).map((s) => (
                <a
                  key={s.url}
                  href={s.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="block text-sm text-[var(--text-muted)] hover:text-[var(--text-primary)]"
                >
                  {s.title}{' '}
                  <span className="text-[var(--text-faint)]">({s.outlet})</span>
                </a>
              ))}
            </div>
          ) : null}

          <a
            href={digest.projectUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1.5 text-sm font-semibold text-accent-green hover:opacity-80"
          >
            How this is automated <ArrowUpRight size={14} />
          </a>
        </motion.div>

        <motion.div
          className="rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] p-6 md:p-8"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={3}
        >
          <h3 className="mb-2 text-xl font-bold text-[var(--text-primary)]">Get it weekly</h3>
          <p className="mb-6 text-sm leading-relaxed text-[var(--text-muted)]">
            Free Monday brief on AI and automation. Unsubscribe anytime. No spam —
            just the digest.
          </p>

          {status === 'ok' ? (
            <div className="flex items-start gap-3 text-sm text-accent-green">
              <CheckCircle2 size={18} className="mt-0.5 shrink-0" />
              <p>{message}</p>
            </div>
          ) : (
            <form onSubmit={onSubmit} className="space-y-3">
              <label htmlFor="digest-email" className="sr-only">
                Email
              </label>
              <input
                id="digest-email"
                type="email"
                required
                autoComplete="email"
                placeholder="you@company.com"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  if (status === 'error') setStatus('idle');
                }}
                className="w-full rounded-full border border-[var(--border-subtle)] bg-[var(--bg)] px-4 py-3 text-sm text-[var(--text-primary)] placeholder:text-[var(--text-faint)] outline-none focus:border-[var(--border-hover)]"
              />
              <button
                type="submit"
                disabled={status === 'loading'}
                className="inline-flex w-full items-center justify-center gap-2 rounded-full bg-[var(--pill-white)] px-5 py-3 text-sm font-semibold text-[var(--pill-text)] transition-transform hover:-translate-y-px disabled:opacity-60"
              >
                {status === 'loading' ? (
                  <>
                    <Loader2 size={16} className="animate-spin" /> Subscribing…
                  </>
                ) : (
                  <>
                    <Send size={16} /> Subscribe
                  </>
                )}
              </button>
              {status === 'error' ? (
                <p className="text-sm text-red-400">{message}</p>
              ) : null}
              <p className="text-[11px] leading-relaxed text-[var(--text-muted)]">
                By subscribing you agree to receive the weekly digest. Your email
                is only used for this newsletter.
              </p>
            </form>
          )}
        </motion.div>
      </div>
    </section>
  );
}
