import { NextResponse } from 'next/server';

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function normalizeEnv(raw: string | undefined): string | undefined {
  if (!raw) return;
  let k = raw.trim().replace(/^\uFEFF/, '');
  if (
    (k.startsWith('"') && k.endsWith('"')) ||
    (k.startsWith("'") && k.endsWith("'"))
  ) {
    k = k.slice(1, -1).trim();
  }
  return k || undefined;
}

type Body = { email?: unknown; source?: unknown };

export async function POST(req: Request) {
  let body: Body;
  try {
    body = (await req.json()) as Body;
  } catch {
    return NextResponse.json({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const email = typeof body.email === 'string' ? body.email.trim().toLowerCase() : '';
  const source =
    typeof body.source === 'string' ? body.source.slice(0, 80) : 'portfolio';

  if (!email || !EMAIL_RE.test(email) || email.length > 254) {
    return NextResponse.json({ error: 'Enter a valid email address.' }, { status: 400 });
  }

  const resendKey = normalizeEnv(
    process.env.RESEND_API_KEY ?? process.env.RESEND_KEY
  );
  const segmentId = normalizeEnv(
    process.env.RESEND_SEGMENT_ID ?? process.env.RESEND_AUDIENCE_ID
  );
  const webhookUrl = normalizeEnv(process.env.SUBSCRIBE_WEBHOOK_URL);
  const notifyFrom = normalizeEnv(process.env.RESEND_FROM);
  const notifyTo = normalizeEnv(process.env.SUBSCRIBE_NOTIFY_TO);

  // 1) Preferred: Resend Contacts (+ optional Segment)
  // Docs: https://resend.com/docs/api-reference/contacts/create-contact
  if (resendKey) {
    const payload: Record<string, unknown> = {
      email,
      unsubscribed: false,
    };
    if (segmentId) {
      payload.segments = [{ id: segmentId }];
    }

    const res = await fetch('https://api.resend.com/contacts', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${resendKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    // 409 / already exists is fine for re-subscribe attempts
    if (res.ok || res.status === 409) {
      return NextResponse.json({
        message: 'You’re subscribed. The Monday digest will land in your inbox.',
      });
    }

    const errText = await res.text().catch(() => '');
    console.error('Resend contacts error', res.status, errText);

    // Legacy Audiences API fallback (still works while deprecated)
    if (segmentId) {
      const legacy = await fetch(
        `https://api.resend.com/audiences/${segmentId}/contacts`,
        {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${resendKey}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ email, unsubscribed: false }),
        }
      );
      if (legacy.ok || legacy.status === 409) {
        return NextResponse.json({
          message: 'You’re subscribed. The Monday digest will land in your inbox.',
        });
      }
      console.error(
        'Resend legacy audience error',
        legacy.status,
        await legacy.text().catch(() => '')
      );
    }

    return NextResponse.json(
      { error: 'Could not subscribe right now. Please try again later.' },
      { status: 502 }
    );
  }

  // 2) Optional: n8n webhook → Sheet / ESP
  if (webhookUrl) {
    const res = await fetch(webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email,
        source,
        subscribedAt: new Date().toISOString(),
      }),
    });

    if (!res.ok) {
      console.error('Subscribe webhook failed', res.status);
      return NextResponse.json(
        { error: 'Could not subscribe right now. Please try again later.' },
        { status: 502 }
      );
    }

    return NextResponse.json({
      message: 'You’re subscribed. Thanks for joining the weekly digest.',
    });
  }

  // 3) Notify-only fallback
  if (resendKey && notifyFrom && notifyTo) {
    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${resendKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: notifyFrom,
        to: [notifyTo],
        subject: `New digest subscriber: ${email}`,
        text: `New weekly digest signup\n\nEmail: ${email}\nSource: ${source}\nTime: ${new Date().toISOString()}`,
      }),
    });

    if (!res.ok) {
      console.error('Resend notify failed', res.status, await res.text().catch(() => ''));
      return NextResponse.json(
        { error: 'Could not subscribe right now. Please try again later.' },
        { status: 502 }
      );
    }

    return NextResponse.json({
      message:
        'Thanks — you’re on the waitlist. Weekly delivery turns on once the list is fully connected.',
    });
  }

  return NextResponse.json(
    {
      error:
        'Subscriptions are not configured yet. Set RESEND_API_KEY (or RESEND_KEY) in Netlify env (optional: RESEND_SEGMENT_ID).',
    },
    { status: 503 }
  );
}
