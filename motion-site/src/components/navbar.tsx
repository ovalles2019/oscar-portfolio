'use client';

import { useState } from 'react';
import { useTheme } from '@/components/theme-provider';

const LINKS = [
  { href: '#skills', label: 'Skills' },
  { href: '#projects', label: 'Projects' },
  { href: '#weekly-digest', label: 'Digest' },
  { href: '#contact', label: 'Contact' },
];

export default function Navbar() {
  const { theme, toggle } = useTheme();
  const [open, setOpen] = useState(false);

  return (
    <header className="relative z-30 flex items-center justify-end border-b border-[var(--border-subtle)] px-5 py-4 md:justify-between md:px-10 lg:px-[80px] xl:px-[150px]">
      <button
        type="button"
        className="flex h-9 w-9 flex-col items-center justify-center gap-1.5 md:hidden"
        aria-label={open ? 'Close menu' : 'Open menu'}
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
      >
        <span
          className={`block h-0.5 w-[22px] rounded bg-[var(--text-primary)] transition-transform ${open ? 'translate-y-[7px] rotate-45' : ''}`}
        />
        <span
          className={`block h-0.5 w-[22px] rounded bg-[var(--text-primary)] transition-opacity ${open ? 'opacity-0' : ''}`}
        />
        <span
          className={`block h-0.5 w-[22px] rounded bg-[var(--text-primary)] transition-transform ${open ? '-translate-y-[7px] -rotate-45' : ''}`}
        />
      </button>

      <div
        className={`${open ? 'flex' : 'hidden'} absolute top-full left-0 right-0 flex-col items-stretch gap-5 border-b border-[var(--border-subtle)] bg-[var(--bg)] px-5 py-6 md:static md:flex md:flex-1 md:flex-row md:items-center md:justify-between md:gap-9 md:border-0 md:bg-transparent md:p-0`}
      >
        <nav className="flex flex-col items-center gap-4 md:flex-row md:gap-[22px]">
          {LINKS.map((link) => (
            <a
              key={link.href}
              href={link.href}
              onClick={() => setOpen(false)}
              className="text-[15px] font-medium text-[var(--text-primary)] opacity-90 hover:opacity-100"
            >
              {link.label}
            </a>
          ))}
        </nav>

        <div className="flex flex-col items-center gap-5 md:flex-row md:items-center md:gap-9">
          <button
            type="button"
            onClick={toggle}
            aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
          >
            <span
              className={`relative flex h-7 w-[52px] items-center justify-between rounded-full border border-[var(--border-subtle)] bg-[var(--bg-elevated)] px-[7px] ${theme === 'light' ? 'is-light' : ''}`}
            >
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className="relative z-[1] text-[var(--text-muted)]">
                <circle cx="12" cy="12" r="4" />
                <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41" />
              </svg>
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className="relative z-[1] text-[var(--text-muted)]">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
              </svg>
              <span
                className="absolute top-0.5 left-0.5 h-[22px] w-[22px] rounded-full bg-[var(--pill-white)] transition-transform duration-200"
                style={{ transform: theme === 'light' ? 'translateX(24px)' : 'translateX(0)' }}
              />
            </span>
          </button>

          <a
            href="#contact"
            onClick={() => setOpen(false)}
            className="inline-flex items-center justify-center gap-2 rounded-full bg-[var(--pill-white)] px-[18px] py-2.5 text-sm font-semibold text-[var(--pill-text)] transition-transform hover:-translate-y-px"
          >
            Contact Me
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12h14" />
              <path d="M12 5l7 7-7 7" />
            </svg>
          </a>
        </div>
      </div>
    </header>
  );
}
