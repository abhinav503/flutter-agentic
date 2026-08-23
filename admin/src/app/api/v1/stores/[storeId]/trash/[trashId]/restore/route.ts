import { NextResponse } from "next/server";
import { guardErrorResponse, requireStoreAccess, type StoreActor } from "@/lib/api/admin-guard";
import { tracedRoute } from "@/lib/api/v1/catalog-route";
import { restoreFromTrash, TrashConflictError } from "@/lib/api/v1/catalog";

export async function POST(
  request: Request,
  { params }: { params: Promise<{ storeId: string; trashId: string }> },
) {
  const { storeId, trashId } = await params;
  let actor: StoreActor;
  try {
    actor = await requireStoreAccess(request, storeId, "catalog:write");
  } catch (e) {
    return guardErrorResponse(e);
  }
  return tracedRoute("POST trash/restore", storeId, actor, async () => {
    try {
      const restored = await restoreFromTrash(storeId, trashId);
      if (!restored) return NextResponse.json({ error: "Not in the trash" }, { status: 404 });
      return NextResponse.json({ restored });
    } catch (e) {
      if (e instanceof TrashConflictError) return NextResponse.json({ error: e.message }, { status: 409 });
      throw e;
    }
  });
}
