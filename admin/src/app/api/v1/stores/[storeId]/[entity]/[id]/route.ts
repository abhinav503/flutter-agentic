import { NextResponse } from "next/server";
import { deleteCatalogDoc, loadCatalog, upsertCatalog } from "@/lib/api/v1/catalog";
import { serializeCatalogRecord } from "@/lib/api/v1/serializers";
import { authorizeWrite, parseEntity, tracedRoute, unknownEntity } from "@/lib/api/v1/catalog-route";

type Params = { params: Promise<{ storeId: string; entity: string; id: string }> };

export async function GET(request: Request, { params }: Params) {
  const { storeId, entity: rawEntity, id } = await params;
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const auth = await authorizeWrite(request, storeId, 0);
  if ("response" in auth) return auth.response;
  return tracedRoute(`GET ${entity}/id`, storeId, auth.actor, async () => {
    const record = (await loadCatalog(storeId))[entity].get(id);
    if (!record) return NextResponse.json({ error: "Not found" }, { status: 404 });
    return NextResponse.json({ record: serializeCatalogRecord(entity, record) });
  });
}

// PATCH — partial update: only the fields present change. Implemented as an
// upsert pinned to this id, so it shares every validation rule with PUT.
export async function PATCH(request: Request, { params }: Params) {
  const { storeId, entity: rawEntity, id } = await params;
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const auth = await authorizeWrite(request, storeId, 1);
  if ("response" in auth) return auth.response;
  const body = await request.json().catch(() => null);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return NextResponse.json({ error: "Body must be a JSON object" }, { status: 400 });
  }
  return tracedRoute(`PATCH ${entity}/id`, storeId, auth.actor, async () => {
    const { results } = await upsertCatalog(storeId, entity, [{ ...body, id }], {
      dryRun: false,
      actorUid: auth.actor.uid,
    });
    const result = results[0];
    if (result.action === "error") {
      const status = result.errors[0]?.startsWith("No record with id") ? 404 : 422;
      return NextResponse.json({ error: result.errors[0], errors: result.errors }, { status });
    }
    const record = (await loadCatalog(storeId))[entity].get(id);
    return NextResponse.json({
      id,
      action: result.action,
      record: record ? serializeCatalogRecord(entity, record) : null,
    });
  });
}

export async function DELETE(request: Request, { params }: Params) {
  const { storeId, entity: rawEntity, id } = await params;
  const entity = parseEntity(rawEntity);
  if (!entity) return unknownEntity(rawEntity);
  const auth = await authorizeWrite(request, storeId, 1);
  if ("response" in auth) return auth.response;
  return tracedRoute(`DELETE ${entity}/id`, storeId, auth.actor, async () => {
    const found = await deleteCatalogDoc(storeId, entity, id, auth.actor.uid);
    if (!found) return NextResponse.json({ error: "Not found" }, { status: 404 });
    // Moved to the trash, restorable for 30 days — not gone.
    return new NextResponse(null, { status: 204 });
  });
}
