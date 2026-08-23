import { NextResponse } from "next/server";
import { guardErrorResponse, requireStoreAccess } from "@/lib/api/admin-guard";
import { submitStoreForReview, SubmitError } from "@/lib/store-publish";

// POST — submit the store for review. Owner or a token with store:publish.
// Approve/reject/unpublish are superadmin-only and stay on the console
// route; a store token can never move a store past "pending".
export async function POST(
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
    return NextResponse.json(await submitStoreForReview(storeId));
  } catch (e) {
    if (e instanceof SubmitError) {
      return NextResponse.json(
        { error: e.message, ...(e.checks.length ? { checks: e.checks } : {}) },
        { status: e.status },
      );
    }
    throw e;
  }
}
