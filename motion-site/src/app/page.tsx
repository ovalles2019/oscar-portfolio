'use client';

import { motion } from 'framer-motion';
import { ArrowUpRight, Mail } from 'lucide-react';
import projectData from '@/data/projects.json';
import digestLatest from '@/data/digest-latest.json';
import WeeklyDigest from '@/components/weekly-digest';
import Hero from '@/components/hero';
import Skills from '@/components/skills';
import type { DigestLatest } from '@/lib/digest';

const fadeUp = {
  hidden: { opacity: 0, y: 24 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { delay: i * 0.08, duration: 0.5, ease: 'easeOut' as const },
  }),
};

export default function Home() {
  return (
    <main>
      <Hero />
      <Skills />

      <section
        id="projects"
        className="mx-auto max-w-[1400px] px-5 py-20 md:px-10 lg:px-[80px] lg:py-[100px] xl:px-[150px]"
      >
        <motion.h2
          className="mb-3 text-4xl font-extrabold text-[var(--text-primary)] md:text-[44px]"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={0}
        >
          My Projects
        </motion.h2>
        <motion.p
          className="mb-10 max-w-2xl text-[15px] leading-[1.75] text-[var(--text-muted)]"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={1}
        >
          A selection of projects I&apos;ve built, spanning cloud
          infrastructure, AI systems, and full-stack applications.
        </motion.p>

        <div className="grid gap-6 md:grid-cols-2">
          {projects.map((p, i) => (
            <motion.article
              key={p.title}
              className="group overflow-hidden rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] transition-colors hover:border-[var(--border-hover)]"
              variants={fadeUp}
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true }}
              custom={i + 2}
            >
              <div className="relative h-48 overflow-hidden">
                <img
                  src={p.image}
                  alt={p.title}
                  className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                />
                <span className="absolute top-3 left-3 rounded-md border border-[var(--border-subtle)] bg-black/60 px-3 py-1 text-[10px] font-bold tracking-wider text-white">
                  {p.category}
                </span>
              </div>
              <div className="p-5">
                <h3 className="mb-2 text-lg font-bold text-[var(--text-primary)]">
                  {p.title}
                </h3>
                <p className="mb-4 line-clamp-2 text-sm text-[var(--text-muted)]">
                  {p.desc}
                </p>
                <div className="mb-4 flex flex-wrap gap-1.5">
                  {p.tech.map((t) => (
                    <span
                      key={t}
                      className="rounded-full border border-[var(--border-subtle)] bg-[var(--bg)] px-2.5 py-1 text-[11px] font-semibold text-[var(--text-primary)]"
                    >
                      {t}
                    </span>
                  ))}
                </div>
                <div className="flex flex-wrap items-center gap-x-5 gap-y-2">
                  {p.demo ? (
                    <a
                      href={p.demo}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center gap-1.5 text-sm font-semibold text-accent-green hover:opacity-80"
                    >
                      Live Demo <ArrowUpRight size={14} />
                    </a>
                  ) : null}
                  <a
                    href={p.github}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 text-sm font-semibold text-[var(--text-primary)] hover:opacity-80"
                  >
                    Source Code <ArrowUpRight size={14} />
                  </a>
                </div>
              </div>
            </motion.article>
          ))}
        </div>
      </section>

      <WeeklyDigest digest={digestLatest as DigestLatest} />

      <section
        id="contact"
        className="mx-auto max-w-[1400px] px-5 pb-20 md:px-10 lg:px-[80px] xl:px-[150px]"
      >
        <motion.div
          className="rounded-3xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] p-10 md:p-16"
          variants={fadeUp}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          custom={0}
        >
          <span className="mb-4 inline-block rounded-full border border-[var(--border-subtle)] bg-[var(--bg)] px-3.5 py-1.5 text-[11px] font-bold tracking-[0.1em] uppercase text-[var(--text-primary)]">
            Get In Touch
          </span>
          <h2 className="mb-4 text-3xl font-extrabold text-[var(--text-primary)] md:text-4xl">
            Let&apos;s Work Together
          </h2>
          <p className="mb-8 max-w-xl text-[15px] leading-relaxed text-[var(--text-muted)]">
            Open to full-time roles, contract work, and collaborations in cloud
            engineering and product development.
          </p>
          <div className="flex flex-wrap gap-3.5">
            <a
              href="mailto:ovalles6845@gmail.com"
              className="inline-flex items-center gap-2 rounded-full bg-[var(--pill-white)] px-[22px] py-3 text-sm font-semibold text-[var(--pill-text)] transition-transform hover:-translate-y-px"
            >
              <Mail size={16} /> Contact Me
            </a>
            <a
              href="https://github.com/ovalles2019"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 rounded-full border border-[var(--border-subtle)] px-[22px] py-3 text-sm font-semibold text-[var(--text-primary)] transition-transform hover:-translate-y-px"
            >
              GitHub
            </a>
            <a
              href="https://www.linkedin.com/in/oscarvalles87/"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 rounded-full border border-[var(--border-subtle)] px-[22px] py-3 text-sm font-semibold text-[var(--text-primary)] transition-transform hover:-translate-y-px"
            >
              LinkedIn
            </a>
          </div>
        </motion.div>

        <p className="mt-16 text-center text-sm text-[var(--text-muted)]">
          © {new Date().getFullYear()} Oscar Valles
        </p>
      </section>
    </main>
  );
}

const projects = projectData.map((p) => ({
  title: p.title,
  desc: p.description,
  tech: p.technologies,
  category: p.category.toUpperCase(),
  image: p.imageUrl,
  github: p.githubUrl,
  demo: p.demoUrl,
}));
