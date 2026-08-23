import { NextResponse } from "next/server";
import { guardErrorResponse, requireStoreAccess } from "@/lib/api/admin-guard";
import { readinessWithPreviewFlag, SubmitError } from "@/lib/store-publish";

// The seven publish checks plus the store's status — what a CLI prints
// before `publish`, and what an agent loops on until everything passes.
export async function GET(
  request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  try {
    await requireStoreAccess(request, storeId, "store:publish");
  } catch (e) {
    return guardErrorResponse(e);
  }
  try {
    return NextResponse.json(await readinessWithPreviewFlag(storeId));
  } catch (e) {
    if (e instanceof SubmitError) return NextResponse.json({ error: e.message }, { status: e.status });
    throw e;
  }
}
