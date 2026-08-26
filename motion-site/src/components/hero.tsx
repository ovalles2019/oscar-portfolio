const TECH = [
  { name: 'AWS', slug: 'amazonaws', color: 'FF9900' },
  { name: 'Kubernetes', slug: 'kubernetes', color: '326CE5' },
  { name: 'Terraform', slug: 'terraform', color: '844FBA' },
  { name: 'Docker', slug: 'docker', color: '2496ED' },
  { name: 'Python', slug: 'python', color: '3776AB' },
  { name: 'React', slug: 'react', color: '61DAFB' },
  { name: 'TypeScript', slug: 'typescript', color: '3178C6' },
  { name: 'Linux', slug: 'linux', color: 'FCC624' },
];

const STATS = [
  { value: '13+', label: 'Projects Built' },
  { value: '20+', label: 'Technologies' },
  { value: '12+', label: 'Live Demos' },
];

export default function Hero() {
  const loop = [...TECH, ...TECH];

  return (
    <section
      id="hero"
      className="mx-auto flex max-w-[1400px] flex-col items-center gap-10 px-5 py-12 md:px-10 md:py-16 lg:flex-row lg:justify-between lg:gap-10 lg:px-[80px] lg:py-[90px] xl:px-[150px]"
    >
      <div className="flex w-full max-w-[560px] flex-col items-center text-center lg:items-start lg:text-left">
        <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-[var(--border-subtle)] bg-[var(--bg-elevated)] px-4 py-2 text-[13px] font-medium text-[var(--text-primary)]">
          <span className="relative h-2 w-2 shrink-0 rounded-full bg-accent-green">
            <span className="badge-ping absolute inset-0 rounded-full bg-accent-green" />
          </span>
          Available for work
        </div>

        <h1 className="mb-5 text-[34px] font-bold leading-[1.1] text-[var(--text-primary)] md:text-5xl">
          Cloud Engineer &amp;{' '}
          <span className="text-aws">AWS</span> Full-Stack Developer.
        </h1>

        <p className="mb-8 max-w-xl text-[15px] leading-[1.7] text-[var(--text-muted)]">
          Hi, I&apos;m Oscar Valles — a Master&apos;s student in Computer
          Engineering at UTD. I architect production-grade{' '}
          <span className="font-medium text-aws">AWS</span> infrastructure,
          build AI-powered systems, and ship full-stack products people can
          actually use.
        </p>

        <div className="mb-10 flex flex-wrap items-center justify-center gap-3.5 lg:justify-start">
          <a
            href="#projects"
            className="inline-flex items-center gap-2 rounded-full border border-[var(--border-subtle)] px-[22px] py-3 text-sm font-semibold text-[var(--text-primary)] transition-transform hover:-translate-y-px"
          >
            See my projects
          </a>
          <a
            href="/resume.pdf"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 rounded-full border border-[var(--border-subtle)] px-[22px] py-3 text-sm font-semibold text-[var(--text-primary)] transition-transform hover:-translate-y-px"
          >
            Download CV
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 3v12" />
              <path d="M7 10l5 5 5-5" />
              <path d="M5 21h14" />
            </svg>
          </a>
          <a
            href="#contact"
            className="inline-flex items-center gap-2 rounded-full bg-[var(--pill-white)] px-[22px] py-3 text-sm font-semibold text-[var(--pill-text)] transition-transform hover:-translate-y-px"
          >
            Contact Me
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12h14" />
              <path d="M12 5l7 7-7 7" />
            </svg>
          </a>
        </div>

        <div className="mb-9 flex gap-8 lg:gap-9">
          {STATS.map((s) => (
            <div key={s.label} className="flex flex-col items-center gap-1 lg:items-center">
              <span className="text-[30px] font-extrabold leading-none text-accent-green">
                {s.value}
              </span>
              <span className="text-[12.5px] text-[var(--text-muted)]">{s.label}</span>
            </div>
          ))}
        </div>

        <div className="w-full max-w-[400px] overflow-hidden [mask-image:linear-gradient(to_right,transparent,black_15%,black_85%,transparent)]">
          <div className="hero-marquee flex w-max items-center gap-3.5">
            {loop.map((tech, i) => (
              <div
                key={`${tech.slug}-${i}`}
                title={tech.name}
                className="flex h-[60px] w-[60px] shrink-0 items-center justify-center rounded-[14px] border border-[var(--border-subtle)] bg-[var(--bg-elevated)]"
              >
                <img
                  src={`https://cdn.simpleicons.org/${tech.slug}/${tech.color}`}
                  alt={tech.name}
                  className="h-[30px] w-[30px]"
                />
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="w-full max-w-[560px] overflow-hidden rounded-3xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] aspect-square lg:flex-1">
        <img
          src="/oscar-photo.jpg"
          alt="Oscar Valles"
          className="h-full w-full object-cover"
        />
      </div>
    </section>
  );
}
