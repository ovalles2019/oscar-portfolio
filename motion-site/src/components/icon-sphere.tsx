'use client';

import { useEffect, useMemo, useRef } from 'react';
import { TechIcon } from '@/components/tech-icon';

export type SphereIcon = {
  name: string;
  slug: string;
  color: string;
};

function fibonacciSphere(count: number) {
  const points: { x: number; y: number; z: number }[] = [];
  const golden = Math.PI * (3 - Math.sqrt(5));
  for (let i = 0; i < count; i++) {
    const y = count === 1 ? 0 : 1 - (i / (count - 1)) * 2;
    const r = Math.sqrt(Math.max(0, 1 - y * y));
    const theta = golden * i;
    points.push({
      x: Math.cos(theta) * r,
      y,
      z: Math.sin(theta) * r,
    });
  }
  return points;
}

export default function IconSphere({ icons }: { icons: SphereIcon[] }) {
  const wrapRef = useRef<HTMLDivElement>(null);
  const itemRefs = useRef<(HTMLDivElement | null)[]>([]);
  const rot = useRef({ x: 0.22, y: 0.4 });
  const vel = useRef({ x: 0, y: 0.0055 });
  const drag = useRef<{
    active: boolean;
    x: number;
    y: number;
  }>({ active: false, x: 0, y: 0 });
  const visible = useRef(true);
  const reduced = useRef(false);
  const points = useMemo(() => fibonacciSphere(icons.length), [icons.length]);

  useEffect(() => {
    const wrap = wrapRef.current;
    if (!wrap) return;

    reduced.current = window.matchMedia(
      '(prefers-reduced-motion: reduce)'
    ).matches;

    const io = new IntersectionObserver(
      ([entry]) => {
        visible.current = entry.isIntersecting;
      },
      { threshold: 0.05 }
    );
    io.observe(wrap);

    const paint = () => {
      const size = Math.min(wrap.clientWidth, wrap.clientHeight);
      const radius = size * 0.38;
      const persp = size * 1.35;
      const { x: rx, y: ry } = rot.current;
      const cosY = Math.cos(ry);
      const sinY = Math.sin(ry);
      const cosX = Math.cos(rx);
      const sinX = Math.sin(rx);

      points.forEach((p, i) => {
        const el = itemRefs.current[i];
        if (!el) return;
        const x1 = p.x * cosY - p.z * sinY;
        const z1 = p.x * sinY + p.z * cosY;
        const y2 = p.y * cosX - z1 * sinX;
        const z2 = p.y * sinX + z1 * cosX;
        const scale = persp / (persp - z2 * radius);
        const opacity = 0.28 + ((z2 + 1) / 2) * 0.72;
        el.style.transform = `translate(-50%, -50%) translate(${x1 * radius * scale}px, ${y2 * radius * scale}px) scale(${0.72 + ((z2 + 1) / 2) * 0.38})`;
        el.style.opacity = String(opacity);
        el.style.zIndex = String(Math.round((z2 + 1) * 50));
      });
    };

    let raf = 0;
    const loop = () => {
      if (visible.current && !reduced.current && !drag.current.active) {
        rot.current.y += vel.current.y;
        rot.current.x += vel.current.x;
        vel.current.x *= 0.94;
        vel.current.y += (0.0055 - vel.current.y) * 0.04;
      } else if (visible.current && !reduced.current && drag.current.active) {
        vel.current.x *= 0.92;
        vel.current.y *= 0.92;
      }
      rot.current.x = Math.max(-0.85, Math.min(0.85, rot.current.x));
      paint();
      raf = requestAnimationFrame(loop);
    };
    paint();
    raf = requestAnimationFrame(loop);

    const onDown = (e: PointerEvent) => {
      drag.current = { active: true, x: e.clientX, y: e.clientY };
      wrap.setPointerCapture(e.pointerId);
      wrap.style.cursor = 'grabbing';
    };
    const onMove = (e: PointerEvent) => {
      if (!drag.current.active) return;
      const dx = e.clientX - drag.current.x;
      const dy = e.clientY - drag.current.y;
      drag.current.x = e.clientX;
      drag.current.y = e.clientY;
      rot.current.y += dx * 0.008;
      rot.current.x -= dy * 0.008;
      vel.current.y = dx * 0.00045;
      vel.current.x = -dy * 0.00045;
    };
    const onUp = (e: PointerEvent) => {
      drag.current.active = false;
      wrap.releasePointerCapture(e.pointerId);
      wrap.style.cursor = 'grab';
    };

    wrap.addEventListener('pointerdown', onDown);
    wrap.addEventListener('pointermove', onMove);
    wrap.addEventListener('pointerup', onUp);
    wrap.addEventListener('pointercancel', onUp);

    return () => {
      cancelAnimationFrame(raf);
      io.disconnect();
      wrap.removeEventListener('pointerdown', onDown);
      wrap.removeEventListener('pointermove', onMove);
      wrap.removeEventListener('pointerup', onUp);
      wrap.removeEventListener('pointercancel', onUp);
    };
  }, [points]);

  return (
    <div
      ref={wrapRef}
      className="relative mx-auto h-[320px] w-full max-w-[520px] cursor-grab touch-none select-none sm:h-[420px] lg:h-[520px] lg:flex-1"
      role="img"
      aria-label={`Rotating skills sphere: ${icons.map((i) => i.name).join(', ')}`}
    >
      {icons.map((icon, i) => (
        <div
          key={icon.name}
          ref={(el) => {
            itemRefs.current[i] = el;
          }}
          title={icon.name}
          className="absolute top-1/2 left-1/2 flex h-12 w-12 items-center justify-center rounded-2xl border border-[var(--border-subtle)] bg-[var(--bg-elevated)] will-change-transform sm:h-14 sm:w-14"
        >
          <TechIcon
            name={icon.name}
            slug={icon.slug}
            color={icon.color}
            className="h-6 w-6 sm:h-7 sm:w-7"
          />
        </div>
      ))}
    </div>
  );
}
