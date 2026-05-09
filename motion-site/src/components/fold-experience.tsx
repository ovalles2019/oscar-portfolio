'use client';

import { useLayoutEffect, useRef } from 'react';
import Image from 'next/image';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export default function FoldExperience() {
  const rootRef = useRef<HTMLElement>(null);
  const stageRef = useRef<HTMLDivElement>(null);
  const leftRef = useRef<HTMLDivElement>(null);
  const rightRef = useRef<HTMLDivElement>(null);
  const line1Ref = useRef<HTMLParagraphElement>(null);
  const line2Ref = useRef<HTMLParagraphElement>(null);
  const line3Ref = useRef<HTMLParagraphElement>(null);
  const line4Ref = useRef<HTMLParagraphElement>(null);
  const tagRef = useRef<HTMLParagraphElement>(null);
  const creditRef = useRef<HTMLParagraphElement>(null);

  useLayoutEffect(() => {
    const root = rootRef.current;
    const stage = stageRef.current;
    const left = leftRef.current;
    const right = rightRef.current;
    if (!root || !stage || !left || !right) return;

    const reduced =
      typeof window !== 'undefined' &&
      window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (reduced) {
      gsap.set([left, right], { rotateY: 0 });
      gsap.set([line1Ref.current, line2Ref.current, line3Ref.current, line4Ref.current], {
        opacity: 1,
        y: 0,
      });
      gsap.set(tagRef.current, { opacity: 1 });
      gsap.set(creditRef.current, { opacity: 1 });
      return;
    }

    gsap.set(left, { transformPerspective: 1400, rotateY: -86 });
    gsap.set(right, { transformPerspective: 1400, rotateY: 86 });

    const tl = gsap.timeline({
      defaults: { ease: 'none' },
      scrollTrigger: {
        trigger: root,
        start: 'top top',
        end: '+=320%',
        scrub: 0.85,
        pin: stage,
        anticipatePin: 1,
      },
    });

    tl.to(left, { rotateY: 0, duration: 1 }, 0)
      .to(right, { rotateY: 0, duration: 1 }, 0)
      .fromTo(
        line1Ref.current,
        { opacity: 0.15, y: 40 },
        { opacity: 1, y: 0, duration: 0.35 },
        0.05
      )
      .fromTo(
        line2Ref.current,
        { opacity: 0, y: 28 },
        { opacity: 1, y: 0, duration: 0.35 },
        0.18
      )
      .fromTo(
        line3Ref.current,
        { opacity: 0, y: 22 },
        { opacity: 1, y: 0, duration: 0.35 },
        0.32
      )
      .fromTo(
        line4Ref.current,
        { opacity: 0, y: 18 },
        { opacity: 1, y: 0, duration: 0.35 },
        0.46
      )
      .fromTo(
        tagRef.current,
        { opacity: 0, y: 12 },
        { opacity: 1, y: 0, duration: 0.4 },
        0.58
      )
      .fromTo(
        creditRef.current,
        { opacity: 0 },
        { opacity: 0.85, duration: 0.35 },
        0.72
      );

    requestAnimationFrame(() => ScrollTrigger.refresh());

    return () => {
      tl.scrollTrigger?.kill();
      tl.kill();
    };
  }, []);

  return (
    <section
      ref={rootRef}
      className='relative h-[420vh] bg-black text-white'
      aria-label='Fold concept section'
    >
      <div
        ref={stageRef}
        className='relative flex min-h-screen flex-col items-center justify-center gap-12 overflow-hidden px-6 py-16'
      >
        <div className='pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_50%_40%,rgba(99,102,241,0.12),transparent_55%)]' />

        <div
          className='relative z-[5] shrink-0'
          style={{ perspective: '1400px' }}
        >
          <div className='relative mx-auto w-[min(340px,88vw)] aspect-[10/21] rounded-[2.75rem] border border-white/[0.14] bg-zinc-950/80 shadow-[0_40px_120px_-40px_rgba(99,102,241,0.35)]'>
            <div className='absolute inset-[10px] flex overflow-hidden rounded-[2.2rem]'>
              <div
                ref={leftRef}
                className='relative h-full w-1/2 origin-right overflow-hidden border-r border-white/[0.06]'
                style={{ transformStyle: 'preserve-3d', backfaceVisibility: 'hidden' }}
              >
                <div className='absolute inset-0 bg-gradient-to-br from-indigo-600/40 via-zinc-900 to-black' />
                <div className='absolute inset-0 opacity-90'>
                  <Image
                    src='/hero-card.png'
                    alt=''
                    fill
                    className='object-cover object-left scale-[1.02]'
                    sizes='(max-width: 768px) 160px, 180px'
                  />
                </div>
              </div>
              <div
                ref={rightRef}
                className='relative h-full w-1/2 origin-left overflow-hidden'
                style={{ transformStyle: 'preserve-3d', backfaceVisibility: 'hidden' }}
              >
                <div className='absolute inset-0 bg-gradient-to-bl from-purple-600/35 via-zinc-900 to-black' />
                <div className='absolute inset-0 opacity-90'>
                  <Image
                    src='/hero-card.png'
                    alt=''
                    fill
                    className='object-cover object-right scale-[1.02]'
                    sizes='(max-width: 768px) 160px, 180px'
                  />
                </div>
              </div>
            </div>
            <div className='pointer-events-none absolute left-1/2 top-2 bottom-2 z-10 w-px -translate-x-1/2 bg-gradient-to-b from-transparent via-white/25 to-transparent' />
          </div>
        </div>

        <div className='relative z-10 flex flex-col items-center text-center'>
          <p
            ref={line1Ref}
            className='font-bold tracking-[0.35em] text-indigo-400/90 text-xs md:text-sm uppercase'
          >
            Fold
          </p>
          <p
            ref={line2Ref}
            className='mt-4 font-semibold text-white/95 text-5xl md:text-8xl tracking-tight'
          >
            {new Date().getFullYear()}
          </p>
          <p
            ref={line3Ref}
            className='mt-6 font-semibold text-white/90 text-4xl md:text-7xl tracking-tight'
          >
            Oscar
          </p>
          <p
            ref={line4Ref}
            className='font-semibold text-white/90 text-4xl md:text-7xl tracking-tight'
          >
            Valles
          </p>
          <p
            ref={tagRef}
            className='mt-10 max-w-md text-sm md:text-base leading-relaxed text-white/55'
          >
            A concept that opens when the work asks for more — cloud systems,
            interfaces, and automation at production depth.
          </p>
          <p
            ref={creditRef}
            className='mt-14 font-medium tracking-[0.25em] text-white/35 text-xs uppercase'
          >
            Motion · Next.js · GSAP
          </p>
        </div>

        <p className='relative z-10 mt-auto pb-6 font-medium tracking-[0.2em] text-white/25 text-[11px] uppercase'>
          Fin
        </p>
      </div>
    </section>
  );
}
