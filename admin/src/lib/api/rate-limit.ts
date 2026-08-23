import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";

// Two limiters, for two kinds of caller.
//
// `consumeRateLimit` — in-memory, per serverless instance. Cheap and good
// enough for *authenticated* write routes, where the caller already holds a
// token and the aim is to stop a runaway agent loop, not an adversary.
//
// `consumeSharedRateLimit` — Firestore-backed fixed windows, shared across
// instances, for the *unauthenticated* routes (OAuth registration, token
// exchange, consent) where the only handle on a caller is its IP and a
// per-instance counter would be trivially bypassed by Vercel's fan-out.
// One read + one write per call inside a transaction; these routes see a
// few calls per connection, so the cost is nothing, and a flood is exactly
// what it stops.

const WINDOW_MS = 60_000;
const MAX_REQUESTS_PER_WINDOW = 120;
const MAX_ROWS_PER_WINDOW = 6_000;

type Bucket = { windowStart: number; requests: number; rows: number };
const buckets = new Map<string, Bucket>();

export class RateLimitError extends Error {
  readonly retryAfterSeconds: number;
  constructor(retryAfterMs: number) {
    super("Too many requests — slow down and retry");
    this.retryAfterSeconds = Math.max(1, Math.ceil(retryAfterMs / 1000));
  }
}

export function consumeRateLimit(key: string, rows = 1): void {
  const now = Date.now();
  let b = buckets.get(key);
  if (!b || now - b.windowStart >= WINDOW_MS) {
    b = { windowStart: now, requests: 0, rows: 0 };
    buckets.set(key, b);
  }
  b.requests += 1;
  b.rows += rows;
  if (b.requests > MAX_REQUESTS_PER_WINDOW || b.rows > MAX_ROWS_PER_WINDOW) {
    throw new RateLimitError(WINDOW_MS - (now - b.windowStart));
  }
  // Keep the map from growing without bound on a long-lived instance.
  if (buckets.size > 10_000) {
    for (const [k, v] of buckets) {
      if (now - v.windowStart >= WINDOW_MS) buckets.delete(k);
    }
  }
}

// The caller's address as Vercel presents it. Behind the platform's proxy
// the first x-forwarded-for entry is the client; absent both headers (a
// local run) everything shares one bucket, which is fine for a dev box.
export function clientIp(request: Request): string {
  const fwd = request.headers.get("x-forwarded-for");
  if (fwd) return fwd.split(",")[0].trim();
  return request.headers.get("x-real-ip") ?? "local";
}

export type SharedLimit = {
  // What the window is for — "oauth.register" — part of the doc id.
  name: string;
  limit: number;
  windowMs: number;
};

export const OAUTH_REGISTER_LIMIT: SharedLimit = { name: "oauth.register", limit: 20, windowMs: 60 * 60_000 };
export const OAUTH_TOKEN_LIMIT: SharedLimit = { name: "oauth.token", limit: 60, windowMs: 10 * 60_000 };
export const OAUTH_CONSENT_LIMIT: SharedLimit = { name: "oauth.consent", limit: 60, windowMs: 10 * 60_000 };
export const TOKEN_MINT_LIMIT: SharedLimit = { name: "tokens.mint", limit: 30, windowMs: 60 * 60_000 };

const safeKey = (s: string) => s.replace(/[^a-zA-Z0-9_.:-]/g, "_").slice(0, 120);

export async function consumeSharedRateLimit(spec: SharedLimit, key: string): Promise<void> {
  const now = Date.now();
  const window = Math.floor(now / spec.windowMs);
  const ref = adminDb.collection("rateLimits").doc(safeKey(`${spec.name}:${key}:${window}`));
  const count = await adminDb.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const current = ((snap.data()?.count as number) ?? 0) + 1;
    tx.set(
      ref,
      {
        count: FieldValue.increment(1),
        // A TTL policy on `expiresAt` (Firestore console → TTL) reaps the
        // window docs; until one is set they are tiny and harmless.
        expiresAt: Timestamp.fromMillis((window + 2) * spec.windowMs),
      },
      { merge: true },
    );
    return current;
  });
  if (count > spec.limit) {
    throw new RateLimitError((window + 1) * spec.windowMs - now);
  }
}

export function rateLimitResponse(e: RateLimitError): Response {
  return Response.json(
    { error: "rate_limited", error_description: e.message },
    { status: 429, headers: { "Retry-After": String(e.retryAfterSeconds) } },
  );
}
