// Best-effort per-caller rate limiting for the v1 write routes. In-memory,
// so it is per serverless instance and resets on cold start — enough to
// stop a runaway agent loop from burning Firestore writes, not a security
// boundary (that is the token + scopes). Keyed by token id or owner uid.

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
