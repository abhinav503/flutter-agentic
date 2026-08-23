import { NextResponse } from "next/server";
import {
  guardErrorResponse,
  requireStoreAccess,
  type StoreActor,
} from "@/lib/api/admin-guard";
import { consumeRateLimit, RateLimitError } from "@/lib/api/rate-limit";
import { traced } from "@/lib/api/telemetry";
import {
  CATALOG_ENTITIES,
  MAX_UPSERT_ROWS,
  type CatalogEntity,
} from "@/lib/api/v1/catalog";

// Shared plumbing for the v1 catalog routes: entity validation, the guard,
// the rate limit, and the error shapes, so each handler is only its verb.

export function parseEntity(raw: string): CatalogEntity | null {
  return (CATALOG_ENTITIES as readonly string[]).includes(raw)
    ? (raw as CatalogEntity)
    : null;
}

export function unknownEntity(raw: string) {
  return NextResponse.json(
    { error: `Unknown entity "${raw}" — one of ${CATALOG_ENTITIES.join(", ")}` },
    { status: 404 },
  );
}

export async function authorizeWrite(
  request: Request,
  storeId: string,
  rows: number,
): Promise<{ actor: StoreActor } | { response: Response }> {
  try {
    const actor = await requireStoreAccess(request, storeId, "catalog:write");
    consumeRateLimit(actor.kind === "token" ? `t:${actor.tokenId}` : `u:${actor.uid}`, rows);
    return { actor };
  } catch (e) {
    if (e instanceof RateLimitError) {
      return {
        response: NextResponse.json(
          { error: e.message },
          { status: 429, headers: { "Retry-After": String(e.retryAfterSeconds) } },
        ),
      };
    }
    return { response: guardErrorResponse(e) };
  }
}

// Runs a v1 handler body under one telemetry event, with the outcome read
// off the Response it returns.
export function tracedRoute(
  operation: string,
  storeId: string,
  actor: StoreActor,
  fn: () => Promise<Response>,
  meta?: Record<string, string | number | boolean>,
): Promise<Response> {
  const client =
    actor.kind === "owner" ? "owner" : actor.kind === "token" ? actor.tokenId.slice(0, 8) : actor.tokenId.slice(0, 8);
  return traced(
    { surface: "v1", operation, storeId, actor: { kind: actor.kind, uid: actor.uid, client }, meta },
    fn,
    (res) => ({ ok: res.status < 400, status: res.status }),
  );
}

export function tooManyRows(count: number) {
  return NextResponse.json(
    { error: `items holds ${count} rows; at most ${MAX_UPSERT_ROWS} per request` },
    { status: 413 },
  );
}
