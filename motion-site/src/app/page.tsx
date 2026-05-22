'use client';

import { useEffect } from 'react';
import ScrollExpandMedia from '@/components/ui/scroll-expansion-hero';
import { motion } from 'framer-motion';
import {
  Cloud,
  Layers,
  Code2,
  ShieldCheck,
  ExternalLink,
  Mail,
  Download,
  ArrowUpRight,
} from 'lucide-react';

const fadeUp = {
  hidden: { opacity: 0, y: 30 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { delay: i * 0.1, duration: 0.6, ease: 'easeOut' as const },
  }),
};

export default function Home() {
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="min-h-screen bg-black">
      <ScrollExpandMedia
        mediaType="image"
        mediaSrc="/hero-card.png"
        bgImageSrc="/bg-poster.jpg"
        bgVideoSrc="/bg-video.mp4"
        scrollToExpand="↓ Scroll to Explore"
      >
        {/* ── About ─────────────────────────────────────── */}
        <section className="max-w-5xl mx-auto mb-32">
          <motion.p
            className="text-indigo-400 font-bold text-sm tracking-[0.2em] uppercase mb-4"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            ABOUT
          </motion.p>
          <motion.h2
            className="text-3xl md:text-5xl font-bold mb-6 text-white"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={1}
          >
            Building Cloud, AI, and Scalable Systems
          </motion.h2>
          <motion.p
            className="text-lg text-gray-400 max-w-3xl leading-relaxed"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={2}
          >
            I&apos;m a Master&apos;s student in Computer Engineering at UTD,
            focused on ML-powered and automated systems. I architect
            production-grade cloud infrastructure, build full-stack
            applications, and design interfaces that turn complex systems into
            something people can actually use.
          </motion.p>

          <motion.div
            className="flex flex-wrap gap-3 mt-8"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={3}
          >
            {['AWS', 'Kubernetes', 'Terraform', 'Python', 'React', 'Flutter', 'Docker', 'CI/CD'].map(
              (t) => (
                <span
                  key={t}
                  className="px-4 py-1.5 text-sm font-semibold rounded-full bg-indigo-500/10 text-indigo-300 border border-indigo-500/20"
                >
                  {t}
                </span>
              )
            )}
          </motion.div>

          <motion.div
            className="flex flex-wrap gap-4 mt-10"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={4}
          >
            <a
              href="/resume.pdf"
              target="_blank"
              className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-500 text-white font-bold text-sm hover:shadow-lg hover:shadow-indigo-500/25 transition-all"
            >
              <Download size={16} /> Download Resume
            </a>
            <a
              href="https://github.com/ovalles2019"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 px-6 py-3 rounded-xl border border-white/10 text-white font-bold text-sm hover:bg-white/5 transition-all"
            >
              <Code2 size={16} /> GitHub
            </a>
            <a
              href="https://www.linkedin.com/in/oscarvalles87/"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-2 px-6 py-3 rounded-xl border border-white/10 text-white font-bold text-sm hover:bg-white/5 transition-all"
            >
              <ExternalLink size={16} /> LinkedIn
            </a>
          </motion.div>
        </section>

        {/* ── Capabilities ──────────────────────────────── */}
        <section className="max-w-5xl mx-auto mb-32">
          <motion.p
            className="text-indigo-400 font-bold text-sm tracking-[0.2em] uppercase mb-4"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            CAPABILITIES
          </motion.p>
          <motion.h2
            className="text-3xl md:text-4xl font-bold mb-10 text-white"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={1}
          >
            Full-stack. Cloud-native. Production-ready.
          </motion.h2>

          <div className="grid md:grid-cols-2 gap-5">
            {[
              {
                icon: Cloud,
                title: 'Cloud Architecture',
                desc: 'AWS, Terraform, K8s, CI/CD pipelines, and observability at scale.',
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
            ].map((cap, i) => (
              <motion.div
                key={cap.title}
                className="group p-6 rounded-2xl bg-white/[0.03] border border-white/[0.06] hover:border-indigo-500/20 hover:bg-white/[0.05] transition-all duration-300"
                variants={fadeUp}
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true }}
                custom={i + 2}
              >
                <div className="w-10 h-10 rounded-xl bg-indigo-500/10 flex items-center justify-center mb-4 group-hover:bg-indigo-500/15 transition-colors">
                  <cap.icon size={20} className="text-indigo-400" />
                </div>
                <h3 className="text-lg font-bold text-white mb-2">
                  {cap.title}
                </h3>
                <p className="text-gray-400 text-sm leading-relaxed">
                  {cap.desc}
                </p>
              </motion.div>
            ))}
          </div>
        </section>

        {/* ── Projects ──────────────────────────────────── */}
        <section className="max-w-5xl mx-auto mb-32">
          <motion.p
            className="text-indigo-400 font-bold text-sm tracking-[0.2em] uppercase mb-4"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            SELECTED WORK
          </motion.p>
          <motion.h2
            className="text-3xl md:text-4xl font-bold mb-10 text-white"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={1}
          >
            Projects built for production.
          </motion.h2>

          <div className="grid md:grid-cols-2 gap-6">
            {projects.map((p, i) => (
              <motion.div
                key={p.title}
                className="group rounded-2xl overflow-hidden bg-white/[0.03] border border-white/[0.06] hover:border-indigo-500/20 transition-all duration-300"
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
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
                  <span className="absolute top-3 left-3 px-3 py-1 text-[10px] font-bold tracking-wider text-indigo-300 bg-black/60 rounded-md border border-indigo-500/20">
                    {p.category}
                  </span>
                </div>
                <div className="p-5">
                  <h3 className="text-lg font-bold text-white mb-2">
                    {p.title}
                  </h3>
                  <p className="text-gray-400 text-sm mb-4 line-clamp-2">
                    {p.desc}
                  </p>
                  <div className="flex flex-wrap gap-1.5 mb-4">
                    {p.tech.map((t) => (
                      <span
                        key={t}
                        className="px-2.5 py-1 text-[11px] font-semibold rounded-md bg-indigo-500/10 text-indigo-300 border border-indigo-500/15"
                      >
                        {t}
                      </span>
                    ))}
                  </div>
                  <div className="flex flex-wrap gap-x-5 gap-y-2 items-center">
                    {p.demo ? (
                      <a
                        href={p.demo}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 text-sm font-semibold text-emerald-400 hover:text-emerald-300 transition-colors"
                      >
                        Live Demo <ArrowUpRight size={14} />
                      </a>
                    ) : null}
                    <a
                      href={p.github}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center gap-1.5 text-sm font-semibold text-indigo-400 hover:text-indigo-300 transition-colors"
                    >
                      View Source <ArrowUpRight size={14} />
                    </a>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </section>

        {/* ── Contact CTA ───────────────────────────────── */}
        <section className="max-w-5xl mx-auto mb-20">
          <motion.div
            className="p-10 md:p-16 rounded-3xl bg-gradient-to-br from-indigo-500/[0.06] to-purple-500/[0.04] border border-indigo-500/10"
            variants={fadeUp}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">
              Let&apos;s build something together.
            </h2>
            <p className="text-gray-400 text-lg mb-8 max-w-xl">
              I&apos;m open to full-time roles, contract work, and
              collaborations in cloud engineering and product development.
            </p>
            <div className="flex flex-wrap gap-4">
              <a
                href="mailto:ovalles6845@gmail.com"
                className="inline-flex items-center gap-2 px-7 py-3.5 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-500 text-white font-bold text-sm hover:shadow-lg hover:shadow-indigo-500/25 transition-all"
              >
                <Mail size={16} /> Get in Touch
              </a>
              <a
                href="https://github.com/ovalles2019"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-7 py-3.5 rounded-xl border border-white/10 text-white font-bold text-sm hover:bg-white/5 transition-all"
              >
                <Code2 size={16} /> GitHub
              </a>
            </div>
          </motion.div>

          <p className="text-center text-gray-600 text-sm mt-16">
            © {new Date().getFullYear()} Oscar Valles
          </p>
        </section>
      </ScrollExpandMedia>
    </div>
  );
}

const projects: Array<{
  title: string;
  desc: string;
  tech: string[];
  category: string;
  image: string;
  github: string;
  demo?: string;
}> = [
  {
    title: 'FieldTech Assistant',
    desc: 'RAG-powered assistant for field technicians: manuals, wiring context, service history, QR asset lookup, offline-first PWA — FastAPI + React on Docker.',
    tech: ['FastAPI', 'React', 'ChromaDB', 'RAG', 'PWA'],
    category: 'FULL-STACK / AI',
    image:
      'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/fieldtech-assistant',
    demo: 'https://fieldtech-assistant.onrender.com/',
  },
  {
    title: 'ML Experiment Tracker MCP',
    desc: 'MCP server for experiment runs, metrics, hyperparameters, and tags with SQLite persistence—plus a live dashboard to browse and compare runs.',
    tech: ['Python', 'MCP', 'SQLite', 'Starlette'],
    category: 'ML & TOOLING',
    image:
      'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/ml-experiment-tracker-mcp',
    demo: 'https://ml-experiment-tracker-demo.onrender.com/',
  },
  {
    title: 'AWS CloudOps MCP',
    desc: 'Read-focused MCP server for AWS ops (EC2, CloudWatch, ELB, Lambda, S3) via boto3—plus a live dashboard with synthetic inventory for demos.',
    tech: ['Python', 'MCP', 'AWS', 'boto3'],
    category: 'MCP & CLOUD',
    image:
      'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/aws-cloudops-mcp',
    demo: 'https://aws-cloudops-demo.onrender.com/',
  },
  {
    title: 'Small Business Operations MCP',
    desc: 'MCP server for tasks, expenses, CRM, and inventory with finance CSV analytics (margins, payroll, anomalies) plus a live ops dashboard on Render.',
    tech: ['Python', 'MCP', 'SQLite', 'Starlette'],
    category: 'MCP & OPS',
    image:
      'https://images.unsplash.com/photo-1554224154-26032ffc0d07?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/small-biz-operations-mcp',
    demo: 'https://small-biz-ops-demo.onrender.com/',
  },
  {
    title: 'Budget Insights Platform',
    desc: 'Cloud-first personal finance platform with microservices, Kubernetes, and AWS.',
    tech: ['Kubernetes', 'AWS', 'React', 'Python'],
    category: 'CLOUD & FINANCE',
    image:
      'https://images.unsplash.com/photo-1579621970561-a9d2f37b04f4?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/budget-insights-platform',
  },
  {
    title: 'Geofences Platform',
    desc: 'Geofencing platform with Apple-inspired UI: create and monitor geofences, real-time notifications, track processing, and policy automation.',
    tech: ['Maps', 'Real-time', 'Notifications', 'Automation'],
    category: 'PRODUCT',
    image:
      'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/geofences-platform',
  },
  {
    title: 'pgvector RAG Demo',
    desc: 'Exploration of vector search and retrieval-augmented generation (RAG) using PostgreSQL pgvector.',
    tech: ['Python', 'PostgreSQL', 'pgvector', 'RAG'],
    category: 'ML & DATA',
    image:
      'https://images.unsplash.com/photo-1544383831-b04e9981b772?w=800&h=600&fit=crop&crop=center',
    github: 'https://github.com/ovalles2019/pgvector-rag-demo',
  },
];
