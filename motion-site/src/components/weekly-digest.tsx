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
    <section id="weekly-digest" className="max-w-5xl mx-auto mb-32">
      <motion.p
        className="text-indigo-400 font-bold text-sm tracking-[0.2em] uppercase mb-4"
        variants={fadeUp}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={0}
      >
        WEEKLY AI DIGEST
      </motion.p>
      <motion.h2
        className="text-3xl md:text-4xl font-bold mb-4 text-white"
        variants={fadeUp}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={1}
      >
        Tech news, distilled — every Monday.
      </motion.h2>
      <motion.p
        className="text-gray-400 text-lg max-w-2xl mb-10 leading-relaxed"
        variants={fadeUp}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={2}
      >
        An n8n automation pulls AI coverage from public feeds, summarizes it with
        GPT-4o-mini, and delivers a short brief. Read this week below — or
        subscribe and get it in your inbox.
      </motion.p>

      <div className="grid lg:grid-cols-[1.4fr_1fr] gap-6 items-start">
        <motion.div
          className="rounded-2xl border border-white/[0.06] bg-white/[0.03] p-6 md:p-8"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={3}
        >
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-xl bg-indigo-500/10 flex items-center justify-center">
              <Newspaper size={18} className="text-indigo-400" />
            </div>
            <div>
              <p className="text-white font-bold">{digest.title}</p>
              <p className="text-sm text-gray-500">Week of {digest.weekOf}</p>
            </div>
          </div>

          <ol className="space-y-4 mb-6">
            {digest.takeaways.map((t, i) => (
              <li key={i} className="flex gap-3 text-sm text-gray-300 leading-relaxed">
                <span className="shrink-0 mt-0.5 w-6 h-6 rounded-md bg-indigo-500/15 text-indigo-300 text-xs font-bold flex items-center justify-center">
                  {i + 1}
                </span>
                <span>{t}</span>
              </li>
            ))}
          </ol>

          <p className="text-sm text-indigo-200/90 border-t border-white/[0.06] pt-4 mb-5">
            <span className="font-semibold text-indigo-300">Watch next week: </span>
            {digest.watchNext}
          </p>

          {digest.sources?.length ? (
            <div className="space-y-2 mb-5">
              <p className="text-xs font-bold tracking-wider uppercase text-gray-500">
                Sources
              </p>
              {digest.sources.slice(0, 4).map((s) => (
                <a
                  key={s.url}
                  href={s.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="block text-sm text-gray-400 hover:text-indigo-300 transition-colors"
                >
                  {s.title}{' '}
                  <span className="text-gray-600">({s.outlet})</span>
                </a>
              ))}
            </div>
          ) : null}

          <a
            href={digest.projectUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1.5 text-sm font-semibold text-indigo-400 hover:text-indigo-300 transition-colors"
          >
            How this is automated <ArrowUpRight size={14} />
          </a>
        </motion.div>

        <motion.div
          className="rounded-2xl border border-indigo-500/20 bg-gradient-to-br from-indigo-500/[0.08] to-purple-500/[0.04] p-6 md:p-8"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={4}
        >
          <h3 className="text-xl font-bold text-white mb-2">Get it weekly</h3>
          <p className="text-sm text-gray-400 mb-6 leading-relaxed">
            Free Monday brief on AI and automation. Unsubscribe anytime. No spam —
            just the digest.
          </p>

          {status === 'ok' ? (
            <div className="flex items-start gap-3 text-emerald-300 text-sm">
              <CheckCircle2 size={18} className="shrink-0 mt-0.5" />
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
                className="w-full rounded-xl bg-black/40 border border-white/10 px-4 py-3 text-sm text-white placeholder:text-gray-600 focus:outline-none focus:border-indigo-500/50 focus:ring-1 focus:ring-indigo-500/30"
              />
              <button
                type="submit"
                disabled={status === 'loading'}
                className="w-full inline-flex items-center justify-center gap-2 px-5 py-3 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-500 text-white font-bold text-sm hover:shadow-lg hover:shadow-indigo-500/25 transition-all disabled:opacity-60"
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
                <p className="text-sm text-red-300">{message}</p>
              ) : null}
              <p className="text-[11px] text-gray-600 leading-relaxed">
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
