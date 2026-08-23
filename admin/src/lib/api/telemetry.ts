import { FieldValue } from "firebase-admin/firestore";
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

export async function recordApiEvent(event: ApiEvent): Promise<void> {
  console.log(
    JSON.stringify({
      event: `api.${event.surface}`,
      ts: new Date().toISOString(),
      ...event,
      actor: { kind: event.actor.kind, client: event.actor.client, uid: event.actor.uid },
    }),
  );

  try {
    const day = dayKey();
    const op = fieldSafe(event.operation);
    const client = fieldSafe(`${event.actor.kind}:${event.actor.client}`);
    // Nested maps merged, not dotted field paths: an operation like
    // "GET categories" holds a space, which a dotted path can't carry.
    const increments: Record<string, unknown> = {
      day,
      calls: { [op]: FieldValue.increment(1) },
      byClient: { [client]: FieldValue.increment(1) },
      totalCalls: FieldValue.increment(1),
      durationMs: FieldValue.increment(event.durationMs),
      updatedAt: FieldValue.serverTimestamp(),
      ...(event.ok
        ? {}
        : { errors: { [op]: FieldValue.increment(1) }, totalErrors: FieldValue.increment(1) }),
    };
    const summary = {
      lastCallAt: FieldValue.serverTimestamp(),
      lastOperation: event.operation,
      lastClient: `${event.actor.kind}:${event.actor.client}`,
      lastOk: event.ok,
      totalCalls: FieldValue.increment(1),
      ...(event.ok ? {} : { totalErrors: FieldValue.increment(1) }),
    };
    const batch = adminDb.batch();
    for (const scope of [event.storeId ?? PLATFORM_DOC, PLATFORM_DOC]) {
      const root = adminDb.collection("apiUsage").doc(scope);
      batch.set(root, summary, { merge: true });
      batch.set(root.collection("days").doc(day), increments, { merge: true });
      if (scope === PLATFORM_DOC) break;
    }
    await batch.commit();
  } catch (e) {
    console.error("telemetry write failed", e instanceof Error ? e.message : e);
  }
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
