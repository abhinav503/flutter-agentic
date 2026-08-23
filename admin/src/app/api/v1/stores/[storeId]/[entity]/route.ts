import { NextResponse } from "next/server";
import { BulkChangeError, upsertCatalog, MAX_UPSERT_ROWS, loadCatalog } from "@/lib/api/v1/catalog";
import { serializeCatalogRecord } from "@/lib/api/v1/serializers";
import {
  authorizeWrite,
  parseEntity,
  tooManyRows,
  tracedRoute,
  unknownEntity,
} from "@/lib/api/v1/catalog-route";

type Params = { params: Promise<{ storeId: string; entity: string }> };

// GET — the whole collection, in the same shape PUT accepts. Reads need the
// same access as writes here (owner or token): unlike the public storefront
// GETs this returns drafts, inactive coupons and external ids.
export async function GET(request: Request, { params }: Params) {
  const { storeId, entity: rawEntity } = await params;
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const auth = await authorizeWrite(request, storeId, 0);
  if ("response" in auth) return auth.response;
  return tracedRoute(`GET ${entity}`, storeId, auth.actor, async () => {
    const catalog = await loadCatalog(storeId);
    const items = [...catalog[entity].values()].map((r) => serializeCatalogRecord(entity, r));
    return NextResponse.json({ items });
  });
}

// POST — one record. Same upsert semantics as PUT with a single item; 201
// when it created, 200 when it matched an existing record.
export async function POST(request: Request, { params }: Params) {
  const { storeId, entity: rawEntity } = await params;
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const auth = await authorizeWrite(request, storeId, 1);
  if ("response" in auth) return auth.response;
  const body = await request.json().catch(() => null);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return NextResponse.json({ error: "Body must be a JSON object" }, { status: 400 });
  }
  return tracedRoute(`POST ${entity}`, storeId, auth.actor, async () => {
    const { results } = await upsertCatalog(storeId, entity, [body], {
      dryRun: false,
      actorUid: auth.actor.uid,
    });
    const result = results[0];
    if (result.action === "error") {
      return NextResponse.json({ error: result.errors[0], errors: result.errors }, { status: 422 });
    }
    const catalog = await loadCatalog(storeId);
    const record = catalog[entity].get(result.id);
    return NextResponse.json(
      { id: result.id, action: result.action, record: record ? serializeCatalogRecord(entity, record) : null },
      { status: result.action === "created" ? 201 : 200 },
    );
  });
}

// PUT — bulk upsert. `{ items: [...], dry_run?: true }`. Dry-run validates
// and reports what would happen without writing; the console's import
// dialog, the CLI and an agent loop all read the same plan.
export async function PUT(request: Request, { params }: Params) {
  const { storeId, entity: rawEntity } = await params;
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const body = await request.json().catch(() => null);
  const items = body?.items;
  if (!Array.isArray(items)) {
    return NextResponse.json({ error: "Body must be { items: [...] }" }, { status: 400 });
  }
  if (items.length > MAX_UPSERT_ROWS) return tooManyRows(items.length);
  const dryRun = body.dry_run === true;
  const auth = await authorizeWrite(request, storeId, dryRun ? 0 : items.length);
  if ("response" in auth) return auth.response;
  return tracedRoute(
    `PUT ${entity}`,
    storeId,
    auth.actor,
    async () => {
      try {
        const outcome = await upsertCatalog(storeId, entity, items, {
          dryRun,
          actorUid: auth.actor.uid,
          confirm: body.confirm === true,
        });
        return NextResponse.json({ dry_run: dryRun, ...outcome });
      } catch (e) {
        if (e instanceof BulkChangeError) {
          return NextResponse.json(
            { error: e.message, code: "confirm_required", updates: e.updates, existing: e.existing },
            { status: 409 },
          );
        }
        throw e;
      }
    },
    { rows: items.length, dry_run: dryRun },
  );
}
