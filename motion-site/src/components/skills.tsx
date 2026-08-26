'use client';

import { Cloud, Code2, Layers, ShieldCheck } from 'lucide-react';
import { motion } from 'framer-motion';

const fadeUp = {
  hidden: { opacity: 0, y: 24 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { delay: i * 0.08, duration: 0.5, ease: 'easeOut' as const },
  }),
};

const HIGHLIGHTS = ['Cloud & AWS', 'DevOps & Automation', 'AI & Full-Stack'];

const ICONS = [
  { name: 'AWS', slug: 'amazonaws', color: 'FF9900' },
  { name: 'Kubernetes', slug: 'kubernetes', color: '326CE5' },
  { name: 'Docker', slug: 'docker', color: '2496ED' },
  { name: 'Terraform', slug: 'terraform', color: '844FBA' },
  { name: 'Python', slug: 'python', color: '3776AB' },
  { name: 'React', slug: 'react', color: '61DAFB' },
  { name: 'TypeScript', slug: 'typescript', color: '3178C6' },
  { name: 'GitHub', slug: 'github', color: '9CA3AF' },
  { name: 'Linux', slug: 'linux', color: 'FCC624' },
  { name: 'PostgreSQL', slug: 'postgresql', color: '4169E1' },
  { name: 'FastAPI', slug: 'fastapi', color: '009688' },
  { name: 'N8n', slug: 'n8n', color: 'EA4B71' },
];

const CAPS = [
  {
    icon: Cloud,
    title: 'Cloud Architecture',
    desc: 'AWS, Terraform, Kubernetes, CI/CD pipelines, and observability at scale.',
  },
  {
    icon: Layers,
    title: 'Product Engineering',
    desc: 'Full-stack systems that turn complex workflows into usable interfaces.',
  },
  {
    icon: Code2,
    title: 'Backend & APIs',
    desc: 'Service design, data modeling, and integrations across modern stacks.',
  },
  {
    icon: ShieldCheck,
    title: 'Execution Quality',
    desc: 'Refactoring discipline and code that stays maintainable after launch.',
  },
];

export default function Skills() {
  return (
    <section id="skills" className="bg-[var(--bg-alt)]">
      <div className="mx-auto flex max-w-[1400px] flex-col gap-12 px-5 py-20 md:px-10 lg:flex-row lg:items-center lg:gap-16 lg:px-[80px] lg:py-[100px] xl:px-[150px]">
        <div className="lg:w-[420px] lg:shrink-0">
          <motion.h2
            className="mb-5 text-4xl font-extrabold text-[var(--text-primary)] md:text-[44px]"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            Skills
          </motion.h2>
          <motion.p
            className="mb-5 text-[15px] leading-[1.75] text-[var(--text-muted)]"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={1}
          >
            Building scalable systems across the stack — from cloud
            infrastructure and CI/CD to full-stack apps, RAG pipelines, and
            agentic tooling.
          </motion.p>
          <motion.div
            className="flex flex-wrap gap-2.5"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={2}
          >
            {HIGHLIGHTS.map((h) => (
              <span
                key={h}
                className="rounded-full border border-[var(--border-subtle)] bg-[var(--bg-elevated)] px-4 py-2 text-[13px] font-semibold text-[var(--text-primary)]"
              >
                {h}
              </span>
            ))}
          </motion.div>
        </div>

        <div className="relative mx-auto grid h-[320px] w-full max-w-[520px] place-items-center sm:h-[420px] lg:h-[520px] lg:flex-1">
          {ICONS.map((icon, i) => {
            const angle = (i / ICONS.length) * Math.PI * 2 - Math.PI / 2;
            const radius = i % 3 === 0 ? 38 : i % 3 === 1 ? 28 : 18;
            return (
              <div
                key={icon.name}
                title={icon.name}
                className="absolute flex h-12 w-12 items-center justify-center rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] sm:h-14 sm:w-14"
                style={{
                  left: `${50 + Math.cos(angle) * radius}%`,
                  top: `${50 + Math.sin(angle) * radius}%`,
                  transform: 'translate(-50%, -50%)',
                }}
              >
                <img
                  src={`https://cdn.simpleicons.org/${icon.slug}/${icon.color}`}
                  alt={icon.name}
                  className="h-6 w-6 sm:h-7 sm:w-7"
                />
              </div>
            );
          })}
        </div>
      </div>

      <div className="mx-auto grid max-w-[1400px] gap-4 px-5 pb-20 md:grid-cols-2 md:px-10 lg:px-[80px] xl:px-[150px]">
        {CAPS.map((cap, i) => (
          <motion.div
            key={cap.title}
            className="rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] p-6 transition-colors hover:border-[var(--border-hover)]"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={i}
          >
            <div className="mb-4 flex h-10 w-10 items-center justify-center rounded-xl border border-[var(--border-subtle)] bg-[var(--bg)]">
              <cap.icon size={20} className="text-[var(--text-primary)]" />
            </div>
            <h3 className="mb-2 text-lg font-bold text-[var(--text-primary)]">
              {cap.title}
            </h3>
            <p className="text-sm leading-relaxed text-[var(--text-muted)]">
              {cap.desc}
            </p>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
