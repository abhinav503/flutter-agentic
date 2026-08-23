import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { adminDb } from "@/lib/firebase-admin";

// Observability for the programmable surface (v1 routes + the MCP server),
// in two layers that answer different questions:
//
// 1. One structured JSON line per call to stdout → Vercel runtime logs (and
//    any log drain attached to the project). Every field, every call —
//    what you read when something misbehaves.
// 2. Daily tallies in Firestore: apiUsage/{storeId}/days/{yyyy-mm-dd} with
//    per-operation call/error counts and per-client counts, plus a summary
//    doc per store with the last call. Durable and cheap (a handful of
//    increments per call), and what the console shows an owner — "Claude
//    imported 278 products on Tuesday".
//
// Tallies are coalesced: increments accumulate in a per-instance buffer
// and flush together when the buffer is old enough or full enough —
// inside a request, never after it, since a serverless instance may be
// frozen the moment the response is sent. A flood of calls then costs a
// few writes per flush instead of four per call, and no single document
// (the platform roll-up above all) takes a write per request. The price
// is that an instance recycled mid-window loses its unflushed slice — at
// most FLUSH_AFTER_MS of counts, which the log lines still carry.
//
// Recording never fails a request: a telemetry write that throws is logged
// and swallowed.

export type ApiSurface = "v1" | "mcp";

export type ApiActorInfo = {
  kind: "owner" | "token" | "oauth";
  uid: string;
  // A readable handle for who called: the OAuth client's name, the API
  // token's prefix, or "owner" for the console.
  client: string;
};

export type ApiEvent = {
  surface: ApiSurface;
  // The tool name (mcp) or `METHOD entity` (v1).
  operation: string;
  storeId: string | null;
  actor: ApiActorInfo;
  ok: boolean;
  status?: number;
  error?: string;
  durationMs: number;
  // Small, call-specific facts worth keeping beside the line: row counts,
  // formats, entity — never payloads.
  meta?: Record<string, string | number | boolean>;
};

const PLATFORM_DOC = "_platform";

function dayKey(d = new Date()): string {
  return d.toISOString().slice(0, 10);
}

// Firestore field paths can't contain "." or "/"; a tool name never does,
// but a client name might.
const fieldSafe = (s: string) => s.replace(/[.$\[\]#/]/g, "_").slice(0, 60) || "unknown";

const FLUSH_AFTER_MS = 10_000;
const FLUSH_AT_EVENTS = 50;

type Tally = {
  calls: Record<string, number>;
  errors: Record<string, number>;
  byClient: Record<string, number>;
  totalCalls: number;
  totalErrors: number;
  durationMs: number;
  last?: { at: Date; operation: string; client: string; ok: boolean };
};

// Keyed by "<scope>/<day>"; the platform roll-up is one more entry.
const pending = new Map<string, Tally>();
let pendingEvents = 0;
let pendingSince = 0;
let flushing: Promise<void> | null = null;

function tally(key: string): Tally {
  let t = pending.get(key);
  if (!t) {
    t = { calls: {}, errors: {}, byClient: {}, totalCalls: 0, totalErrors: 0, durationMs: 0 };
    pending.set(key, t);
  }
  return t;
}

export async function recordApiEvent(event: ApiEvent): Promise<void> {
  console.log(
    JSON.stringify({
      event: `api.${event.surface}`,
      ts: new Date().toISOString(),
      ...event,
      actor: { kind: event.actor.kind, client: event.actor.client, uid: event.actor.uid },
    }),
  );

  const day = dayKey();
  const op = fieldSafe(event.operation);
  const client = fieldSafe(`${event.actor.kind}:${event.actor.client}`);
  for (const scope of new Set([event.storeId ?? PLATFORM_DOC, PLATFORM_DOC])) {
    const t = tally(`${scope}/${day}`);
    t.calls[op] = (t.calls[op] ?? 0) + 1;
    t.byClient[client] = (t.byClient[client] ?? 0) + 1;
    t.totalCalls++;
    t.durationMs += event.durationMs;
    if (!event.ok) {
      t.errors[op] = (t.errors[op] ?? 0) + 1;
      t.totalErrors++;
    }
    t.last = {
      at: new Date(),
      operation: event.operation,
      client: `${event.actor.kind}:${event.actor.client}`,
      ok: event.ok,
    };
  }
  pendingEvents++;
  if (!pendingSince) pendingSince = Date.now();
  if (pendingEvents >= FLUSH_AT_EVENTS || Date.now() - pendingSince >= FLUSH_AFTER_MS) {
    await flushTelemetry();
  }
}

// Writes everything buffered so far. Safe to call at any time; concurrent
// callers share one in-flight flush.
export function flushTelemetry(): Promise<void> {
  if (flushing) return flushing;
  if (pending.size === 0) return Promise.resolve();
  const snapshot = new Map(pending);
  pending.clear();
  pendingEvents = 0;
  pendingSince = 0;
  flushing = (async () => {
    try {
      const batch = adminDb.batch();
      const inc = (m: Record<string, number>) =>
        Object.fromEntries(Object.entries(m).map(([k, v]) => [k, FieldValue.increment(v)]));
      for (const [key, t] of snapshot) {
        const [scope, day] = key.split("/");
        const root = adminDb.collection("apiUsage").doc(scope);
        batch.set(
          root.collection("days").doc(day),
          {
            day,
            calls: inc(t.calls),
            byClient: inc(t.byClient),
            totalCalls: FieldValue.increment(t.totalCalls),
            durationMs: FieldValue.increment(t.durationMs),
            updatedAt: FieldValue.serverTimestamp(),
            ...(t.totalErrors
              ? { errors: inc(t.errors), totalErrors: FieldValue.increment(t.totalErrors) }
              : {}),
          },
          { merge: true },
        );
        // The store summary answers "what happened last" in the console;
        // the platform roll-up only needs its days, so no single document
        // takes a write per flush across every store.
        if (scope !== PLATFORM_DOC && t.last) {
          batch.set(
            root,
            {
              lastCallAt: Timestamp.fromDate(t.last.at),
              lastOperation: t.last.operation,
              lastClient: t.last.client,
              lastOk: t.last.ok,
              totalCalls: FieldValue.increment(t.totalCalls),
              ...(t.totalErrors ? { totalErrors: FieldValue.increment(t.totalErrors) } : {}),
            },
            { merge: true },
          );
        }
      }
      await batch.commit();
    } catch (e) {
      console.error("telemetry flush failed", e instanceof Error ? e.message : e);
    } finally {
      flushing = null;
    }
  })();
  return flushing;
}

// Runs `fn`, records one event around it, returns its result. Errors are
// recorded with their class and rethrown — a telemetry wrapper must never
// change what the caller sees.
export async function traced<T>(
  base: Omit<ApiEvent, "ok" | "durationMs" | "error" | "status">,
  fn: () => Promise<T>,
  outcome?: (result: T) => { ok: boolean; status?: number; error?: string; meta?: ApiEvent["meta"] },
): Promise<T> {
  const started = Date.now();
  try {
    const result = await fn();
    const o = outcome ? outcome(result) : { ok: true };
    void recordApiEvent({
      ...base,
      ...o,
      meta: { ...base.meta, ...o.meta },
      durationMs: Date.now() - started,
    });
    return result;
  } catch (e) {
    void recordApiEvent({
      ...base,
      ok: false,
      error: e instanceof Error ? `${e.constructor.name}: ${e.message}` : String(e),
      durationMs: Date.now() - started,
    });
    throw e;
  }
}

// Reads, for the console's Developers tab: the last 30 days for a store.
export type ApiUsageDay = {
  day: string;
  totalCalls: number;
  totalErrors: number;
  calls: Record<string, number>;
  errors: Record<string, number>;
  byClient: Record<string, number>;
};

export async function getApiUsage(storeId: string, days = 30): Promise<{
  lastCallAt: string;
  lastOperation: string;
  lastClient: string;
  totalCalls: number;
  totalErrors: number;
  days: ApiUsageDay[];
}> {
  const root = adminDb.collection("apiUsage").doc(storeId);
  const since = dayKey(new Date(Date.now() - days * 86_400_000));
  const [summary, daySnaps] = await Promise.all([
    root.get(),
    root.collection("days").where("day", ">=", since).orderBy("day", "desc").get(),
  ]);
  const s = summary.data() ?? {};
  const last = s.lastCallAt;
  return {
    lastCallAt: last && typeof last.toMillis === "function" ? new Date(last.toMillis()).toISOString() : "",
    lastOperation: (s.lastOperation as string) ?? "",
    lastClient: (s.lastClient as string) ?? "",
    totalCalls: (s.totalCalls as number) ?? 0,
    totalErrors: (s.totalErrors as number) ?? 0,
    days: daySnaps.docs.map((d) => {
      const x = d.data();
      return {
        day: x.day as string,
        totalCalls: (x.totalCalls as number) ?? 0,
        totalErrors: (x.totalErrors as number) ?? 0,
        calls: (x.calls as Record<string, number>) ?? {},
        errors: (x.errors as Record<string, number>) ?? {},
        byClient: (x.byClient as Record<string, number>) ?? {},
      };
    }),
  };
}
