import { NextResponse } from "next/server";
import { guardErrorResponse, requireStoreAccess, type StoreActor } from "@/lib/api/admin-guard";
import { tracedRoute } from "@/lib/api/v1/catalog-route";
import { listTrash, TRASH_RETENTION_DAYS } from "@/lib/api/v1/catalog";

// What was deleted in the last 30 days, newest first — restorable until
// purgeAt.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  let actor: StoreActor;
  try {
    actor = await requireStoreAccess(request, storeId, "catalog:write");
  } catch (e) {
    return guardErrorResponse(e);
  }
  return tracedRoute("GET trash", storeId, actor, async () => {
    const entries = await listTrash(storeId);
    return NextResponse.json({
      retention_days: TRASH_RETENTION_DAYS,
      items: entries.map((t) => ({
        id: t.id,
        entity: t.entity,
        record_id: t.docId,
        name: t.name,
        deleted_at: t.deletedAtMs ? new Date(t.deletedAtMs).toISOString() : "",
        deleted_by: t.deletedBy,
        purge_at: t.purgeAtMs ? new Date(t.purgeAtMs).toISOString() : "",
      })),
    });
  });
}
